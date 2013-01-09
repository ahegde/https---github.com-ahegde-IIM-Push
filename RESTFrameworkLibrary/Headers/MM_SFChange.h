#import "_MM_SFChange.h"

@class MMSF_Object;

#define SNAPSHOT_OBJECT_SUFFIX				@"__MM_ObjectID_/"
#define SNAPSHOT_SFID_SUFFIX				@"__MM_SFID_/"

#define	FIELD_BY_ADDING_OBJET_SUFFIX(f)		([f stringByAppendingString: SNAPSHOT_OBJECT_SUFFIX])
#define	FIELD_BY_REMOVING_OBJECT_SUFFIX(f)	([f substringToIndex: f.length - SNAPSHOT_OBJECT_SUFFIX.length])
#define	IS_FIELD_SNAPSHOT_OF_OBJECT(f)		([f hasSuffix: SNAPSHOT_OBJECT_SUFFIX])

@interface MM_SFChange : _MM_SFChange

@property (nonatomic, readonly) NSDictionary *modifiedValuesForServer;				//this returns the modified values with all records replaced with Salesforce IDs

+ (void) setPendingObjectInterval: (NSTimeInterval) interval;

+ (void) queueChangeForObject: (MMSF_Object *) object withOriginalValues: (NSDictionary *) original changedValues: (NSDictionary *) changedValues;
+ (void) queueDeleteForObject: (MMSF_Object *) object;
+ (void) pushPendingChanges;
+ (void) pushPendingChangesWithCompletionBlock: (booleanArgumentBlock) completion;
+ (BOOL) doesChangeExistForObject: (MMSF_Object *) object;
+ (void) removePendingChangesForObject: (MMSF_Object *) object;
+ (NSUInteger) numberOfPendingChanges;

+ (void) stopPushingChanges;													//call to stop pushing changes to the server
+ (void) startPushingChanges;

- (void) rollback;

- (NSDictionary *) originalValuesInContext: (NSManagedObjectContext *) moc;
- (void) setOriginalValues: (NSDictionary *) originalValues;

- (NSDictionary *) modifiedValuesInContext: (NSManagedObjectContext *) moc;
- (void) setModifiedValues: (NSDictionary *) modifiedValues;
+ (void) clearAllPendingChangesForUserID: (NSString *) sfID;
@end


@interface NSDictionary (MMSF_Snapshots)
@property (nonatomic, readonly) NSDictionary *dictionaryByConvertingObjectsToIDs;

- (NSDictionary *) dictionaryByConvertingIDsToObjectsInContext: (NSManagedObjectContext *) moc;
@end