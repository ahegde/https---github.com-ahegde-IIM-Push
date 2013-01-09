//
//  MM_ContextManager.h
//
//  Created by Ben Gottlieb on 11/13/11.
//  Copyright (c) 2011 Model Metrics, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**************************************************
 *
 *	The Context Manager object is a singleton used to create new contexts for importing, editing, and viewing
 *
 *	When a importing, create a new contextForWriting, and save changes to it. When complete, push those changes
 *	up the chain by saving. Finally, save the main context to write them to 'disk'
 *
 **************************************************/

typedef NSManagedObjectContext MM_ManagedObjectContext;

@interface MM_ContextManager : NSObject

@property (nonatomic, strong, readonly) MM_ManagedObjectContext *mainMetaContext, *mainContentContext, *threadMetaContext, *threadContentContext;
@property (nonatomic, strong) NSString *metaContextPath, *contentContextPath;
@property (nonatomic, readonly) dispatch_queue_t importDispatchQueue;
@property (nonatomic, strong) NSManagedObjectModel *contentModel;
@property (nonatomic, strong) NSManagedObjectModel *metaContextModel;

SINGLETON_INTERFACE_FOR_CLASS_AND_METHOD(MM_ContextManager, sharedManager);

+ (void) setStoreFileProtection: (NSString *) protection;
+ (void) saveMetaContext;
+ (void) saveContentContext;

- (void) removeAllData;

- (void) saveMetaContext;
- (void) saveContentContext;
- (void) saveMetaContextWithBlock: (simpleBlock) block;
- (void) saveContentContextWithBlock: (simpleBlock) block;
- (void) saveAndClearContentContext;

- (MM_ManagedObjectContext *) metaContextForWriting;
- (MM_ManagedObjectContext *) contentContextForWriting;
- (void) resetContentContext;
- (BOOL) objectExistsInContentModel: (NSString *) objectName;

- (BOOL) missingLinksAreConnectedForObjectNamed: (NSString *) object;
- (void) setMissingLinksAreConnected: (BOOL) exist forObjectNamed: (NSString *) objectName;
- (void) pushAllPendingChangesAndRemoveAllData;

- (id) objectInNewContext: (NSManagedObject *) object;
@end
