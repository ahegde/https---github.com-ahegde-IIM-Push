//
//  MM_SyncManager.h
//
//  Created by Ben Gottlieb on 11/14/11.
//  Copyright (c) 2011 Model Metrics, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MM_RestOperation.h"
#import "MM_SFObjectDefinition.h"

@class MMSF_Object;

@interface MM_SyncManager : NSObject
SINGLETON_INTERFACE_FOR_CLASS_AND_METHOD(MM_SyncManager, sharedManager);

@property (nonatomic, readonly) dispatch_queue_t parseDispatchQueue, syncDispatchQueue;
@property (nonatomic) int maxSimultaneousConnections;
@property (nonatomic, readonly) NSArray *objectsToSync;
@property (nonatomic, strong) NSArray *lastSyncedObjects;
@property (nonatomic) BOOL isModelUpdateInProgress, isSyncInProgress, hasSyncedOnce, queueStopped, syncInterrupted;
@property (nonatomic, strong) NSMutableArray *pending, *active, *pendingObjectNames;


- (BOOL) cancelSync;
- (void) queueOperation: (MM_RestOperation *) op;
- (void) queueOperation: (MM_RestOperation *) op atFrontOfQueue: (BOOL) atFrontOfQueue;
- (void) dequeueOperation: (MM_RestOperation *) op completed: (BOOL) completed;
- (BOOL) fetchRequiredMetaData: (BOOL) refetch withCompletionBlock: (simpleBlock) completionBlock;			//this will automatically kick off a sync when its complete if no block is passed
- (BOOL) downloadObjectDefinitionsWithCompletionBlock: (simpleBlock) block;
- (void) stopQueue;

- (BOOL) synchronize: (NSArray *) objects withCompletionBlock: (booleanArgumentBlock) completionBlock;
- (BOOL) fullResync: (NSArray *) objects withCommpletionBlock: (booleanArgumentBlock) completionBlock;

+ (id) currentUserInContext: (NSManagedObjectContext *) ctx;
- (BOOL) resyncAllDataWithCompletionBlock: (booleanArgumentBlock) completionBlock;

- (BOOL) areDependenciesMet: (NSString *) dependencies;
- (void) markObjectAsSynced: (MM_SFObjectDefinition *) objectDef;
- (void) queuePendingDefinitionSync: (MM_SFObjectDefinition *) objectDef;
- (void) connectMissingLinks;
@end
