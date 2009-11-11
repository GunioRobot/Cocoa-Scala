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

#define CSB_STATIC /*static*/

jobject CSBNewProxy(JNIEnv* env, id self);
void* CSBUnwrapProxy(JNIEnv* env, jobject this);
jobject CSBGetClassProxy(JNIEnv* env, Class class);

SEL CSBJStringToSEL(JNIEnv* env, jstring jstr);
jobject CSBGetOCType(JNIEnv* env, const char* descr);

jobject CSBBoxObjectArray(JNIEnv* env, jobjectArray array);
jobject CSBBoxInt(JNIEnv* env, jint p);
jobject CSBBoxLong(JNIEnv* env, jlong p);
jobject CSBBoxFloat(JNIEnv* env, jfloat p);
jobject CSBBoxDouble(JNIEnv* env, jdouble p);

jint CSBUnboxInt(JNIEnv* env, jobject p);
jlong CSBUnboxLong(JNIEnv* env, jobject p);
jfloat CSBUnboxFloat(JNIEnv* env, jobject p);
jdouble CSBUnboxDouble(JNIEnv* env, jobject p);
