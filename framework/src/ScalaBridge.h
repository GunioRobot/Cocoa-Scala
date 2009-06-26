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

id JObjectToID(JNIEnv* env, jobject this);

jobject NewProxy(JNIEnv* env, id self, const char* proxyClassName);
jobject GetClassProxy(JNIEnv* env, const char* nsClassName);

jobject NSStringToJString(JNIEnv* env, NSString* nsstr);
NSString* JStringToNSString(JNIEnv* env, jstring jstr);
