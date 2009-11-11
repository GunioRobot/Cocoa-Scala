#include "cocoa_Bridge__.h"
#include "ScalaBridge.h"
#import <JavaNativeFoundation/JavaNativeFoundation.h> 

/*
 * Class:     cocoa_Bridge__
 * Method:    stringToNSString
 * Signature: (Ljava/lang/String;)Lcocoa/NSString;
 */
JNIEXPORT jobject JNICALL Java_cocoa_Bridge_00024_stringToNSString(JNIEnv* env, jobject bridge, jstring jString) {
	jobject res = nil;
	JNF_COCOA_ENTER(env);
	id nsString = JNFJavaToNSString(env, jString);
	res = CSBNewProxy(env, nsString);
	JNF_COCOA_EXIT(env);
	return res;
}

/*
 * Class:     cocoa_Bridge__
 * Method:    nsStringToString
 * Signature: (Lcocoa/NSString;)Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_cocoa_Bridge_00024_nsStringToString(JNIEnv* env, jobject bridge, jobject proxy) {
	jstring res = nil;
	JNF_COCOA_ENTER(env);
	id nsstring = CSBUnwrapProxy(env, proxy);
	res = JNFNSToJavaString(env, nsstring);
	JNF_COCOA_EXIT(env);
	return res;
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
		jobject res = nil;
		JNF_COCOA_ENTER(env);
		res = CSBGetClassProxy(env, ((id)CSBUnwrapProxy(env, proxy))->isa);
		JNF_COCOA_EXIT(env);
		return res;
	}
}

/*
 * Class:     cocoa_Bridge__
 * Method:    cocoa_00024Bridge_00024_00024findClass
 * Signature: (Ljava/lang/String;)Lcocoa/OCClass;
 */
JNIEXPORT jobject JNICALL Java_cocoa_Bridge_00024_cocoa_00024Bridge_00024_00024findClass(JNIEnv* env, jobject bridge, jstring jClassName) {
	jobject res = nil;
	JNF_COCOA_ENTER(env);
	CSB_STATIC JNF_CLASS_CACHE(jBridgeClass, "cocoa/Bridge$");
	CSB_STATIC JNF_MEMBER_CACHE(hasClassMtd, jBridgeClass, "hasClass", "(Ljava/lang/String;)Z");
	CSB_STATIC JNF_MEMBER_CACHE(getClassMtd, jBridgeClass, "getClass", "(Ljava/lang/String;)Lcocoa/OCClass;");
	const char* uClassName = JNFGetStringUTF8Chars(env, jClassName);
	Class oClass = objc_getClass(uClassName);
	jclass resClass = nil;
	
	JNFReleaseStringUTF8Chars(env, jClassName, uClassName);
	
	if (oClass == nil) {
		CSB_STATIC JNF_CLASS_CACHE(exClass, "cocoa/OCClassNotFoundException");
		CSB_STATIC JNF_CTOR_CACHE(exCtor, exClass, "(Ljava/lang/String;)V");
		jthrowable ex = JNFNewObject(env, exCtor, jClassName);
		(*env)->Throw(env, ex);
		return nil;
	}
	
	while (true) {
		jstring jClassName = (*env)->NewStringUTF(env, class_getName(oClass));

		if (JNFCallBooleanMethod(env, bridge, hasClassMtd, jClassName)) {
			NSLog(@"hasClass %s", uClassName);
			jobject ancestor = JNFCallObjectMethod(env, bridge, getClassMtd, jClassName);
			resClass = (*env)->GetObjectClass(env, ancestor);
			break;
		}
		
		if (!(oClass = class_getSuperclass(oClass))) {
			// we normally would have found at least NSObject, but if we are looking
			// at a non NSObject subclass, we have to default to using oClass
			NSLog(@"no more superclasses, using cocoa.OCClass");
			resClass = (*env)->FindClass(env, "cocoa/OCClass");
			break;
		}
	}

	jmethodID cons = (*env)->GetMethodID(env, resClass, "<init>", "(Ljava/lang/String;)V");
	res = (*env)->NewObject(env, resClass, cons, jClassName);
	JNF_COCOA_EXIT(env);
	return res;
}

/*
 * Class:     cocoa_Bridge__
 * Method:    cocoa_00024Bridge_00024_00024newSel
 * Signature: (Ljava/lang/String;)Lcocoa/Selector;
 */
JNIEXPORT jobject JNICALL Java_cocoa_Bridge_00024_cocoa_00024Bridge_00024_00024newSel(JNIEnv* env, jobject this, jstring jSelName) {
	jobject res = nil;
	JNF_COCOA_ENTER(env);
	CSB_STATIC JNF_CLASS_CACHE(jSelectorClass, "cocoa/Selector");
	CSB_STATIC JNF_CTOR_CACHE(jSelectorCtor, jSelectorClass, "(Ljava/lang/String;J)V");
	SEL sel = CSBJStringToSEL(env, jSelName);
    res = JNFNewObject(env, jSelectorCtor, jSelName, ptr_to_jlong(sel));
	JNF_COCOA_EXIT(env);
	return res;
}

