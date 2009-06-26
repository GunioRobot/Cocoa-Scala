//
//  ScalaBridge.m
//  CocoaScala
//
//  Created by Jeremy Cloud on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ScalaBridge.h"

jobject NewProxy(JNIEnv* env, id self, const char* proxyClassName) {
    jclass proxyClass = (*env)->FindClass(env, proxyClassName);
    jmethodID constructorID = (*env)->GetMethodID(env, proxyClass, "<init>", "()V");
    jobject proxy = (*env)->NewObject(env, proxyClass, constructorID);
	jclass idClass = (*env)->FindClass(env, "cocoa/$ID");
    jfieldID nptrField = (*env)->GetFieldID(env, idClass, "nptr", "J");
	(*env)->SetLongField(env, proxy, nptrField, NPTR_TO_JLONG(self));
	CFRetain(self);
	return proxy;
}

jobject GetClassProxy(JNIEnv* env, const char* nsClassName) {
	NSLog(@"GetClassProxy %s", nsClassName);
	jclass bridgeClass = (*env)->FindClass(env, "cocoa/OCBridge$");
	jfieldID moduleField = (*env)->GetStaticFieldID(env, bridgeClass, "MODULE$", "Lcocoa/OCBridge$;");
	jobject bridge = (*env)->GetStaticObjectField(env, bridgeClass, moduleField);
	jmethodID getClassMethod = (*env)->GetMethodID(env, bridgeClass, "getClass", "(Ljava/lang/String;)Lcocoa/OCClass;");
	jstring classNameJStr = (*env)->NewStringUTF(env, nsClassName);
	jobject proxy = (*env)->CallObjectMethod(env, bridge, getClassMethod, classNameJStr);
	return proxy;
}

id JObjectToID(JNIEnv* env, jobject this) {
	jclass idClass = (*env)->FindClass(env, "cocoa/$ID");
    jfieldID nptrID = (*env)->GetFieldID(env, idClass, "nptr", "J");
    return (id) JLONG_TO_NPTR((*env)->GetLongField(env, this, nptrID));	
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
