#include "cocoa_OCBridge__.h"
#include "ScalaBridge.h"

/*
 * Class:     cocoa_OCBridge__
 * Method:    stringToNSString
 * Signature: (Ljava/lang/String;)Lcocoa/NSString;
 */
JNIEXPORT jobject JNICALL Java_cocoa_OCBridge_00024_stringToNSString(JNIEnv* env, jobject bridge, jstring string) {
	id nsstring = JStringToNSString(env, string);
	return NewProxy(env, nsstring, "cocoa/NSString");
}

/*
 * Class:     cocoa_OCBridge__
 * Method:    nsStringToString
 * Signature: (Lcocoa/NSString;)Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_cocoa_OCBridge_00024_nsStringToString(JNIEnv* env, jobject bridge, jobject proxy) {
	return NSStringToJString(env, JObjectToID(env, proxy));
}

/*
 * Class:     cocoa_OCBridge__
 * Method:    cocoa_00024OCBridge_00024_00024findClass
 * Signature: (Ljava/lang/String;)Lcocoa/OCClass;
 */
JNIEXPORT jobject JNICALL Java_cocoa_OCBridge_00024_cocoa_00024OCBridge_00024_00024findClass(JNIEnv* env, jobject bridge, jstring jclassName) {
    const char* oclassName = (*env)->GetStringUTFChars(env, jclassName, JNI_FALSE);
    id objcClass = objc_getClass(oclassName);
    (*env)->ReleaseStringUTFChars(env, jclassName, oclassName);
	if (objcClass == nil) {
		jclass exClass = (*env)->FindClass(env, "cocoa/OCClassNotFoundException");
		jmethodID constructorID = (*env)->GetMethodID(env, exClass, "<init>", "(Ljava/lang/String;)V");
		jthrowable ex = (*env)->NewObject(env, exClass, constructorID, jclassName);
		(*env)->Throw(env, ex);
		return nil;
	}
	else {
		return NewProxy(env, objcClass, "cocoa/OCClass");
	}	
}

/*
 * Class:     cocoa_OCBridge__
 * Method:    getClass
 * Signature: (Lcocoa/$ID;)Lcocoa/OCClass;
 */
JNIEXPORT jobject JNICALL Java_cocoa_OCBridge_00024_getClass(JNIEnv* env, jobject bridge, jobject proxy) {
	Class objcClass = [JObjectToID(env, proxy) class];
	const char* classNameUTF = class_getName(objcClass);
	return GetClassProxy(env, classNameUTF);
}


