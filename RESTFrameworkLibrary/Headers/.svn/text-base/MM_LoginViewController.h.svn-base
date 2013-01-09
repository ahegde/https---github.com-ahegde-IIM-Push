//
//  MM_LoginViewController.h
//
//  Created by Ben Gottlieb on 11/13/11.
//  Copyright 2011 Model Metrics, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFOAuthCoordinator.h"


@interface MM_LoginViewController : UIViewController <SFOAuthCoordinatorDelegate, UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, weak) IBOutlet UISwitch *serverToggleSwitch;

@property (nonatomic) BOOL canCancel;				//can the user cancel this? If not, there will be no cancel button on iPhone, and the user won't be able to cancel by tapping outside a popover on iPad 
@property (nonatomic) BOOL canToggleServer;			//show the Dev switch to toggle between Production and Sandbox servers
@property (nonatomic) BOOL useTestServer;			//should we hit Prod or Sandbox initially
@property (nonatomic) BOOL forceLoginOnFreshInstall;//if the user is installing a fresh copy (ie, they deleted beforehand), require a new login
@property (nonatomic, retain) NSString *preloadedPassword, *preloadedUsername;	//used when testing, allows you to pre-fill the username and password fields in the web form
@property (nonatomic, retain) NSString *credentialsIdentifier;	//defaults to the application identifier; used to distinguish credentials from one another. Generally leave it alone
@property (nonatomic) BOOL wasUIPresented;			//was any UI presented in a -login call?
@property (nonatomic, readonly) BOOL newUserLoggedIn;	//is the just-logged-in user different from the last user?

+ (MM_LoginViewController *) presentModallyInParent: (UIViewController *) parent;
+ (MM_LoginViewController *) presentFromBarButtonItem: (UIBarButtonItem *) item;
+ (MM_LoginViewController *) currentController;
+ (void) logout;
+ (BOOL) isLoggedIn;
+ (BOOL) isAuthenticated;
+ (BOOL) isLoggingOut;

+ (void) setRedirectURI: (NSString *) redirectURI;
+ (void) setLoginDomain: (NSString *) loginDomain;
+ (void) setRemoteAccessConsumerKey: (NSString *) remoteAccessConsumerKey;

@end



@interface SFOAuthCoordinator (MMFramework)
@property (nonatomic, readonly) NSString *fullUserId;

+ (NSString *) fullUserId;
+ (NSString *) currentAccessToken;
+ (NSURL *) currentInstanceURL;
+ (NSURL *) currentIdentityURL;
@end