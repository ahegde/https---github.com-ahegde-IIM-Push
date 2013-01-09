//
//  AppDelegate.m
//  IIM-PUSH
//
//  Created by Ajay Hegde on 12/24/12.
//  Copyright (c) 2012 Ajay Hegde. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "MM_LoginViewController.h"
#import "MM_Notifications.h"
#import "SA_Base.h"
#import "MM_Headers.h"
 

static BOOL registered=NO;

@implementation AppDelegate
@synthesize g_appDelegate;
@synthesize context=_context;
@synthesize navigationController;
@synthesize notificationData;

SINGLETON_IMPLEMENTATION_FOR_CLASS_AND_METHOD(AppDelegate, sharedInstance);


- (id) init {
	if ((self = [super init])) {
		g_appDelegate = self;
        
	    [self addAsObserverForName: kNotification_DidLogIn selector: @selector(loginComplete:)];
	    [self addAsObserverForName: kNotification_SyncBegan selector: @selector(syncBegan:)];
	    [self addAsObserverForName: kNotification_SyncComplete selector: @selector(syncComplete:)];
	    [self addAsObserverForName: kNotification_SyncCancelled selector: @selector(syncCancelled:)];
//	    [self addAsObserverForName: kNotification_ObjectCreated selector: @selector(objectCreated:)];
		[self addAsObserverForName: kNotification_ObjectSaveError selector: @selector(objectSaveError:)];
		[self addAsObserverForName: kNotification_SA_ErrorWhileGeneratingFetchRequest selector: @selector(fetchRequestError:)];
		[self addAsObserverForName: kNotification_QueueSaveError selector: @selector(queueSaveFailed:)];
		[self addAsObserverForName: kNotification_ConnectionStatusChanged selector: @selector(connectionStateChanged:)];
        
       
	}
   
	return self;
}

- (NSManagedObjectContext*) context{
    if (_context == nil) _context = [[MM_ContextManager sharedManager] contentContextForWriting];
	return _context;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.notificationData = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

   
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    } else {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    }
    
    self.window.rootViewController = self.navigationController;
    [self setLoginParameters];
    [MM_LoginViewController presentModallyInParent:self.viewController];
   
    [self.window makeKeyAndVisible];


    return YES;
}

//login method
- (void) logIn {
}

//
- (void) setLoginParameters
{
    [MM_LoginViewController setRedirectURI:kOAuthRedirectURI];
    [MM_LoginViewController setLoginDomain:kOAuthLoginDomain];
	[MM_LoginViewController setRemoteAccessConsumerKey:kRemoteAccessConsumerKey];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




- (void) objectSaveError: (NSNotification *) note {
	NSString				*title = [[[note.userInfo objectForKey: @"error"] userInfo] objectForKey: @"message"];
	NSManagedObjectContext	*ctx = [[MM_ContextManager sharedManager] threadContentContext];
	MMSF_Object				*obj = note.object ? (id) [ctx objectWithIDString: note.object] : nil;
	NSString				*body = [obj hasAttribute: @"Name"] ? $S(@"%@: %@", obj.entity.name, obj.Name) : obj.entity.name;
	
	TRY(if (title == nil) title = [[note.userInfo objectForKey: @"error"] localizedDescription]);
	[SA_AlertView showAlertWithTitle: title message: body button: @"Discard Change" buttonBlock: ^(BOOL canceled) {
		if (!canceled) {
			if (obj) [MM_SFChange removePendingChangesForObject: obj];
		}
	}];
}

- (void) queueSaveFailed: (NSNotification *) note {
	NSException			*e = [note.userInfo objectForKey: @"exception"];
	
	[SA_AlertView showAlertWithTitle: $S(@"Error while saving an object (%@)", note.object) message: [e description]];
}

- (void) fetchRequestError: (NSNotification *) note {
	NSString				*entityName = [note.userInfo objectForKey: @"entity"];
	
	[SA_AlertView showAlertWithTitle: $S(@"Error while fetching %@", entityName ?: @"an Object") message: [note.object description]];
}


- (void) loginComplete: (NSNotification *) note
{
    
	MMSF_Object			*user = [[MM_SyncManager currentUserInContext: nil] valueForKey: @"Id"];
	BOOL				isNewUser = [[note.userInfo objectForKey: LOGIN_NEW_USER_LOGGED_IN_KEY] boolValue] || user == nil;
	
    LOG(@"Logged in with user %@", user ?: @"<NEW USER>");
    if ([MM_OrgMetaData sharedMetaData].areAllObjectsToSyncPresent && isNewUser)
		[self performSync: YES];
    //		[[MM_SyncManager sharedManager] resyncAllDataWithCompletionBlock: nil];
	else if ([[note.userInfo objectForKey: LOGIN_UI_WAS_PRESENTED_KEY] boolValue] || ![MM_SyncManager sharedManager].hasSyncedOnce)
		[self performSync: ![MM_SyncManager sharedManager].hasSyncedOnce];
    
    
    // Go to Case in notification, if set
    if (self.notificationData) {
        [self showCaseInNotification];
    }

	//IF_DEBUG(self.currentUserIsReadOnly = YES);
}

- (void) syncBegan: (NSNotification *) note {
    [self.viewController.activityIndicator stopAnimating];
	BOOL					canCancel = [MM_SyncManager sharedManager].hasSyncedOnce;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[SA_PleaseWaitDisplay showPleaseWaitDisplayWithMajorText: @"Synchronizing with Salesforce…" minorText: @"This may take a few minutes" cancelLabel: canCancel ? @"Cancel" : nil showProgressBar: NO delegate: nil].cancelBlock = ^{
			[[MM_SyncManager sharedManager] cancelSync];
		};
	});
}

- (void) syncCancelled: (NSNotification *) note {
	[SA_PleaseWaitDisplay hidePleaseWaitDisplay];
}

- (void) syncComplete: (NSNotification *) note {

    
#if !TARGET_IPHONE_SIMULATOR
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
	 (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#endif
    [SA_PleaseWaitDisplay hidePleaseWaitDisplay];
    [self.viewController displayTableView];
    
	
}


- (void) connectionStateChanged: (NSNotification *) note {
	if (![MM_LoginViewController isLoggedIn] && ![SA_ConnectionQueue sharedQueue].offline) {
		[self logIn];
	}
}

//=============================================================================================================================
#pragma mark

- (void) performSync: (BOOL) full
{
	if ([SA_ConnectionQueue sharedQueue].offline) {
		[SA_AlertView showAlertWithTitle: @"No Internet Connection" message: @"Sorry, you can't sync while offline"];
		return;
	}
	[self syncBegan: nil];
	
	simpleBlock			fetchAndSyncBlock = ^{
		[[MM_SyncManager sharedManager] fetchRequiredMetaData: NO withCompletionBlock: ^{
			if (full) {
				[[MM_SyncManager sharedManager] resyncAllDataWithCompletionBlock: nil];
			} else
				[[MM_SyncManager sharedManager] synchronize: nil withCompletionBlock: nil];
            
            //			if ([MM_Config sharedManager].startupSyncRequired) [self preflightSyncWithCompletionBlock: nil];
            //			[SA_ConnectionQueue sharedQueue].activityIndicatorCount--;
		}];
	};
	
	[SA_ConnectionQueue sharedQueue].activityIndicatorCount++;
	if (![MM_OrgMetaData sharedMetaData].areAllObjectsToSyncPresent) {
		[[MM_SyncManager sharedManager] downloadObjectDefinitionsWithCompletionBlock: fetchAndSyncBlock];
	} else {
		fetchAndSyncBlock();
	}
}


- (NSUInteger) application: (UIApplication *) application supportedInterfaceOrientationsForWindow: (UIWindow *) window {
	
	return (NSUInteger) [application supportedInterfaceOrientationsForWindow: window] | UIInterfaceOrientationMaskPortrait;
	
}



// On successful push notification registration, save device token for user
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    

}

//  - Show error from unsuccessful push notification registration
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	[AppDelegate errorWithError:error];
}

+ (void)errorWithError:(NSError*)error {
    NSString *message;
    
    if ([error userInfo] && [[error userInfo] valueForKey:@"faultstring"]) {
        message = [[error userInfo] valueForKey:@"faultstring"]; // detailed Salesforce error
    } else {
        message = [error localizedDescription];
    }
    
	[self errorWithMessage:message];
}

+ (void)errorWithMessage:(NSString*)message {
	NSLog(@"Error: %@", message);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [self performSelectorOnMainThread:@selector(showAlert:) withObject:alert waitUntilDone:YES];
	[alert release];
}

// - Show notification alert if running
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    self.notificationData = userInfo;
	
    NSString *message = [ ( (NSDictionary*)[userInfo objectForKey:@"aps"] ) valueForKey:@"alert"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opprtunity Closed" message:message delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"View", nil];
    [alert show];
    [alert release];
}

// - Go to opportunity notification
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
        [self showCaseInNotification];
	}
}

- (void) showCaseInNotification {
    
//    decrease the badge no from client side
    
//    if([[UIApplication sharedApplication] applicationIconBadgeNumber]!=0){
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber]-1];
//    }
    
    NSArray *opptyIds = [self.notificationData objectForKey:@"opptyIds"];
    
    DetailViewController *detailViewController =[[DetailViewController alloc] initWithNibName:@"DetailViewController_ipad" bundle:nil];
    detailViewController.ids = opptyIds;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

//support both orientations
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}

@end
