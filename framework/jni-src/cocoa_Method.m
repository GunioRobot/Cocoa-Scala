#include "cocoa_Method.h"
#include "ScalaBridge.h"
#import <ffi/ffi.h>
#import <JavaNativeFoundation/JavaNativeFoundation.h>

/*
 * Class:     cocoa_Method
 * Method:    sendMsg
 * Signature: (Lcocoa/Selector;Lcocoa/OCType;Lscala/Seq;JJLcocoa/$ID;[Ljava/lang/Object;)Ljava/lang/Object;
 */
JNIEXPORT jobject JNICALL Java_cocoa_Method_sendMsg(
	JNIEnv* env, jobject jMethod, jobject jSel, 
	jchar returnType, jcharArray jParamTypesArray, 
	jlong fficifPtr, jlong fnPtr, 
	jobject recvProxy, jobjectArray jArgArray)
{
	jobject res = nil;
	JNF_COCOA_ENTER(env);
	id recv = (id)CSBUnwrapProxy(env, recvProxy);
	SEL sel = (SEL)CSBUnwrapProxy(env, jSel);
	int argCount = jArgArray ? (*env)->GetArrayLength(env, jArgArray) : 0;
	IMP imp = (IMP) jlong_to_ptr(fnPtr);
	ffi_arg rvalue = 0;
	
	if (argCount == 0) {
		// with no arguments, just call method impl directly, bypassing ffi
		rvalue = (*(ffi_arg(*)(id,SEL))imp)(recv, sel);
	}
	else {
		// this currently assumes no arguments are larger than 8 bytes,
		// which won't be true when handling pass-by-value structs
		ffi_cif* cif = (ffi_cif*) jlong_to_ptr(fficifPtr);
		ffi_arg args[argCount];
		void* argPtrs[argCount + 2];
		jchar* paramTypes = (*env)->GetCharArrayElements(env, jParamTypesArray, NULL);

		argPtrs[0] = &recv;
		argPtrs[1] = &sel;
		
		for (int i = 0; i < argCount; i++) {
			jobject jArg = (*env)->GetObjectArrayElement(env, jArgArray, i);
			
			switch (paramTypes[i]) {
				case 'i': case 'l':
					args[i] = CSBUnboxInt(env, jArg);
					break;
					
				case 'I': case 'L':
					args[i] = CSBUnboxLong(env, jArg);
					break;
					
				case 'q': case 'Q': 
					args[i] = (uint64_t) CSBUnboxLong(env, jArg);
					break;
					
				case 'f': {
					jfloat floatVal = CSBUnboxFloat(env, jArg);
					args[i] = *(int*)&floatVal;
					break;
				}
					
				case 'd': {
					jdouble doubleVal = CSBUnboxDouble(env, jArg);
					args[i] = *(long*)&doubleVal;
					break;
				}
					
				case '@': case '#':
					args[i] = ptr_to_jlong(CSBUnwrapProxy(env, jArg));
					break;
					
				default:
					NSLog(@"did not encode arg %d of type %c in call to %s", i, paramTypes[i], sel);
					args[i] = 0;
			}
			argPtrs[i + 2] = &args[i];
		}
		
		(*env)->ReleaseCharArrayElements(env, jParamTypesArray, paramTypes, 0);
		ffi_call(cif, FFI_FN(imp), &rvalue, argPtrs);
	}
	
	switch (returnType) {
		case 'v': 
			break;
			
		case 'c': case 'C': case 'i': case 'l':
			NSLog(@"rvalue=%ld, as int32_t=%d", rvalue, (int32_t)rvalue);
			res = CSBBoxInt(env, (int32_t)rvalue);
			break;
			
		case 'I': case 'L':
			res = CSBBoxLong(env, (uint32_t)rvalue);
			break;
			
		case 'q': case 'Q': 
			res = CSBBoxLong(env, (uint64_t)rvalue);
			break;
			
		case 'f': 
			res = CSBBoxFloat(env, *(float*)&rvalue);
			break;
			
		case 'd': 
			res = CSBBoxDouble(env, *(double*)&rvalue);
			break;
			
		case '@':
			res = CSBNewProxy(env, jlong_to_ptr(rvalue));
			break;
			
		case '#':
			res = CSBGetClassProxy(env, jlong_to_ptr(rvalue));
			break;
			
		default:
			NSLog(@"unconverted return type: %c", returnType);
	}

	JNF_COCOA_EXIT(env);
	return res;
}

