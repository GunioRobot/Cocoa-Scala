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
	SEL sel = (SEL)UnwrapProxy(env, selJObj);
	int argCount = (*env)->GetArrayLength(env, argsJArr);
	IMP imp = (IMP) JLONG_TO_NPTR(fnPtr);
	
	if (argCount == 0) {
		switch (returnType) {
			case 'v': 
				(*imp)(recv, sel);
				return nil;
				
			case 'i':
				return BoxInt(env, (*(int32_t(*)(id,SEL))imp)(recv, sel));
				
			case 'I':
				return BoxLong(env, (*(uint32_t(*)(id,SEL))imp)(recv, sel));
				
			case 'q': case 'Q': 
				return BoxLong(env, (*(uint64_t(*)(id,SEL))imp)(recv, sel));
				
			case 'f': 
				return BoxFloat(env, (*(float(*)(id,SEL))imp)(recv, sel));
				
			case 'd': 
				return BoxDouble(env, (*(double(*)(id,SEL))imp)(recv, sel));
		}
	}
	
	return nil;
}

