#include "cocoa_Bridge__.h"
#include "ScalaBridge.h"

/*
 * Class:     cocoa_Bridge__
 * Method:    stringToNSString
 * Signature: (Ljava/lang/String;)Lcocoa/NSString;
 */
JNIEXPORT jobject JNICALL Java_cocoa_Bridge_00024_stringToNSString(JNIEnv* env, jobject bridge, jstring string) {
	id nsstring = JStringToNSString(env, string);
	return NewProxy(env, nsstring, "cocoa/NSString");
}

/*
 * Class:     cocoa_Bridge__
 * Method:    nsStringToString
 * Signature: (Lcocoa/NSString;)Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_cocoa_Bridge_00024_nsStringToString(JNIEnv* env, jobject bridge, jobject proxy) {
	return NSStringToJString(env, (id)UnwrapProxy(env, proxy));
}

/*
 * Class:     cocoa_Bridge__
 * Method:    cocoa_00024Bridge_00024_00024findClass
 * Signature: (Ljava/lang/String;)Lcocoa/OCClass;
 */
JNIEXPORT jobject JNICALL Java_cocoa_Bridge_00024_cocoa_00024Bridge_00024_00024findClass(JNIEnv* env, jobject bridge, jstring jclassName, jboolean meta) {
    const char* classNameUTF = (*env)->GetStringUTFChars(env, jclassName, JNI_FALSE);
    id objcClass = meta ? objc_getMetaClass(classNameUTF) : objc_getClass(classNameUTF);
    (*env)->ReleaseStringUTFChars(env, jclassName, classNameUTF);
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
 * Class:     cocoa_Bridge__
 * Method:    getClass
 * Signature: (Lcocoa/$ID;)Lcocoa/OCClass;
 */
JNIEXPORT jobject JNICALL Java_cocoa_Bridge_00024_getClass(JNIEnv* env, jobject bridge, jobject proxy) {
	if (proxy == nil) {
		return nil;
	}
	else {
		return GetClassProxy(env, ((id)UnwrapProxy(env, proxy))->isa);
	}
}
