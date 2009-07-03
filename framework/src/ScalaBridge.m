//
//  ScalaBridge.m
//  CocoaScala
//
//  Created by Jeremy Cloud on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ScalaBridge.h"

jobject GetBridge(JNIEnv* env, jclass bridgeClass) {
	jfieldID moduleField = (*env)->GetStaticFieldID(env, bridgeClass, "MODULE$", "Lcocoa/Bridge$;");
	return (*env)->GetStaticObjectField(env, bridgeClass, moduleField);
}

jobject NewProxy(JNIEnv* env, id self, const char* proxyClassName) {
    jclass proxyClass = (*env)->FindClass(env, proxyClassName);
    jmethodID constructorID = (*env)->GetMethodID(env, proxyClass, "<init>", "()V");
    jobject proxy = (*env)->NewObject(env, proxyClass, constructorID);
	jclass nativeProxyClass = (*env)->FindClass(env, "cocoa/NativeProxy");
    jfieldID nptrField = (*env)->GetFieldID(env, nativeProxyClass, "nptr", "J");
	(*env)->SetLongField(env, proxy, nptrField, NPTR_TO_JLONG(self));
	CFRetain(self);
	return proxy;
}

void* UnwrapProxy(JNIEnv* env, jobject this) {
	jclass nativeProxyClass = (*env)->FindClass(env, "cocoa/NativeProxy");
    jfieldID nptrField = (*env)->GetFieldID(env, nativeProxyClass, "nptr", "J");
	jlong nptr = (*env)->GetLongField(env, this, nptrField);
	return JLONG_TO_NPTR(nptr);
}

jobject GetClassProxy(JNIEnv* env, Class class) {
	if (class == nil) {
		return nil;
	}
	else {
		const char* classNameUTF = class_getName(class);
		jstring classNameJStr = (*env)->NewStringUTF(env, classNameUTF);	
		jclass bridgeClass = (*env)->FindClass(env, "cocoa/Bridge$");
		jobject bridge = GetBridge(env, bridgeClass);
		jboolean isMetaClass = class_isMetaClass(class);
		const char* getterName = isMetaClass ? "getMetaClass" : "getClass";
		jmethodID getterMethod = (*env)->GetMethodID(env, bridgeClass, getterName, "(Ljava/lang/String;)Lcocoa/OCClass;");
		jobject proxy = (*env)->CallObjectMethod(env, bridge, getterMethod, classNameJStr);
		return proxy;
	}
}

jobject NSStringToJString(JNIEnv* env, NSString* nsstr) {
    const char* utf8str = [nsstr UTF8String];
    return (*env)->NewStringUTF(env, utf8str);
}

NSString* JStringToNSString(JNIEnv* env, jstring jstr) {
    const char* utf8str  = (*env)->GetStringUTFChars(env, jstr, JNI_FALSE);
    NSString* nsstr = [NSString stringWithUTF8String: utf8str];
    (*env)->ReleaseStringUTFChars(env, jstr, utf8str);
    return nsstr;
}

SEL JStringToSEL(JNIEnv* env, jstring selJStr) {
    const char* selUTF = (*env)->GetStringUTFChars(env, selJStr, JNI_FALSE);
	SEL sel = sel_getUid(selUTF);
    (*env)->ReleaseStringUTFChars(env, selJStr, selUTF);
	return sel;
}

jobject GetOCType(JNIEnv* env, const char* descr) {
	jclass class = (*env)->FindClass(env, "cocoa/OCType$");
	jfieldID moduleField = (*env)->GetStaticFieldID(env, class, "MODULE$", "Lcocoa/OCType$;");
	jobject ocTypeJObj = (*env)->GetStaticObjectField(env, class, moduleField);
	jmethodID applyMethod = (*env)->GetMethodID(env, class, "apply", "(Ljava/lang/String;)Lcocoa/OCType;");
	jstring descrJStr = (*env)->NewStringUTF(env, descr);
	return (*env)->CallObjectMethod(env, ocTypeJObj, applyMethod, descrJStr);
}

jobject BoxObjectArray(JNIEnv* env, jobjectArray array) {
	jclass class = (*env)->FindClass(env, "scala/runtime/BoxedObjectArray");
	jmethodID cons = (*env)->GetMethodID(env, class, "<init>", "([Ljava/lang/Object;)V");
	return (*env)->NewObject(env, class, cons, array);
}

jobject BoxInt(JNIEnv* env, jint p) {
	jclass class = (*env)->FindClass(env, "java/lang/Integer");
	jmethodID cons = (*env)->GetMethodID(env, class, "<init>", "(I)V");
	return (*env)->NewObject(env, class, cons, p);
}

jobject BoxLong(JNIEnv* env, jlong p) {
	jclass class = (*env)->FindClass(env, "java/lang/Long");
	jmethodID cons = (*env)->GetMethodID(env, class, "<init>", "(J)V");
	return (*env)->NewObject(env, class, cons, p);
}

jobject BoxFloat(JNIEnv* env, jfloat p) {
	jclass class = (*env)->FindClass(env, "java/lang/Float");
	jmethodID cons = (*env)->GetMethodID(env, class, "<init>", "(F)V");
	return (*env)->NewObject(env, class, cons, p);
}

jobject BoxDouble(JNIEnv* env, jdouble p) {
	jclass class = (*env)->FindClass(env, "java/lang/Double");
	jmethodID cons = (*env)->GetMethodID(env, class, "<init>", "(D)V");
	return (*env)->NewObject(env, class, cons, p);
}


