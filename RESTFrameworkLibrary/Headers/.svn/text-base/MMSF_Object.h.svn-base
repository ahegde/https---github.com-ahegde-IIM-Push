


/**************************************************
 *
 *	This class serves as a generic base class for all 
 *	objects pulled out of the context
 *
 *	If you want to create a custom subclass for an object, 
 *	say, Contact, create a class named "MMSF_Contact", and 
 *	the framework will link it appropriately.
 *
 *	To generate a custom query when syncing, override the 
 *	class method
 *
 *		+ (MM_SOQLQueryString *) baseQueryIncludingData: (BOOL) includeDataBlobs;
 *
 *	To make multiple, or unusual, calls when syncing, implement:
 *	
 *		+ (void) syncWithQuery: (MM_SOQLQueryString *) query;
 *		
 *		A sample implementation might look like:
 *	{
 * 		MM_RestOperation	*op = [MM_RestOperation operationWithQuery: query 
 *															  groupTag: self.objectIDString 
 *													   completionBlock: ^(NSError *error, id json) { 
 *															[self.definition parseJSONResponse: json withError: error]; 
 *														}];
 * 
 *		[[MM_SyncManager sharedManager] queueOperation: op];
 *	}
 *
 *
 **************************************************/



@class MM_SFObjectDefinition;


@interface MMSF_Object : NSManagedObject

@property (nonatomic, retain) NSDictionary *lastSnapshot;
@property (nonatomic, retain) NSString *Id;
@property (nonatomic, readonly) NSDate *LastModifiedDate, *CreatedDate, *SystemModStamp;
@property (nonatomic, readonly) MMSF_Object *owner;
@property (nonatomic, strong) MMSF_Object *RecordTypeId;
@property (nonatomic, readonly) NSString *recordTypeName, *Name;
@property (nonatomic, readonly) MM_SFObjectDefinition *definition;
@property (nonatomic) BOOL shouldRollbackFailedSaves;
@property (nonatomic, readonly) BOOL isEmptyObject, existsOnSalesforce;
@property (nonatomic, strong) MMSF_Object *parent;				//for an object with a ParentId polymorphic relationship


+ (NSString *) entityName;
+ (NSDictionary *) shadowFieldNamesFromRelationships: (NSDictionary *) relationships andAttributes: (NSDictionary *) attributes;
+ (void) clearSFIDCache;
+ (NSString *) privateDocumentsPath;

- (void) importRecord: (NSDictionary *) record includingDataBlobs: (BOOL) includingDataBlobs;
- (void) deleteFromSalesforce;						//call this to delete the object from the server
- (void) wasDeletedFromSalesforce;					//[NOT CURRENTLY IMPLEMENTED. Use -prepareForDeletion instead] this is called during a sync if the object was deleted from the server since the last sync

- (NSDictionary *) snapshot;
- (void) beginEditing;
- (void) finishEditingSavingChanges: (BOOL) saveChanges;
- (void) finishEditingSavingChanges: (BOOL) saveChanges andPushingToServer: (BOOL) pushNow;
- (void) rollbackToSnapshot: (NSDictionary *) snapshot;
- (BOOL) fieldIsReadOnly: (NSString *) field;

- (void) refreshDataBlobs: (BOOL) onlyIfNeeded;
- (void) refreshDataBlobsIfNeeded;

- (NSSet *) attachments;
- (NSString *) stringForKeyPath: (NSString *) keyPath;		//can pass either a string keyPath, or an array. If an array is passed, it's assumed to be a format string followed by keyPaths
- (NSString *) titleForDataField: (NSString *) dataFieldName;
- (NSString *) pathForDataField: (NSString *) dataFieldName;
- (void) setStringValue: (NSString *) value forKey: (NSString *) key;

- (BOOL) connectMissingLinksUsingRelationships: (NSDictionary *) relationships attributes: (NSDictionary *) attributes shadowFieldNames: (NSDictionary *) shadowFieldNames andDataFields: (NSMutableSet *) dataFields;

- (void) reloadFromServer;
- (void) didFailToSaveToServerWithError: (NSError *) error;
- (void) didSaveToServer: (BOOL) isNew;

+ (void) setDynamicRecordLinkingEnabled: (BOOL) enabled;
+ (BOOL) isDynamicRecordLinkingEnabled;

- (NSArray *) picklistOptionsForField: (NSString *) fieldName;
- (NSString *) labelForField: (NSString *) field;

- (MMSF_Object *) parentOfType: (NSString *) type;			//for an object with a ParentId polymorphic relationship

+ (void) connectReturnedSalesforceID: (NSString *) sfid toObjectID: (NSString *) objectID forField: (NSString *) field onEntity: (NSString *) entityName inContext: (NSManagedObjectContext *) moc;	//used when fetching the parent of a ParentId link
@end


@interface NSString (MMSF_Object)
- (id) valueForField: (NSString *) field inRecord: (NSManagedObject *) record;
@end


typedef NSString * (^recordFieldCalculationBlock)(MMSF_Object *record);
