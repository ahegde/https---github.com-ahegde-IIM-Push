#import "_MM_SFObjectDefinition.h"
#import "NSEntityDescription+MM.h"

@class MM_RestOperation, MM_SOQLQueryString;

/**************************************************
 *
 *	This class serves as a definition and conglomeration of everything
 *	the app knows about each entity in the org.
 *
 *	It combines the basic metadata from salesforce (the generic list of all objects),
 *	the specific meta data for any object the app decides is 'of interest', and any
 *	app-specific data, such as fields to ignore and indexes to generate
 *
 *	In addition, it's in charge of syncing each particular object with the server.
 *
 **************************************************/

@protocol MMSF_ObjectClass
- (MM_SOQLQueryString *) baseQueryIncludingData: (BOOL) skipData;
- (void) syncWithQuery: (MM_SOQLQueryString *) query;
- (void) downloadAndImportComplete;
@end

// Use this line to update the mogen-created classes after modifying the xcdatamodel for the meta database
//		mogenerator -m MetaModel.xcdatamodeld/MetaModel.xcdatamodel -M machine -H human —template-var arc= true

#define JOIN_FIELD_SEPARATOR_STRING			@""			//currently, lookups in other tables are concatenated together when accessing. e.g., Account.Name becomes AccountName.

@class MM_SOQLQueryString, MMSF_Object;
@interface MM_SFObjectDefinition : _MM_SFObjectDefinition

@property (nonatomic, readonly) NSArray *queriedFields;
@property (nonatomic, readonly) BOOL shouldSyncServerData;									//does this object need to pull down server data? Uses the write-only flag in the Sync_Objects.plist
@property (nonatomic, readonly) BOOL requiresPostSyncLink;									//should we link all new records immediately after syncing?
@property (nonatomic, readonly) BOOL reloadOnObjectCreation;								//after creating a new object, should we pull it down to get any server-created data?
@property (nonatomic, readonly) NSString *syncDependencies;									//what objects should be downloaded and parsed before we run our query?
@property (nonatomic, readonly) Class objectClass;
@property (nonatomic, readonly) NSArray *dataFieldNames;									//which fields are considered binary data, and should be downloaded separately

+ (BOOL) orgObjectsHaveBeenInitialized;
+ (MM_SFObjectDefinition *) objectNamed: (NSString *) name inContext: (NSManagedObjectContext *) ctx;
+ (void) setParsingMemoryFactor: (float) factor;											//if you're having memory issues when parsing large amounts of data, try setting this to < 1.0.

/************** Sync methods ********************************************************/
- (BOOL) isUpToDate: (NSDate *) date;							//determine if an object has been synced since a certain date
- (void) queueSyncOperationsForQuery: (MM_SOQLQueryString *) query;	//queue sync operation(s) based off a given query
- (void) resetLastSyncDate;										//reset last sync (the next sync will grab ALL objects)
- (void) resetSyncAndDeleteAllData;								//same as above, will also clear out all data

/************** Overridable methods ********************************************************/
- (MM_SOQLQueryString *) baseQueryIncludingData: (BOOL) includeDataBlobs;		//provide a base query for the object, used to get initial data set


/************** UI-related methods ********************************************************/
- (NSString *) labelForField: (NSString *) field;

/************** Internal/Framework methods ********************************************************/
- (MM_RestOperation *) fetchMetaData: (BOOL) refetch;
- (NSEntityDescription *) entityDescription;
- (NSUInteger) countAndConnectAllMissingLinksInContext: (NSManagedObjectContext *) ctx showingProgress: (BOOL) showingProgress;
- (void) connectAllMissingLinksInContext: (NSManagedObjectContext *) ctx showingProgress: (BOOL) showingProgress;
- (NSUInteger) numberOfMissingLinkRecordsInContext: (NSManagedObjectContext *) ctx;
+ (void) importGlobalObjectList: (NSArray *) sobjects;

- (NSArray *) picklistOptionsForField: (NSString *) fieldName;
- (NSArray *) picklistOptionsForField: (NSString *) fieldName basedOffRecord: (MMSF_Object *) record;
- (NSArray *) picklistOptionsForField: (NSString *) fieldName basedOffRecordType: (MMSF_Object *) recordType;
- (NSArray *) availableRecordTypesInContext: (NSManagedObjectContext *) moc;
- (NSDictionary *) infoForField: (NSString *) fieldName;
- (NSAttributeType) typeOfField: (NSString *) fieldName;
- (id) metadataValueForKey: (NSString *) key;
- (void) parseJSONResponse: (id) json withError: (NSError *) error completion: (simpleBlock) completion;


@end


@interface NSDate (Salesforce)
- (NSString *) salesforceStringRepresentation;
@end
