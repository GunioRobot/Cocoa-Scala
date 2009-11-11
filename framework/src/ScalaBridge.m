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
	CSB_STATIC JNF_CLASS_CACHE(jClass, "scala/runtime/BoxedObjectArray");
	CSB_STATIC JNF_CTOR_CACHE(jCons, jClass, "([Ljava/lang/Object;)V");
	return JNFNewObject(env, jCons, array);
}

jobject CSBBoxInt(JNIEnv* env, jint p) {
	CSB_STATIC JNF_CLASS_CACHE(jClass, "java/lang/Integer");
	CSB_STATIC JNF_CTOR_CACHE(jCons, jClass, "(I)V");
	return JNFNewObject(env, jCons, p);
}

jobject CSBBoxLong(JNIEnv* env, jlong p) {
	CSB_STATIC JNF_CLASS_CACHE(jClass, "java/lang/Long");
	CSB_STATIC JNF_CTOR_CACHE(jCons, jClass, "(J)V");
	return JNFNewObject(env, jCons, p);
}

jobject CSBBoxFloat(JNIEnv* env, jfloat p) {
	CSB_STATIC JNF_CLASS_CACHE(jClass, "java/lang/Float");
	CSB_STATIC JNF_CTOR_CACHE(jCons, jClass, "(F)V");
	return JNFNewObject(env, jCons, p);
}

jobject CSBBoxDouble(JNIEnv* env, jdouble p) {
	CSB_STATIC JNF_CLASS_CACHE(jClass, "java/lang/Double");
	CSB_STATIC JNF_CTOR_CACHE(jCons, jClass, "(D)V");
	return JNFNewObject(env, jCons, p);
}

jint CSBUnboxInt(JNIEnv* env, jobject p) {
	CSB_STATIC JNF_CLASS_CACHE(jClass, "java/lang/Integer");
	CSB_STATIC JNF_MEMBER_CACHE(jMethod, jClass, "intValue", "()I");
	return JNFCallIntMethod(env, p, jMethod);
}

jlong CSBUnboxLong(JNIEnv* env, jobject p) {
	CSB_STATIC JNF_CLASS_CACHE(jClass, "java/lang/Long");
	CSB_STATIC JNF_MEMBER_CACHE(jMethod, jClass, "longValue", "()I");
	return JNFCallIntMethod(env, p, jMethod);
}

jfloat CSBUnboxFloat(JNIEnv* env, jobject p) {
	CSB_STATIC JNF_CLASS_CACHE(jClass, "java/lang/Float");
	CSB_STATIC JNF_MEMBER_CACHE(jMethod, jClass, "floatValue", "()I");
	return JNFCallIntMethod(env, p, jMethod);
}

jdouble CSBUnboxDouble(JNIEnv* env, jobject p) {
	CSB_STATIC JNF_CLASS_CACHE(jClass, "java/lang/Double");
	CSB_STATIC JNF_MEMBER_CACHE(jMethod, jClass, "doubleValue", "()I");
	return JNFCallIntMethod(env, p, jMethod);
}



