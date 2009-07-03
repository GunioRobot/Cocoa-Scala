#include "cocoa_OCClass.h"
#include "ScalaBridge.h"
#include <ffi/ffi.h>

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

/*
 * Class:     cocoa_OCClass
 * Method:    cocoa_00024OCClass_00024_00024lookupMethod
 * Signature: (Lcocoa/Selector;)Lcocoa/Method;
 */
JNIEXPORT jobject JNICALL Java_cocoa_OCClass_cocoa_00024OCClass_00024_00024lookupMethod(JNIEnv* env, jobject this, jobject selJObj) {
	Class class = (Class) UnwrapProxy(env, this);
	SEL sel = (SEL) UnwrapProxy(env, selJObj);
	Method method = class_getInstanceMethod(class, sel);
	jobject returnTypeJObj;
	jobjectArray argTypesJArr;
	jclass ocTypeClass = (*env)->FindClass(env, "cocoa/OCType");
	IMP imp;
	
	NSLog(@"sel=%s", sel);
	
	if (method) {
//		NSLog(@"typeEncoding=%s", method_getTypeEncoding(method));
		int argCount = method_getNumberOfArguments(method) - 2;
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
	
	jobject boxedArgTypesJObj = BoxObjectArray(env, argTypesJArr);
	jclass methodClass = (*env)->FindClass(env, "cocoa/Method");
	jmethodID methodCons = (*env)->GetMethodID(env, methodClass, "<init>", 
											 "(Lcocoa/Selector;Lcocoa/OCType;Lscala/Seq;JJ)V");
	jobject methodJObj = (*env)->NewObject(env, methodClass, methodCons, selJObj, returnTypeJObj, boxedArgTypesJObj, 
										   0LL, NPTR_TO_JLONG(imp));

	return methodJObj;
}
