#import "MM_LoginViewController.h"
#import "MM_OrgMetaData.h"
#import "MM_Notifications.h"
#import "MM_Constants.h"
#import "MM_SyncManager.h"
#import "MM_ContextManager.h"
#import "MMSF_Object.h"
#import "MM_SFObjectDefinition.h"
#import "MM_Log.h"
#import "MM_SFChange.h"
#import "MM_SOQLQueryString.h"
#import "MM_Config.h"

/******************* Define these in your PCH file *********************************************************
#define			kRemoteAccessConsumerKey			@"3MVG99OxTyEMCQ3jIW9bdxrL5aAIBz8a993UAC3dntUFefeCE.FJeLrZ.Tt.vcR4USTTa2_H3EGJ6Ajt4dFOw"
#define			kOAuthRedirectURI					@"https://login.salesforce.com/services/oauth2/success"
#define			kOAuthLoginDomain					@"login.salesforce.com"
***********************************************************************************************/