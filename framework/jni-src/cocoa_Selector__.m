#include "cocoa_Selector__.h"
#include "ScalaBridge.h"

JNIEXPORT jobject JNICALL Java_cocoa_Selector_00024_cocoa_00024Selector_00024_00024newSel(JNIEnv* env, jobject this, jstring selJStr) {
	SEL sel = JStringToSEL(env, selJStr);
    jclass selClass = (*env)->FindClass(env, "cocoa/Selector");
    jmethodID constructorID = (*env)->GetMethodID(env, selClass, "<init>", "(Ljava/lang/String;J)V");
    return (*env)->NewObject(env, selClass, constructorID, selJStr, NPTR_TO_JLONG(sel));
}
