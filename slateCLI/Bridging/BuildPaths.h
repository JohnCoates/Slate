//
//  BuildPaths.h
//  Slate
//
//  Created by John Coates on 6/9/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuildPaths : NSObject

+ (NSURL *)buildObjectsDirectory;
+ (NSURL *)projectDirectory;

@end

NS_ASSUME_NONNULL_END
