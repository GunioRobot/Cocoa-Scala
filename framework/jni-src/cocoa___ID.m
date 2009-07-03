#include "cocoa___ID.h"
#include "ScalaBridge.h"
#include <ffi/ffi.h>

/*
 * Class:     cocoa___ID
 * Method:    finalize
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_cocoa__00024ID_finalize(JNIEnv* env, jobject this) {
	id self = (id)UnwrapProxy(env, this);
	CFRelease(self);	
}

/*
 * Class:     cocoa___ID
 * Method:    msgSend
 * Signature: (Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;
 */
JNIEXPORT jobject JNICALL Java_cocoa__00024ID_msgSend(JNIEnv* env, jobject this, jstring selJStr, jobjectArray argsJArr) {
	/*
	id self = (id)UnwrapProxy(env, this);
	if (self == nil) return nil;
	const char* selUTF = (*env)->GetStringUTFChars(env, selJStr, JNI_FALSE);
	SEL sel = sel_getUid(selUTF);
	IMP imp = 
	NSMethodSignature* sig = [self methodSignatureForSelector: sel];
	(*env)->ReleaseStringUTFChars(env, selJStr, selUTF);
	if (sig != nil) {
		NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig];
		[inv setSelector: sel];
		[inv setTarget: self];
		int argCount = (*env)->GetArrayLength(env, argsJArr);
		const char* returnType = [sig methodReturnType];
		
		for (int i = 0; i < argCount; i++) {
			jobject argJObj = (*env)->GetObjectArrayElement(env, argsJArr, i);
			const char* paramType = [sig getArgumentTypeAtIndex: i + 2];
		}
		
		[inv invoke];
		
		/*
		switch (returnType[0]) {
			case 'v': return nil;
			case '@': {
				id retObj;
				[inv getReturnValue:&id];
				if (retObj == nil) {
					return nil;
				}
				else {
					
				}
			}
		}
		 *
		
		return nil;
	}
	else {
		jclass exClass = (*env)->FindClass(env, "cocoa/SelectorNotRecognizedException");
		jmethodID constructorID = (*env)->GetMethodID(env, exClass, "<init>", "(Ljava/lang/String;)V");
		jthrowable ex = (*env)->NewObject(env, exClass, constructorID, selUTF);
		(*env)->Throw(env, ex);
		return nil;
	}
	 */
	return nil;
}

