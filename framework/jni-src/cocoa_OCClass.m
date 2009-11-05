#include "cocoa_OCClass.h"
#include "ScalaBridge.h"
#include <ffi/ffi.h>

/*
 * Class:     cocoa_OCClass
 * Method:    attach
 * Signature: (Ljava/lang/String;Z)V
 */
JNIEXPORT void JNICALL Java_cocoa_OCClass_attach(JNIEnv* env, jobject this, jstring classNameJStr, jboolean meta) {
	const char* classNameUTF = (*env)->GetStringUTFChars(env, classNameJStr, JNI_FALSE);
    id objcClass = meta ? objc_getMetaClass(classNameUTF) : objc_getClass(classNameUTF);
    (*env)->ReleaseStringUTFChars(env, classNameJStr, classNameUTF);
	if (objcClass == nil) {
		jclass exClass = (*env)->FindClass(env, "cocoa/OCClassNotFoundException");
		jmethodID constructorID = (*env)->GetMethodID(env, exClass, "<init>", "(Ljava/lang/String;)V");
		jthrowable ex = (*env)->NewObject(env, exClass, constructorID, classNameJStr);
		(*env)->Throw(env, ex);
	}
	else {
		jclass nativeProxyClass = (*env)->FindClass(env, "cocoa/NativeProxy");
		jfieldID nptrField = (*env)->GetFieldID(env, nativeProxyClass, "nptr", "J");
		(*env)->SetLongField(env, this, nptrField, ptr_to_jlong(objcClass));
		CFRetain(objcClass); // necessary? probably not
	}	
}

/*
 * Class:     cocoa___Class
 * Method:    respondsToSelector
 * Signature: (Ljava/lang/String;)Z
 */
JNIEXPORT jboolean JNICALL Java_cocoa_OCClass_respondsToSelector(JNIEnv* env, jobject this, jstring sel_jstr) {
	id self = (id) UnwrapProxy(env, this);
    const char* selUTF8  = (*env)->GetStringUTFChars(env, sel_jstr, JNI_FALSE);
	jboolean res = [self respondsToSelector:sel_getUid(selUTF8)];
    (*env)->ReleaseStringUTFChars(env, sel_jstr, selUTF8);
	return res;
}

/*
 * Class:     cocoa___Class
 * Method:    superClass
 * Signature: ()Lcocoa/OCClass;
 */
JNIEXPORT jobject JNICALL Java_cocoa_OCClass_superClass(JNIEnv* env, jobject this) {
	Class class = (Class) UnwrapProxy(env, this);
	Class superClass = class_getSuperclass(class);
	return GetClassProxy(env, superClass);
}

/*
 * Class:     cocoa_OCClass
 * Method:    isMetaClass
 * Signature: ()Z
 */
JNIEXPORT jboolean JNICALL Java_cocoa_OCClass_isMetaClass(JNIEnv* env, jobject this) {
	Class class = (Class) UnwrapProxy(env, this);
	return class_isMetaClass(class);
}

/*
 * Class:     cocoa___Class
 * Method:    className
 * Signature: ()Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_cocoa_OCClass_className(JNIEnv* env, jobject this) {
	Class class = (Class) UnwrapProxy(env, this);
	const char* classNameUTF = class_getName(class);
	return (*env)->NewStringUTF(env, classNameUTF);
}

/*
 * Class:     cocoa_OCClass
 * Method:    alloc
 * Signature: ()Lcocoa/$ID;
 */
JNIEXPORT jobject JNICALL Java_cocoa_OCClass_alloc(JNIEnv* env, jobject this) {
//	Class class = (Class) UnwrapProxy(env, this);
	return nil;
}

ffi_type* OCTypeCodeToFFIType(jchar octypeCode) {
	switch (octypeCode) {
		case 'v': return &ffi_type_void;
		case 'c': return &ffi_type_schar;
		case 'C': return &ffi_type_uchar;
		case 's': return &ffi_type_sint16;
		case 'S': return &ffi_type_uint16;
		case 'i': return &ffi_type_sint32;
		case 'I': return &ffi_type_uint32;
		case 'q': return &ffi_type_sint64;
		case 'Q': return &ffi_type_uint64;
		case 'f': return &ffi_type_float;
		case 'd': return &ffi_type_double;
		default: return &ffi_type_pointer;
	}
}

/*
 * Class:     cocoa_OCClass
 * Method:    cocoa_00024OCClass_00024_00024findMethod
 * Signature: (Lcocoa/Selector;)Lcocoa/Method;
 */
JNIEXPORT jobject JNICALL Java_cocoa_OCClass_cocoa_00024OCClass_00024_00024findMethod(JNIEnv* env, jobject this, jobject selJObj) {
	Class class = (Class) UnwrapProxy(env, this);
	SEL sel = (SEL) UnwrapProxy(env, selJObj);
	Method method = class_getInstanceMethod(class, sel);
	jobject returnTypeJObj;
	jobjectArray argTypesJArr;
	int argCount = 0; // does not include self and sel
	jclass ocTypeClass = (*env)->FindClass(env, "cocoa/OCType");
	jmethodID codeMeth = (*env)->GetMethodID(env, ocTypeClass, "code", "()C");
	IMP imp;
	ffi_cif* cif = nil;
	
	NSLog(@"sel=%s", sel);
	
	if (method) {
		NSLog(@"typeEncoding=%s", method_getTypeEncoding(method));
		argCount = method_getNumberOfArguments(method) - 2;
		char* typeName = method_copyReturnType(method);
		returnTypeJObj = GetOCType(env, typeName);
		NSLog(@"typeName=%s, typeObj=%p", typeName, returnTypeJObj);
		free(typeName);
		argTypesJArr = (*env)->NewObjectArray(env, argCount, ocTypeClass, nil);
		
		for (int i = 0; i < argCount; i++) {
			typeName = method_copyArgumentType(method, i + 2);
			jobject argTypeJObj = GetOCType(env, typeName);
			free(typeName);
			if ((*env)->ExceptionOccurred(env)) return nil;
			(*env)->SetObjectArrayElement(env, argTypesJArr, i, argTypeJObj);
		}
		
		imp = method_getImplementation(method);
	}
	else {
		// try using [self methodSignatureForSelector: sel] instead
		return nil;
	}
	
	if (argCount > 0) {
		cif = (ffi_cif*)malloc(sizeof(ffi_cif));
		ffi_type* ffiReturnType = OCTypeCodeToFFIType((*env)->CallCharMethod(env, returnTypeJObj, codeMeth));
		ffi_type* ffiArgTypes[argCount + 2];
		
		ffiArgTypes[0] = &ffi_type_pointer;
		ffiArgTypes[1] = &ffi_type_pointer;
		
		for (int i = 0; i < argCount; i++) {
			jobject argTypeJObj = (*env)->GetObjectArrayElement(env, argTypesJArr, i);
			jchar octypeCode = (*env)->CallCharMethod(env, argTypeJObj, codeMeth);
			ffiArgTypes[i + 2] = OCTypeCodeToFFIType(octypeCode);
		}
		
		ffi_status status = ffi_prep_cif(cif, FFI_DEFAULT_ABI, argCount + 2, ffiReturnType, ffiArgTypes);
		
		if (status) {
			NSLog(@"ffi_prep_cif returned %d", status);
			return nil;
		}
	}
	
	jobject boxedArgTypesJObj = BoxObjectArray(env, argTypesJArr);
	jclass methodClass = (*env)->FindClass(env, "cocoa/Method");
	jmethodID methodCons = (*env)->GetMethodID(env, methodClass, "<init>", 
											 "(Lcocoa/Selector;Lcocoa/OCType;Lscala/Seq;JJ)V");
	jobject methodJObj = (*env)->NewObject(env, methodClass, methodCons, selJObj, returnTypeJObj, boxedArgTypesJObj, 
										   ptr_to_jlong(cif), ptr_to_jlong(imp));

	return methodJObj;
}
