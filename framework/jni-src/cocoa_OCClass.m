#include "cocoa_OCClass.h"
#include "ScalaBridge.h"

/*
 * Class:     cocoa___Class
 * Method:    respondsToSelector
 * Signature: (Ljava/lang/String;)Z
 */
JNIEXPORT jboolean JNICALL Java_cocoa_OCClass_respondsToSelector(JNIEnv* env, jobject this, jstring sel_jstr) {
	id self = JObjectToID(env, this);
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
	Class self = (Class) JObjectToID(env, this);
	Class superClass = class_getSuperclass(self);
	if (superClass == nil) {
		return nil;
	}
	else {
		const char* superClassName = class_getName(superClass);
		return GetClassProxy(env, superClassName);
	}
}

/*
 * Class:     cocoa___Class
 * Method:    className
 * Signature: ()Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_cocoa_OCClass_className(JNIEnv* env, jobject this) {
	Class self = (Class) JObjectToID(env, this);
	const char* classNameUTF = class_getName(self);
	return (*env)->NewStringUTF(env, classNameUTF);
}

