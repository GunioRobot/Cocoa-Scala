#import "cocoa_OCClass.h"
#import "ScalaBridge.h"
#import <JavaNativeFoundation/JavaNativeFoundation.h>
#import <ffi/ffi.h>

/*
 * Class:     cocoa_OCClass
 * Method:    attach
 * Signature: (Ljava/lang/String;Z)V
 */
JNIEXPORT void JNICALL Java_cocoa_OCClass_attach(JNIEnv* env, jobject this, jstring jClassName, jboolean meta) {
	JNF_COCOA_ENTER(env);
	const char* uClassName = JNFGetStringUTF8Chars(env, jClassName);
    id oClass = meta ? objc_getMetaClass(uClassName) : objc_getClass(uClassName);
    JNFReleaseStringUTF8Chars(env, jClassName, uClassName);
	if (oClass == nil) {
		CSB_STATIC JNF_CLASS_CACHE(jExClass, "cocoa/OCClassNotFoundException");
		CSB_STATIC JNF_CTOR_CACHE(jCons, jExClass, "(Ljava/lang/String;)V");
		jthrowable jEx = JNFNewObject(env, jCons, jClassName);
		(*env)->Throw(env, jEx);
	}
	else {
		CSB_STATIC JNF_CLASS_CACHE(jNativeProxyClass, "cocoa/NativeProxy");
		CSB_STATIC JNF_MEMBER_CACHE(jNptrField, jNativeProxyClass, "nptr", "J");
		JNFSetLongField(env, this, jNptrField, ptr_to_jlong(oClass));
		CFRetain(oClass); // necessary? probably not
	}	
	JNF_COCOA_EXIT(env);
}

/*
 * Class:     cocoa___Class
 * Method:    respondsToSelector
 * Signature: (Ljava/lang/String;)Z
 */
JNIEXPORT jboolean JNICALL Java_cocoa_OCClass_respondsToSelector(JNIEnv* env, jobject this, jstring jSelName) {
	jboolean res = false;
	JNF_COCOA_ENTER(env);
	id self = (id) CSBUnwrapProxy(env, this);
	SEL sel = CSBJStringToSEL(env, jSelName);
	res = [self respondsToSelector:sel];
	JNF_COCOA_EXIT(env);
	return res;
}

/*
 * Class:     cocoa___Class
 * Method:    findSuperClass
 * Signature: ()Lcocoa/OCClass;
 */
JNIEXPORT jobject JNICALL Java_cocoa_OCClass_findSuperClass(JNIEnv* env, jobject this) {
	jobject res = nil;
	JNF_COCOA_ENTER(env);
	Class oClass = (Class) CSBUnwrapProxy(env, this);
	Class oSuperClass = class_getSuperclass(oClass);
	NSLog(@"findSuperClass %s/%d => %s/%d", class_getName(oClass), class_isMetaClass(oClass), class_getName(oSuperClass), class_isMetaClass(oSuperClass));
	res = CSBGetClassProxy(env, oSuperClass);
	JNF_COCOA_EXIT(env);
	return res;
}

/*
 * Class:     cocoa_OCClass
 * Method:    isMetaClass
 * Signature: ()Z
 */
JNIEXPORT jboolean JNICALL Java_cocoa_OCClass_isMetaClass(JNIEnv* env, jobject this) {
	jboolean res = false;
	JNF_COCOA_ENTER(env);
	Class oClass = (Class) CSBUnwrapProxy(env, this);
	res = class_isMetaClass(oClass);
	JNF_COCOA_EXIT(env);
	return res;
}

/*
 * Class:     cocoa___Class
 * Method:    className
 * Signature: ()Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_cocoa_OCClass_className(JNIEnv* env, jobject this) {
	jstring res = nil;
	JNF_COCOA_ENTER(env);
	Class oClass = (Class) CSBUnwrapProxy(env, this);
	const char* uClassName = class_getName(oClass);
	res = (*env)->NewStringUTF(env, uClassName);
	JNF_COCOA_EXIT(env);
	return res;
}

/*
 * Class:     cocoa_OCClass
 * Method:    alloc
 * Signature: ()Lcocoa/$ID;
 */
JNIEXPORT jobject JNICALL Java_cocoa_OCClass_alloc(JNIEnv* env, jobject this) {
//	Class class = (Class) CSBUnwrapProxy(env, this);
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
JNIEXPORT jobject JNICALL Java_cocoa_OCClass_cocoa_00024OCClass_00024_00024findMethod(JNIEnv* env, jobject this, jobject jSel) {
	jobject res = nil;
	JNF_COCOA_ENTER(env);
	Class oClass = (Class) CSBUnwrapProxy(env, this);
	SEL sel = (SEL) CSBUnwrapProxy(env, jSel);
	NSLog(@"findMethod %s %s", class_getName(oClass), sel);
	Method oMethod = class_getInstanceMethod(oClass, sel);
	jobject jReturnType;
	jobjectArray jArgTypes;
	int argCount = 0; // does not include self and sel
	jclass ocTypeClass = (*env)->FindClass(env, "cocoa/OCType");
	jmethodID codeMeth = (*env)->GetMethodID(env, ocTypeClass, "code", "()C");
	IMP imp;
	ffi_cif* cif = nil;
	
	NSLog(@"sel=%s", sel);
	
	if (oMethod) {
		NSLog(@"typeEncoding=%s", method_getTypeEncoding(oMethod));
		argCount = method_getNumberOfArguments(oMethod) - 2;
		char* typeName = method_copyReturnType(oMethod);
		jReturnType = CSBGetOCType(env, typeName);
		NSLog(@"typeName=%s, typeObj=%p", typeName, jReturnType);
		free(typeName);
		jArgTypes = (*env)->NewObjectArray(env, argCount, ocTypeClass, nil);
		
		for (int i = 0; i < argCount; i++) {
			typeName = method_copyArgumentType(oMethod, i + 2);
			jobject argTypeJObj = CSBGetOCType(env, typeName);
			free(typeName);
			if ((*env)->ExceptionOccurred(env)) return nil;
			(*env)->SetObjectArrayElement(env, jArgTypes, i, argTypeJObj);
		}
		
		imp = method_getImplementation(oMethod);
	}
	else {
		// try using [self methodSignatureForSelector: sel] instead
		return nil;
	}
	
	if (argCount > 0) {
		cif = (ffi_cif*)malloc(sizeof(ffi_cif));
		ffi_type* ffiReturnType = OCTypeCodeToFFIType((*env)->CallCharMethod(env, jReturnType, codeMeth));
		ffi_type* ffiArgTypes[argCount + 2];
		
		ffiArgTypes[0] = &ffi_type_pointer;
		ffiArgTypes[1] = &ffi_type_pointer;
		
		for (int i = 0; i < argCount; i++) {
			jobject argTypeJObj = (*env)->GetObjectArrayElement(env, jArgTypes, i);
			jchar octypeCode = (*env)->CallCharMethod(env, argTypeJObj, codeMeth);
			ffiArgTypes[i + 2] = OCTypeCodeToFFIType(octypeCode);
		}
		
		ffi_status status = ffi_prep_cif(cif, FFI_DEFAULT_ABI, argCount + 2, ffiReturnType, ffiArgTypes);
		
		if (status) {
			NSLog(@"ffi_prep_cif returned %d", status);
			return nil;
		}
	}
	
	jobject boxedArgTypesJObj = CSBBoxObjectArray(env, jArgTypes);
	CSB_STATIC JNF_CLASS_CACHE(jMethodClz, "cocoa/Method");
	CSB_STATIC JNF_CTOR_CACHE(jMethodCtor, jMethodClz, "(Lcocoa/Selector;Lcocoa/OCType;Lscala/Seq;JJ)V");
	res = JNFNewObject(env, jMethodCtor, jSel, jReturnType, boxedArgTypesJObj, 
						   ptr_to_jlong(cif), ptr_to_jlong(imp));

	JNF_COCOA_EXIT(env);
	return res;
}
