//
//  APNLib.m
//  APNLib
//
//  Created by Scott Richards on 5/16/14.
//  Copyright (c) 2014 Scott Richards. All rights reserved.
//

#import "APNLib.h"
#import <Parse/Parse.h>

@implementation APNLib
- (void)initWithParseAppId:(NSString *)appId clientKey:(NSString *)clientKey
{
    [Parse setApplicationId:appId clientKey:clientKey];
    NSLog(@"init Parse with AppId: %@, clientKey: %@",appId,clientKey);
}
@end
