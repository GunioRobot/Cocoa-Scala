//
//  CSRuntime.h
//  CocoaScalaFramework
//
//  Created by Jeremy Cloud on 6/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <JavaVM/jni.h>

int CSApplicationMain(const char* mainClass, int argc, const char* argv[]);

@interface CSRuntime : NSObject {
	@private 
	JavaVM *jvm;       /* denotes a Java VM */ 
}

+(CSRuntime*)sharedRuntime;

/* should be called before quiting the application in order to
 * allow the JavaVM to cleanly shutdown */
-(void)destroyJavaVM;

/* Invokes the main method on the specified class */
-(void)invokeMainClass:(NSString*)mainClassName withArgs:(NSArray*)args;

@end
