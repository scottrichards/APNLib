//
//  APNLib.h
//  APNLib
//
//  Created by Scott Richards on 5/16/14.
//  Copyright (c) 2014 Scott Richards. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APNLib : NSObject
- (void)initWithParseAppId:(NSString *)appId clientKey:(NSString *)clientKey;
@end
