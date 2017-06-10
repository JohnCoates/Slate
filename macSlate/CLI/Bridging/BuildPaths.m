//
//  BuildPaths.m
//  Slate
//
//  Created by John Coates on 6/9/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

#import "BuildPaths.h"

@implementation BuildPaths

+ (NSURL *)buildObjectsDirectory {
    NSString *directory = @(OBJECTS_DIRECTORY);
    return [NSURL fileURLWithPath:directory];
}

+ (NSURL *)projectDirectory {
    NSString *directory = @(PROJECT_DIRECTORY);
    return [NSURL fileURLWithPath:directory];
}

@end
