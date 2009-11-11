//
//  ScalaBridge.m
//  CocoaScala
//
//  Created by Jeremy Cloud on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ScalaBridge.h"
#import <JavaNativeFoundation/JavaNativeFoundation.h>

jobject CSBGetBridge(JNIEnv* env) {
	CSB_STATIC JNF_CLASS_CACHE(jBridgeClass, "cocoa/Bridge$");
	CSB_STATIC JNF_STATIC_MEMBER_CACHE(jModuleField, jBridgeClass, "MODULE$", "Lcocoa/Bridge$;");
	CSB_STATIC jobject jBridge = nil;
	if (!jBridge) {
		jBridge = JNFNewGlobalRef(env, JNFGetStaticObjectField(env, jModuleField));
	}
	return jBridge;
}

jobject CSBNewProxy(JNIEnv* env, id self) {
	CSB_STATIC JNF_CLASS_CACHE(jBridgeClass, "cocoa/Bridge$");
	CSB_STATIC JNF_MEMBER_CACHE(jNewProxyMethod, jBridgeClass, "newProxy", "(Ljava/lang/String;)Lcocoa/$ID;");
	CSB_STATIC JNF_CLASS_CACHE(jNativeProxyClass, "cocoa/NativeProxy");
	CSB_STATIC JNF_MEMBER_CACHE(jNptrField, jNativeProxyClass, "nptr", "J");

	if (self == nil) {
		return nil;
	}
	else {
		jobject jBridge = CSBGetBridge(env);
		jstring jClassName = (*env)->NewStringUTF(env, object_getClassName(self));
		jobject jProxy = JNFCallObjectMethod(env, jBridge, jNewProxyMethod, jClassName);
		JNFSetLongField(env, jProxy, jNptrField, ptr_to_jlong(self));
		CFRetain(self);
		return jProxy;
	}
}

void* CSBUnwrapProxy(JNIEnv* env, jobject this) {
	CSB_STATIC JNF_CLASS_CACHE(jNativeProxyClass, "cocoa/NativeProxy");
    CSB_STATIC JNF_MEMBER_CACHE(jNptrField, jNativeProxyClass, "nptr", "J");
	jlong nptr = JNFGetLongField(env, this, jNptrField);
	return jlong_to_ptr(nptr);
}

jobject CSBGetClassProxy(JNIEnv* env, Class oClass) {
	CSB_STATIC JNF_CLASS_CACHE(jBridgeClass, "cocoa/Bridge$");
	CSB_STATIC JNF_MEMBER_CACHE(jGetClassMethod, jBridgeClass, "getClass", "(Ljava/lang/String;)Lcocoa/OCClass;");
	CSB_STATIC JNF_MEMBER_CACHE(jGetMetaClassMethod, jBridgeClass, "getMetaClass", "(Ljava/lang/String;)Lcocoa/OCClass;");

	if (oClass == nil) {
		return nil;
	}
	else {
		jobject jBridge = CSBGetBridge(env);
		const char* uClassName = class_getName(oClass);
		jstring jClassName = (*env)->NewStringUTF(env, uClassName);
		jboolean isMetaClass = class_isMetaClass(oClass);
		return JNFCallObjectMethod(env, jBridge, isMetaClass ? jGetMetaClassMethod: jGetClassMethod, jClassName);
	}
}

SEL CSBJStringToSEL(JNIEnv* env, jstring jSelName) {
    const char* uSelName = JNFGetStringUTF8Chars(env, jSelName);
	SEL sel = sel_getUid(uSelName);
    JNFReleaseStringUTF8Chars(env, jSelName, uSelName);
	return sel;
}

jobject CSBGetOCType(JNIEnv* env, const char* uDescr) {
	CSB_STATIC JNF_CLASS_CACHE(jOCTypeClass, "cocoa/OCType$");
	CSB_STATIC JNF_STATIC_MEMBER_CACHE(jModuleField, jOCTypeClass, "MODULE$", "Lcocoa/OCType$;");
	CSB_STATIC JNF_MEMBER_CACHE(jApplyMethod, jOCTypeClass, "apply", "(Ljava/lang/String;)Lcocoa/OCType;");
	CSB_STATIC jobject jOCType = NULL;
	if (!jOCType) jOCType = JNFGetStaticObjectField(env, jModuleField);
	jstring jDescr = (*env)->NewStringUTF(env, uDescr);
	return JNFCallObjectMethod(env, jOCType, jApplyMethod, jDescr);
}

jobject CSBBoxObjectArray(JNIEnv* env, jobjectArray array) {
	jclass class = (*env)->FindClass(env, "scala/runtime/BoxedObjectArray");
	jmethodID cons = (*env)->GetMethodID(env, class, "<init>", "([Ljava/lang/Object;)V");
	return (*env)->NewObject(env, class, cons, array);
}

jobject CSBBoxInt(JNIEnv* env, jint p) {
	jclass class = (*env)->FindClass(env, "java/lang/Integer");
	jmethodID cons = (*env)->GetMethodID(env, class, "<init>", "(I)V");
	return (*env)->NewObject(env, class, cons, p);
}

jobject CSBBoxLong(JNIEnv* env, jlong p) {
	jclass class = (*env)->FindClass(env, "java/lang/Long");
	jmethodID cons = (*env)->GetMethodID(env, class, "<init>", "(J)V");
	return (*env)->NewObject(env, class, cons, p);
}

jobject CSBBoxFloat(JNIEnv* env, jfloat p) {
	jclass class = (*env)->FindClass(env, "java/lang/Float");
	jmethodID cons = (*env)->GetMethodID(env, class, "<init>", "(F)V");
	return (*env)->NewObject(env, class, cons, p);
}

jobject CSBBoxDouble(JNIEnv* env, jdouble p) {
	jclass class = (*env)->FindClass(env, "java/lang/Double");
	jmethodID cons = (*env)->GetMethodID(env, class, "<init>", "(D)V");
	return (*env)->NewObject(env, class, cons, p);
}


