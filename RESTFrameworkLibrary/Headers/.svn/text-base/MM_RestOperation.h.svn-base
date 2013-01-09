//
//  MM_RestOperation.h
//
//  Created by Ben Gottlieb on 11/14/11.
//  Copyright (c) 2011 Model Metrics, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFRestRequest.h"
#import "SFRestAPI.h"

@class MM_SOQLQueryString, MM_SFObjectDefinition, MMSF_Object;

typedef void (^restArgumentBlock)(NSError *error, id jsonResponse);
typedef void (^dataArgumentBlock)(NSError *error, NSData *results);

@interface MM_RestOperation : NSObject <SFRestDelegate>

@property (nonatomic, copy) restArgumentBlock completionBlock;
@property (nonatomic, strong) SFRestRequest *request;
@property (nonatomic, strong) NSString *tag, *groupTag;					//two items with the same groupTag will not run simultaneously
@property (nonatomic) BOOL iWorkAlone;									//if set, this connection will run all by itself
@property (nonatomic) BOOL isCleanupOperation;							//if set, this connection is intended to run after all the others
@property (nonatomic, strong) NSString *oauthRequiredPath;				//a path to a server resource that will require OAuth creds
@property (nonatomic, strong) MM_SOQLQueryString *query;
@property (nonatomic, copy) simpleBlock fireBlock;
@property (nonatomic, copy) NSString *destinationFilePath, *createOrUpdateObjectID, *boundaryString, *objectName;
@property (nonatomic, retain) NSData *postPayload;

+ (void) queueCountOperationForObjectDefinition: (MM_SFObjectDefinition *) definition;
+ (void) queueSyncOperationsForObjectDefintion: (MM_SFObjectDefinition *) definition;

+ (MM_RestOperation *) operationWithBlock: (simpleBlock) block;
+ (MM_RestOperation *) operationWithRequest: (SFRestRequest *) request completionBlock: (restArgumentBlock) block;
+ (MM_RestOperation *) operationWithRequest: (SFRestRequest *) request groupTag: (id) groupTag completionBlock: (restArgumentBlock) block;
+ (MM_RestOperation *) operationWithQuery: (MM_SOQLQueryString *) query groupTag: (id) groupTag completionBlock: (restArgumentBlock) block;
+ (MM_RestOperation *) dataOperationWithOAuthPath: (NSString *) path completionBlock: (dataArgumentBlock) block;
+ (MM_RestOperation *) postOperationWithSalesforceID: (NSString *) sfid pushingData: (NSData *) data ofMimeType: (NSString *) mimeType toField: (NSString *) field onObjectType: (NSString *) entityName completionBlock: (dataArgumentBlock) block;
+ (MM_RestOperation *) operationToCreateObject: (MMSF_Object *) object completionBlock: (dataArgumentBlock) block;
- (void) start;
@end
