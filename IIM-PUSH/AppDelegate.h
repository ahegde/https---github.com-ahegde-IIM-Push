//
//  AppDelegate.h
//  IIM-PUSH
//
//  Created by Ajay Hegde on 12/24/12.
//  Copyright (c) 2012 Ajay Hegde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_Base.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) AppDelegate *g_appDelegate;

@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, retain) NSDictionary *notificationData;

SINGLETON_INTERFACE_FOR_CLASS_AND_METHOD(AppDelegate, sharedInstance);
+ (void)errorWithError:(NSError*)error;
+ (void)errorWithMessage:(NSString*)message;
@end
