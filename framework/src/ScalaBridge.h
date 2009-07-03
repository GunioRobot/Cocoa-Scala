//
//  ScalaBridge.h
//  CocoaScala
//
//  Created by Jeremy Cloud on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <JavaVM/jni.h>
#import <objc/runtime.h>

#ifdef __LP64__
#define NPTR_TO_JLONG(nptr) ((jlong)nptr)
#define JLONG_TO_NPTR(jl) ((void*)jl)
#else
#define NPTR_TO_JLONG(nptr) ((jlong)(jint)nptr)
#define JLONG_TO_NPTR(jl) ((void*)(jint)jl)
#endif

jobject NewProxy(JNIEnv* env, id self, const char* proxyClassName);
void* UnwrapProxy(JNIEnv* env, jobject this);
jobject GetClassProxy(JNIEnv* env, Class class);

jobject NSStringToJString(JNIEnv* env, NSString* nsstr);
NSString* JStringToNSString(JNIEnv* env, jstring jstr);

SEL JStringToSEL(JNIEnv* env, jstring jstr);
jobject GetOCType(JNIEnv* env, const char* descr);

jobject BoxObjectArray(JNIEnv* env, jobjectArray array);
jobject BoxInt(JNIEnv* env, jint p);
jobject BoxLong(JNIEnv* env, jlong p);
jobject BoxFloat(JNIEnv* env, jfloat p);
jobject BoxDouble(JNIEnv* env, jdouble p);
