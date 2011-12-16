//
//  CSTest.m
//  CocoaScala
//
//  Created by Jeremy Cloud on 6/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CSTest.h"

int CSTestMain(const char* mainClass) {
	NSString* mainClassName = [NSString stringWithUTF8String:mainClass];
	[[CSBRuntime sharedRuntime] invokeMainClass:mainClassName withArgs:[NSArray array]];
	return 0;
}


@implementation CSTest

+(NSObject*)meta {
	NSLog(@"self=%@", self);
	return self;
}
-(void)executeSuite:(NSString*)suiteName {

}

@end
