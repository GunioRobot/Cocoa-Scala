#include "cocoa_Method.h"
#include "ScalaBridge.h"

/*
 * Class:     cocoa_Method
 * Method:    sendMsg
 * Signature: (Lcocoa/Selector;Lcocoa/OCType;Lscala/Seq;JJLcocoa/$ID;[Ljava/lang/Object;)Ljava/lang/Object;
 */
JNIEXPORT jobject JNICALL Java_cocoa_Method_sendMsg(JNIEnv* env, jobject methodJObj, jobject selJObj, 
													jchar returnType, jcharArray paramTypes, 
													jlong fficifPtr, jlong fnPtr, 
													jobject recvProxy, jobjectArray argsJArr)
{
	id recv = (id)UnwrapProxy(env, recvProxy);
	NSLog(@"recv=%@", recv);
	SEL sel = (SEL)UnwrapProxy(env, selJObj);
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
				return BoxInt(env, (*(int32_t(*)(id,SEL))imp)(recv, sel));
				
			case 'I': case 'L':
				return BoxLong(env, (*(uint32_t(*)(id,SEL))imp)(recv, sel));
				
			case 'q': case 'Q': 
				return BoxLong(env, (*(uint64_t(*)(id,SEL))imp)(recv, sel));
				
			case 'f': 
				return BoxFloat(env, (*(float(*)(id,SEL))imp)(recv, sel));
				
			case 'd': 
				return BoxDouble(env, (*(double(*)(id,SEL))imp)(recv, sel));
				
			case '@':
				return NewProxy(env, (*imp)(recv, sel));
				
			case '#':
				return GetClassProxy(env, (Class)(*imp)(recv, sel));
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
	return nil;
}

