//
//  ViewController+Utilities.m
//  APNLib
//
//  Created by Scott Richards on 5/16/14.
//  Copyright (c) 2014 Scott Richards. All rights reserved.
//

#import "ViewController+Utilities.h"
#import <objc/runtime.h>
#import <Parse/Parse.h>
#import "NotificationObject.h"

@implementation UIViewController (ViewController_Utilities)

- (void) viewIsOpening {
    NSLog(@"Opening up: %@",NSStringFromClass([self.view class]));
    NSString *title = @"";
    if (self.navigationItem) {
        title = self.navigationItem.title;
    }
    NSLog(@"Title: %@",title);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(swizzled_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)swizzled_viewWillAppear:(BOOL)animated {
    [self swizzled_viewWillAppear:animated];
    NSLog(@"viewWillAppear: %@", self);
    NSString *messageToPush = [NSString stringWithFormat:@"viewWillAppear: %@", self];
   
    NSString *className = NSStringFromClass([self class]);
    // prevent sending messages for modal dialogs
    if (!([className isEqualToString:@"_UIModalItemAppViewController"] || [className isEqualToString:@"_UIModalItemsPresentingViewController"])) {
        NSString *preferredLang = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        NSString *pointer = [NSString stringWithFormat:@"%p",self]; // format the pointer as a string using %p
        NSString *url = [NSString stringWithFormat:@"p=%@&l=%@&c=%@",pointer,preferredLang,className];
        if (self.navigationItem.title) {
            title = [self.navigationItem.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            url = [url stringByAppendingString:[NSString stringWithFormat:@"&t=%@",title]];
        }

        UIImage *screenShot = [self createCompositeImageFromView];
        [NotificationObject saveNotification:className locale:preferredLang pointer:pointer title:title image:screenShot];
        [self pushNotificationToParse:messageToPush url:url];
    }
}

-(UIImage *)createCompositeImageFromView
{
    CGRect rect = [self.view bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capturedImage;
}

-(void)pushNotificationToParse:(NSString *)message url:(NSString *)url
{
    NSArray *keys = [NSArray arrayWithObjects:@"alert", @"url", nil];
    NSArray *objects = [NSArray arrayWithObjects:message, url, nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                           forKeys:keys];
    NSLog(@"Pushed Dictionary: %@",dictionary);
    PFQuery *globalQuery = [PFInstallation query];
    [globalQuery whereKey:@"channels" equalTo:@"global"];
    [globalQuery whereKey:@"deviceType" equalTo:@"ios"];
    PFPush *notificationToPush = [[PFPush alloc] init];
    [notificationToPush setQuery:globalQuery];
    [notificationToPush setData:dictionary];
    [notificationToPush sendPushInBackground];
}
@end
