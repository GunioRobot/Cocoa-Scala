#include "cocoa___ID.h"
#include "ScalaBridge.h"

JNIEXPORT void JNICALL Java_cocoa__00024ID_finalize(JNIEnv* env, jobject this) {
	id self = JObjectToID(env, this);
    CFRelease(self);	
}
