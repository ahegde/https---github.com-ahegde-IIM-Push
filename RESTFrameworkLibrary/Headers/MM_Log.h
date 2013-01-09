//
//  MM_Log.h
//
//  Created by Ben Gottlieb on 11/25/11.
//  Copyright (c) 2011 Model Metrics, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@class MM_SFChange, MMSF_Object;

@interface MM_Log : NSObject <MFMailComposeViewControllerDelegate>

SINGLETON_INTERFACE_FOR_CLASS_AND_METHOD(MM_Log, sharedLog);

@property (nonatomic, readwrite, strong) NSString *logFilePath;
@property (nonatomic, readonly) NSArray *recentErrors;
@property (nonatomic, assign) BOOL enabled;

- (void) clearRecentErrors;

- (void) logMetadataError: (NSError *) error forObjectNamed: (NSString *) name;
- (void) logSyncError: (NSError *) error forObjectNamed: (NSString *) name;
- (void) logUploadError: (NSError *) error forChange: (MM_SFChange *) change;
- (void) logBlobDownloadError: (NSError *) error forField: (NSString *) field onObject: (MMSF_Object *) object;

- (void) logString: (NSString *) message;

- (void) clearLog;
- (void) emailLogFromViewController: (UIViewController *) controller;
@end
