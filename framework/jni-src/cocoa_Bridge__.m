#include "cocoa_Bridge__.h"
#include "ScalaBridge.h"

/*
 * Class:     cocoa_Bridge__
 * Method:    stringToNSString
 * Signature: (Ljava/lang/String;)Lcocoa/NSString;
 */
JNIEXPORT jobject JNICALL Java_cocoa_Bridge_00024_stringToNSString(JNIEnv* env, jobject bridge, jstring string) {
	id nsstring = JNFJavaToNSString(env, string);
	return NewProxy(env, nsstring);
}

/*
 * Class:     cocoa_Bridge__
 * Method:    nsStringToString
 * Signature: (Lcocoa/NSString;)Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_cocoa_Bridge_00024_nsStringToString(JNIEnv* env, jobject bridge, jobject proxy) {
	return JNFNSToJavaString(env, (id)UnwrapProxy(env, proxy));
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

/*
 * Class:     cocoa_Bridge__
 * Method:    cocoa_00024Bridge_00024_00024findClass
 * Signature: (Ljava/lang/String;)Lcocoa/OCClass;
 */
JNIEXPORT jobject JNICALL Java_cocoa_Bridge_00024_cocoa_00024Bridge_00024_00024findClass(JNIEnv* env, jobject bridge, jstring classNameJStr) {
	jclass bridgeClass = (*env)->GetObjectClass(env, bridge);
	jmethodID hasMethod = (*env)->GetMethodID(env, bridgeClass, "hasClass", "(Ljava/lang/String;)Z");
	const char* classNameUTF = (*env)->GetStringUTFChars(env, classNameJStr, JNI_FALSE);
	Class occlass = objc_getClass(classNameUTF);
	jclass resClass = nil;
	
	NSLog(@"findClass %s => %@", classNameUTF, occlass);
	
	(*env)->ReleaseStringUTFChars(env, classNameJStr, classNameUTF);
	
	if (occlass == nil) {
		jclass exClass = (*env)->FindClass(env, "cocoa/OCClassNotFoundException");
		jmethodID constructorID = (*env)->GetMethodID(env, exClass, "<init>", "(Ljava/lang/String;)V");
		jthrowable ex = (*env)->NewObject(env, exClass, constructorID, classNameJStr);
		(*env)->Throw(env, ex);
		return nil;
	}
	
	while (true) {
		jstring classNameJStr = (*env)->NewStringUTF(env, class_getName(occlass));

		if ((*env)->CallBooleanMethod(env, bridge, hasMethod, classNameJStr)) {
			NSLog(@"hasClass %s", classNameUTF);
			jmethodID getterMethod = (*env)->GetMethodID(env, bridgeClass, "getClass", "(Ljava/lang/String;)Lcocoa/OCClass;");
			jobject ancestor = (*env)->CallObjectMethod(env, bridge, getterMethod, classNameJStr);
			resClass = (*env)->GetObjectClass(env, ancestor);
			break;
		}
		
		if (!(occlass = class_getSuperclass(occlass))) {
			// we normally would have found at least NSObject, but if we are looking
			// at a non NSObject subclass, we have to default to using OCClass
			NSLog(@"no more superclasses, using cocoa.OCClass");
			resClass = (*env)->FindClass(env, "cocoa/OCClass");
			break;
		}
	}

	jmethodID cons = (*env)->GetMethodID(env, resClass, "<init>", "(Ljava/lang/String;)V");
	return (*env)->NewObject(env, resClass, cons, classNameJStr);
}

/*
 * Class:     cocoa_Bridge__
 * Method:    cocoa_00024Bridge_00024_00024newSel
 * Signature: (Ljava/lang/String;)Lcocoa/Selector;
 */
JNIEXPORT jobject JNICALL Java_cocoa_Bridge_00024_cocoa_00024Bridge_00024_00024newSel(JNIEnv* env, jobject this, jstring selJStr) {
	SEL sel = JStringToSEL(env, selJStr);
    jclass selClass = (*env)->FindClass(env, "cocoa/Selector");
    jmethodID constructorID = (*env)->GetMethodID(env, selClass, "<init>", "(Ljava/lang/String;J)V");
    return (*env)->NewObject(env, selClass, constructorID, selJStr, ptr_to_jlong(sel));
}

