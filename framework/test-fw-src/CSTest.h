//
//  CSTest.h
//  CocoaScala
//
//  Created by Jeremy Cloud on 6/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CocoaScala/CSRuntime.h>

int CSTestMain(const char* mainClassName);

@interface CSTest : NSObject {
}

+(NSObject*)meta;
-(void)executeSuite:(NSString*)suiteName;

@end
