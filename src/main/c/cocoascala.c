#import "cocoa_ObjcBridge__.h"
#import <Cocoa/Cocoa.h>

/************************ utility methods *******************************/

jobject NewObjcRef(JNIEnv* env, void* nptr) {
    jclass objcRefClass = (*env)->FindClass(env, "cocoa/ObjcRef");
    jmethodID constructorID = (*env)->GetMethodID(env, objcRefClass, "<init>", "(J)V");
    return (*env)->NewObject(env, objcRefClass, constructorID, (jlong) nptr);
}

jobject NewObjcClass(JNIEnv* env, void* nptr, jstring className) {
    jclass objcRefClass = (*env)->FindClass(env, "cocoa/ObjcClass");
    jmethodID constructorID = (*env)->GetMethodID(env, objcRefClass, "<init>", "(JLjava/lang/String;)V");
    return (*env)->NewObject(env, objcRefClass, constructorID, (jlong) nptr, className);
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

/*************************** cocoa.ObjcBridge ********************************/


/*
 * Class:     cocoa_ObjcBridge__
 * Method:    findClass
 * Signature: (Ljava/lang/String;)Lcocoa/ObjcClass;
 */
JNIEXPORT jobject JNICALL Java_cocoa_ObjcBridge_00024_findClass(JNIEnv* env, jobject this, jstring jclassName) {
    const char* objcClassName  = (*env)->GetStringUTFChars(env, jclassName, JNI_FALSE);
    id objcClass = objc_getClass(objcClassName);
    jobject objcRef = NewObjcClass(env, objcClass, jclassName);
    (*env)->ReleaseStringUTFChars(env, jclassName, objcClassName);
    return objcRef;
}


/*************************** cocoa.ObjcRef ********************************/

/*
 * Class:     cocoa_ObjcRef
 * Method:    finalize
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_cocoa_ObjcRef_finalize(JNIEnv* env, jobject this) {
    jclass objcRefClass = (*env)->FindClass(env, "cocoa/ObjcRef");
    jfieldID nptrID = (*env)->GetFieldID(env, objcRefClass, "nptr", "J");
    id objcObj = (id) (*env)->GetLongField(env, this, nptrID);
    CFRelease(objcObj);
}

/*
 * Class:     cocoa_ObjcRef
 * Method:    description
 * Signature: ()Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_cocoa_ObjcRef_description(JNIEnv* env, jobject this) {
    jclass objcRefClass = (*env)->FindClass(env, "cocoa/ObjcRef");
    jfieldID nptrID = (*env)->GetFieldID(env, objcRefClass, "nptr", "J");
    id objcObj = (id) (*env)->GetLongField(env, this, nptrID);
    NSString* description = [objcObj description];
    return NSStringToJString(env, description);
}

/*
 * Class:     cocoa_ObjcRef
 * Method:    objcClass
 * Signature: ()Lcocoa/ObjcClass;
 */
JNIEXPORT jobject JNICALL Java_cocoa_ObjcRef_objcClass(JNIEnv* env, jobject this) {
    return NULL;
}

