//
//  NotificationObject.m
//  APNLib
//
//  Created by Scott Richards on 5/18/14.
//  Copyright (c) 2014 Scott Richards. All rights reserved.
//

#import "NotificationObject.h"
#import <Parse/Parse.h>

@implementation NotificationObject

+ (void)saveNotification:(NSString *)class locale:(NSString *)locale pointer:(NSString *)pointer title:(NSString *)title image:(UIImage *)screenshot
{
    PFObject *notification = [PFObject objectWithClassName:@"Notification"];
    notification[@"class"] = class;
    notification[@"locale"] = locale;
    notification[@"id"] = pointer;
    if (title)
        notification[@"title"] = title;
    if (screenshot) {
        NSData *jpegData = UIImageJPEGRepresentation(screenshot,0.9);
        PFFile *imageFile = [PFFile fileWithName:@"image.jpeg" data:jpegData];
        notification[@"screenshot"] = imageFile;
    }
    [notification saveInBackground];
}

@end
