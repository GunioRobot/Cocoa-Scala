//
//  CSBRuntime.m
//  CocoaScalaFramework
//
//  Created by Jeremy Cloud on 6/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CSBRuntime.h"

int CSBApplicationMain(const char* mainClass, int argc, const char* argv[]) {
	NSString* mainClassName = [NSString stringWithUTF8String:mainClass];
	NSMutableArray* args = [NSMutableArray arrayWithCapacity:argc - 1];
	for (int i = 1; i < argc; i++) {
		[args addObject:[NSString stringWithUTF8String:argv[i]]];
	}
	[[CSBRuntime sharedRuntime] invokeMainClass:mainClassName withArgs:args];
	// not sure if I should be calling NSApplicationMain or doing something else
	return NSApplicationMain(argc, argv);
}

@interface CSBRuntime (Private)
+(void)collectJarPathsForBundle:(NSBundle*)bundle into:(NSMutableArray*)classPathArray;
+(void)collectLibraryPathsForBundle:(NSBundle*)bundle into:(NSMutableArray*)libraryPathArray;
+(NSArray*)embeddedFrameworksIn:(NSBundle*)bundle;
+(NSString*)defaultClassPath;
+(NSString*)defaultLibraryPath;
@end

@implementation CSBRuntime

static CSBRuntime* theRuntime = nil;

+(CSBRuntime*)sharedRuntime {
	@synchronized (self) {
		if (theRuntime == nil) {
			[[CSBRuntime alloc] init];
		}
	}

	return theRuntime;
}

+allocWithZone:(NSZone*)zone {
    @synchronized (self) {
        if (theRuntime == nil) {
            theRuntime = [super allocWithZone:zone];
            return theRuntime;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

-copyWithZone:(NSZone*)zone {
    return self;
}

-(void)destroyJavaVM {
	if (jvm) {
		(*jvm)->DestroyJavaVM(jvm);
		jvm = NULL;
	}
}

-(void)invokeMainClass:(NSString*)mainClassName withArgs:(NSArray*)args {
	// [NSException raise:@"Invalid foo value" format:@"foo of %d is invalid", foo];
	NSString* classNameInternal = [mainClassName stringByReplacingOccurrencesOfString:@"." withString:@"/"];
	const char* classNameUTF = [classNameInternal UTF8String];
	JNIEnv* env = nil;
	(*jvm)->AttachCurrentThread(jvm, (void**)&env, nil);
    jclass mainClass = (*env)->FindClass(env, classNameUTF);
	if (mainClass == NULL) {
		(*env)->ExceptionDescribe(env);
		(*env)->ExceptionClear(env);
		(*jvm)->DetachCurrentThread(jvm);
		// TODO should capture more exception information
		[NSException raise:@"ClassNotFound" format:@"%@", mainClassName];
	}
	else {
		jclass stringClass = (*env)->FindClass(env, "java/lang/String");
		jint argCount = [args count];
		jobjectArray argsJArray = (*env)->NewObjectArray(env, argCount, stringClass, NULL);
		for (int i = 0; i < argCount; i++) {
			const char* argUTF = [[args objectAtIndex:i] UTF8String];
			jstring argJStr = (*env)->NewStringUTF(env, argUTF);
			(*env)->SetObjectArrayElement(env, argsJArray, i, argJStr);
		}
		jmethodID mid = (*env)->GetStaticMethodID(env, mainClass, "main", "([Ljava/lang/String;)V");
		(*env)->CallStaticVoidMethod(env, mainClass, mid, argsJArray);
		// cleanup
		(*jvm)->DetachCurrentThread(jvm);
	}
}

#pragma mark Private

/* Collects the full path of all jar files found under <bundle>/Resources/Java,
 * and recursively for any embedded frameworks.
 */
+(void)collectJarPathsForBundle:(NSBundle*)bundle into:(NSMutableArray*)classPathArray {
	NSArray* jarPaths = [bundle pathsForResourcesOfType:@"jar" inDirectory:@"Java"];
	[classPathArray addObjectsFromArray:jarPaths];

	for (NSBundle* framework in [self embeddedFrameworksIn:bundle]) {
		[self collectJarPathsForBundle:framework into:classPathArray];
	}
}

/* Collects the full path to <bundle>/Resources/Java, and recursively for any embedded frameworks.
 */
+(void)collectLibraryPathsForBundle:(NSBundle*)bundle into:(NSMutableArray*)libraryPathArray {
	NSString* resourcePath = [bundle resourcePath];
	NSString* javaResourcePath = [resourcePath stringByAppendingString:@"/Java"];
	[libraryPathArray addObject:javaResourcePath];

	for (NSBundle* framework in [self embeddedFrameworksIn:bundle]) {
		[self collectLibraryPathsForBundle:framework into:libraryPathArray];
	}
}

/* Returns an NSArray object containing NSBundle objects for all embedded
 * frameworks in the given bundle.
 */
+(NSArray*)embeddedFrameworksIn:(NSBundle*)bundle {
	NSMutableArray* embeddedFrameworks = [NSMutableArray arrayWithCapacity:8];
	NSString* frameworksPath = [bundle privateFrameworksPath];
	NSFileWrapper* frameworksDir = [[NSFileWrapper alloc] initWithPath:frameworksPath];
	NSDictionary* fileWrappers = [frameworksDir fileWrappers];

	for (id key in fileWrappers) {
		NSFileWrapper* itemWrapper = [fileWrappers objectForKey:key];
		NSString* filename = [itemWrapper filename];
		if ([itemWrapper isDirectory] && [filename hasSuffix:@".framework"]) {
			NSString* path = [NSString stringWithFormat:@"%@/%@", frameworksPath, filename];
			NSBundle* framework = [NSBundle bundleWithPath:path];
			[embeddedFrameworks addObject:framework];
		}
	}

	return embeddedFrameworks;
}

/* Constructs a classpath by finding all jar files in the main bundle and
 * all embedded frameworks.
 */
+(NSString*)defaultClassPath {
	NSMutableArray* classPathArray = [NSMutableArray arrayWithCapacity:32];
	[self collectJarPathsForBundle:[NSBundle mainBundle] into:classPathArray];
	NSString* classPath = [classPathArray componentsJoinedByString:@":"];
	NSLog(@"defaultClassPath=%@", classPath);
	return classPath;
}

/* Constructs a library path by finding all <bundle>/Resource/Java paths in
 * the main bundle and all embedded frameworks
 */
+(NSString*)defaultLibraryPath {
	NSMutableArray* libraryPathArray = [NSMutableArray arrayWithCapacity:32];
	[self collectLibraryPathsForBundle:[NSBundle mainBundle] into:libraryPathArray];
	NSString* libraryPath = [libraryPathArray componentsJoinedByString:@":"];
	NSLog(@"defaultLibraryPath=%@", libraryPath);
	return libraryPath;
}

-init {
	[super init];
	NSString* classPath = [CSBRuntime defaultClassPath];
	NSString* libraryPath = [CSBRuntime defaultLibraryPath];

    JNIEnv *env;       /* pointer to native method interface */
    JavaVMInitArgs vm_args; /* JDK/JRE 6 VM initialization arguments */
    JavaVMOption options[2];
    options[0].optionString = (char*)[[@"-Djava.class.path=" stringByAppendingString:classPath] UTF8String];
    options[1].optionString = (char*)[[@"-Djava.library.path=" stringByAppendingString:libraryPath] UTF8String];
    vm_args.version = JNI_VERSION_1_4;
    vm_args.nOptions = 2;
    vm_args.options = options;
    vm_args.ignoreUnrecognized = false;
    /* load and initialize a Java VM, return a JNI interface
     * pointer in env */
    jint err = JNI_CreateJavaVM(&jvm, (void**)&env, &vm_args);
	if (jvm == nil) {
		NSLog(@"failed to create JavaVM, err=%d", err);
	}
	else {
		NSLog(@"created JavaVM");
	}
	return self;
}

@end
