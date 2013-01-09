//
//  DetailViewController.m
//  IIM-PUSH
//
//  Created by Ajay Hegde on 12/30/12.
//  Copyright (c) 2012 Ajay Hegde. All rights reserved.
//

#import "DetailViewController.h"
#import "MM_Notifications.h"
#import "AppDelegate.h"
#import "MM_ContextManager.h"
#import "MM_SyncManager.h"
#import "MM_Headers.h"
#import "SA_Base.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize opportunity;
@synthesize rowValue;
@synthesize name,closeDate,status,amount,ids;
@synthesize account,owner,leadSource,imageView;

@synthesize nameLabel,accountLabel,amountLabel,leadSourceLabel,statusLabel,ownerLabel,closeDateLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)  name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"back_button_unselected_1.png"] forState:UIControlStateNormal barMetrics:nil];
    
    UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithTitle:@"Email" style:UIBarButtonItemStylePlain target:self action:@selector(sendEmail)];
    
    //self.navigationItem.rightBarButtonItem = emailButton;
    UIBarButtonItem *chatterButton = [[UIBarButtonItem alloc] initWithTitle:@"Chatter" style:UIBarButtonItemStylePlain target:self action:nil];
    //self.navigationItem.rightBarButtonItem = chatterButton;
    
    NSArray *array = [[NSArray alloc] initWithObjects:emailButton,chatterButton, nil];
    
    self.navigationItem.rightBarButtonItems = array;
    
    //set background image for a view
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    
    //setautoresizing mask for imageview
    [self.imageView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    
    
    NSString *stringId;
    if(ids.count!=0){
        stringId = [ids objectAtIndex:0];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"Id contains[cd] %@",stringId];
        
        opportunity = [[[AppDelegate sharedInstance] context] allObjectsOfType:@"Opportunity" matchingPredicate:pred];
        [status setText:@"Closed Won"];
    }else{
    
    opportunity =  [[[AppDelegate sharedInstance] context] allObjectsOfType:@"Opportunity" matchingPredicate:nil];
        [status setText:[[opportunity valueForKey:@"StageName"] objectAtIndex:rowValue]];
    }
 
    //set the font color for a label
    nameLabel.textColor = [UIColor colorWithRed:131.0/255.0 green:75.0/255.0 blue:24.0/255.0 alpha:1];
    closeDateLabel.textColor = [UIColor colorWithRed:131.0/255.0 green:75.0/255.0 blue:24.0/255.0 alpha:1];
    accountLabel.textColor = [UIColor colorWithRed:131.0/255.0 green:75.0/255.0 blue:24.0/255.0 alpha:1];
    ownerLabel.textColor = [UIColor colorWithRed:131.0/255.0 green:75.0/255.0 blue:24.0/255.0 alpha:1];
    amountLabel.textColor = [UIColor colorWithRed:131.0/255.0 green:75.0/255.0 blue:24.0/255.0 alpha:1];
    leadSourceLabel.textColor = [UIColor colorWithRed:131.0/255.0 green:75.0/255.0 blue:24.0/255.0 alpha:1];
    statusLabel.textColor = [UIColor colorWithRed:131.0/255.0 green:75.0/255.0 blue:24.0/255.0 alpha:1];
    
    
    name.textColor = [UIColor colorWithRed:131.0/255.0 green:75.0/255.0 blue:24.0/255.0 alpha:1];
    amount.textColor = [UIColor colorWithRed:131.0/255.0 green:75.0/255.0 blue:24.0/255.0 alpha:1];
    leadSource.textColor = [UIColor colorWithRed:131.0/255.0 green:75.0/255.0 blue:24.0/255.0 alpha:1];
    owner.textColor = [UIColor colorWithRed:131.0/255.0 green:75.0/255.0 blue:24.0/255.0 alpha:1];
    status.textColor = [UIColor colorWithRed:131.0/255.0 green:75.0/255.0 blue:24.0/255.0 alpha:1];
    closeDate.textColor = [UIColor colorWithRed:131.0/255.0 green:75.0/255.0 blue:24.0/255.0 alpha:1];
    account.textColor = [UIColor colorWithRed:131.0/255.0 green:75.0/255.0 blue:24.0/255.0 alpha:1];
    
    
    
    
    
    [name setText:[[opportunity valueForKey:@"Name"] objectAtIndex:rowValue]];
    if([[opportunity valueForKey:@"Amount"] objectAtIndex:rowValue]  != 0)
        [amount setText:[[[opportunity valueForKey:@"Amount"] objectAtIndex:rowValue] stringValue]];
    else
        [amount setText:@"NA"];
  

    if ([[opportunity valueForKey:@"LeadSource"] objectAtIndex:rowValue]!= [NSNull null])
        [leadSource setText:[[opportunity valueForKey:@"LeadSource"] objectAtIndex:rowValue]];
    else
        [leadSource setText:@"NA"];
    
    //set the close date
    NSDate *date = [[opportunity valueForKey:@"CloseDate"] objectAtIndex:rowValue];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
   
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [format stringFromDate:date];
    [closeDate setText:dateString];
    
    [owner setText:@"SAPN Team"];

   
    

    
}

-(void)viewDidDisappear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationChanged:(NSNotification *)notification{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        //load the portrait view
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header_bar_2.png"] forBarMetrics:nil];
        [imageView setFrame:CGRectMake(488, 728, 224, 178)];
       
    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        //load the landscape view
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header_bar_landscape.png"] forBarMetrics:nil];
       
        [imageView setFrame:CGRectMake(728, 488, 224, 178)];
    }}




-(void)detailId:(NSArray*)ids{
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"Id contains[cd] %@",]
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayData:(NSString*)name{
    
}

-(void)sendEmail{
    MFMailComposeViewController *mailObject = [[MFMailComposeViewController alloc] init];
    
    if (![MFMailComposeViewController canSendMail]) {
		[SA_AlertView showAlertWithTitle: @"Please set up your Mail account on this iPad before attempting to mail a document." message: @""];
		return;
	}
    [mailObject setSubject:[NSString stringWithFormat:@"Opportunity: %@",name.text]];
    [mailObject setMessageBody:[NSString stringWithFormat:@"Close Date: %@\nStage Name: %@\nAmount: %@\n",closeDate.text,status.text,amount.text] isHTML:NO];

    mailObject.mailComposeDelegate=self;
    [self presentModalViewController: mailObject animated: YES];
 
    
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
}

//support both orientations
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}


@end
