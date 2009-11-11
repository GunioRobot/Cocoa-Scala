#include "cocoa_Method.h"
#include "ScalaBridge.h"
#import <JavaNativeFoundation/JavaNativeFoundation.h>

/*
 * Class:     cocoa_Method
 * Method:    sendMsg
 * Signature: (Lcocoa/Selector;Lcocoa/OCType;Lscala/Seq;JJLcocoa/$ID;[Ljava/lang/Object;)Ljava/lang/Object;
 */
JNIEXPORT jobject JNICALL Java_cocoa_Method_sendMsg(
	JNIEnv* env, jobject methodJObj, jobject selJObj, 
	jchar returnType, jcharArray paramTypes, 
	jlong fficifPtr, jlong fnPtr, 
	jobject recvProxy, jobjectArray argsJArr)
{
	JNF_COCOA_ENTER(env);
	id recv = (id)CSBUnwrapProxy(env, recvProxy);
	NSLog(@"recv=%@", recv);
	SEL sel = (SEL)CSBUnwrapProxy(env, selJObj);
	NSLog(@"sel=%s", sel);
	int argCount = argsJArr ? (*env)->GetArrayLength(env, argsJArr) : 0;
	NSLog(@"argCount=%d", argCount);
	IMP imp = (IMP) jlong_to_ptr(fnPtr);
	NSLog(@"imp=%p", imp);
	
	if (argCount == 0) {
		switch (returnType) {
			case 'v': 
				(*imp)(recv, sel);
				return nil;
				
			case 'i': case 'l':
				return CSBBoxInt(env, (*(int32_t(*)(id,SEL))imp)(recv, sel));
				
			case 'I': case 'L':
				return CSBBoxLong(env, (*(uint32_t(*)(id,SEL))imp)(recv, sel));
				
			case 'q': case 'Q': 
				return CSBBoxLong(env, (*(uint64_t(*)(id,SEL))imp)(recv, sel));
				
			case 'f': 
				return CSBBoxFloat(env, (*(float(*)(id,SEL))imp)(recv, sel));
				
			case 'd': 
				return CSBBoxDouble(env, (*(double(*)(id,SEL))imp)(recv, sel));
				
			case '@':
				return CSBNewProxy(env, (*imp)(recv, sel));
				
			case '#':
				return CSBGetClassProxy(env, (Class)(*imp)(recv, sel));
		}
	}
	
	/*
	ffi_cif* cif = (ffi_cif*) jlong_to_ptr(fficifPtr);
	void* argPtrs[argCount + 2];
	argPtrs[0] = &recv;
	argPtrs[1] = &sel;
	
	for (int i = 0; i < argCount; i++) {
	}
	
	ffi_call(cif, imp, void *RVALUE, argPtrs);
	*/
	JNF_COCOA_EXIT(env);
	return nil;
}

