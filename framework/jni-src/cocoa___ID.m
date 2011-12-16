#include "cocoa___ID.h"
#include "ScalaBridge.h"
#include <ffi/ffi.h>
#import <JavaNativeFoundation/JavaNativeFoundation.h>

/*
 * Class:     cocoa___ID
 * Method:    finalize
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_cocoa__00024ID_finalize(JNIEnv* env, jobject this) {
	JNF_COCOA_ENTER(env);
	id self = (id)CSBUnwrapProxy(env, this);
	CFRelease(self);
	JNF_COCOA_EXIT(env);
}
