//
//  ScalaBridge.h
//  CocoaScala
//
//  Created by Jeremy Cloud on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <JavaVM/jni.h>
#import <JavaNativeFoundation/JNFJNI.h>
#import <JavaNativeFoundation/JNFString.h>
#import <objc/runtime.h>

jobject NewProxy(JNIEnv* env, id self);
void* UnwrapProxy(JNIEnv* env, jobject this);
jobject GetClassProxy(JNIEnv* env, Class class);

SEL JStringToSEL(JNIEnv* env, jstring jstr);
jobject GetOCType(JNIEnv* env, const char* descr);

jobject BoxObjectArray(JNIEnv* env, jobjectArray array);
jobject BoxInt(JNIEnv* env, jint p);
jobject BoxLong(JNIEnv* env, jlong p);
jobject BoxFloat(JNIEnv* env, jfloat p);
jobject BoxDouble(JNIEnv* env, jdouble p);
