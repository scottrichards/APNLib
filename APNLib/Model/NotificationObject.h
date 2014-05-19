//
//  NotificationObject.h
//  APNLib
//
//  Created by Scott Richards on 5/18/14.
//  Copyright (c) 2014 Scott Richards. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationObject : NSObject
+ (void)saveNotification:(NSString *)class locale:(NSString *)locale pointer:(NSString *)pointer title:(NSString *)title image:(UIImage *)screenshot;
@end
