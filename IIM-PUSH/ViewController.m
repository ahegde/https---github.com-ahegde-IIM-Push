//
//  ViewController.m
//  IIM-PUSH
//
//  Created by Ajay Hegde on 12/24/12.
//  Copyright (c) 2012 Ajay Hegde. All rights reserved.
//

#import "ViewController.h"
#import "MM_Notifications.h"
#import "AppDelegate.h"
#import "MM_ContextManager.h"
#import "MM_SyncManager.h"
#import "MM_Headers.h"
#import "MMSF_Opportunity.h"
#import "AppDelegate.h"
#import "PopOverViewController.h"

@interface ViewController ()

@end


@implementation ViewController
@synthesize opportunity;
@synthesize tableView;
@synthesize detailViewController;
@synthesize searchBar;
@synthesize activityIndicator;
@synthesize popOver;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)  name:UIDeviceOrientationDidChangeNotification  object:nil];

    //set background image for a view
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    //setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"header_bar.png"]]];
    
    
    //email button
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont boldSystemFontOfSize:15],
                                    UITextAttributeFont,
                                    [UIColor clearColor],
                                    UITextAttributeTextShadowColor, nil];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"empty_button_unselected.png"] forState:UIControlStateNormal barMetrics:nil]; //setBackground:[UIImage imageNamed:@"empty_button_unselected.png"]];

    
    
    searchData = [[NSMutableArray alloc] init];
    [self addAsObserverForName: kNotification_DidLogIn selector: @selector(loginComplete:)];
    
    
  
    
    
	// Do any additional setup after loading the view, typically from a nib.
    //[self.view setBackgroundColor:[UIColor redColor]];
   
}


//Change the view based on orientation change
-(void)viewDidAppear:(BOOL)animated{
     
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
        [self.activityIndicator setFrame:CGRectMake(367, 482, 37, 37)];
        
    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        //load the landscape view
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header_bar_landscape.png"] forBarMetrics:nil];
        [self.activityIndicator setFrame:CGRectMake(482, 367, 37, 37)];
        
        
    }}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginComplete: (NSNotification *) note {
    if([MM_SyncManager sharedManager].hasSyncedOnce==YES)
        [self displayTableView];
    
}

-(void)popOverMethodForFilter{
     
    [popOver setPopoverContentSize:CGSizeMake(300, 200)];
    [popOver presentPopoverFromBarButtonItem:filterButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)displayTableView{
    
    
    [activityIndicator stopAnimating];
    opportunity =  [[[AppDelegate sharedInstance] context] allObjectsOfType:@"Opportunity" matchingPredicate:nil];
    
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    //[searchBar setBackgroundImage:[UIImage imageNamed:@"search_bar_1.png"]];
    searchBar.tintColor = [UIColor colorWithRed:255.0/255.0 green:229.0/255.0 blue:199.0/255.0 alpha:1];
    
    //add a logOut button
    logOutButton = [[UIBarButtonItem alloc] initWithTitle:@"LogOut" style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonPressed:)];
    
    
    //add a logOut button
    
    
    
    
    
    //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //filterButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(popOverMethodForFilter)];
    //self.navigationItem.rightBarButtonItem = filterButton;
    
    NSArray *array = [[NSArray alloc] initWithObjects:logOutButton,filterButton, nil];
    
    self.navigationItem.rightBarButtonItems = array;
    
    
    PopOverViewController *popObject =[[PopOverViewController alloc] init];
    popOver = [[UIPopoverController alloc] initWithContentViewController:popObject];
    
    
    popOver.delegate=self;

    
    
    
    
    [logOutButton setBackButtonBackgroundImage:[UIImage imageNamed:@"logout_button_unselected.png"] forState:UIControlStateNormal barMetrics:nil];
     [logOutButton setBackButtonBackgroundImage:[UIImage imageNamed:@"logout_button_selected.png"] forState:UIControlEventTouchUpInside barMetrics:nil];
    
    
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    /*contents controller is the UITableViewController, this let you to reuse
     the same TableViewController Delegate method used for the main table.*/
    
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;

    
    //    [self.view addSubview:searchBar];
    //set the delegate = self. Previously declared in ViewController.h
    
    
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                                  style:UITableViewStylePlain];
    
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.navigationController.navigationBar setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    [self.activityIndicator setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    
    //set background image for a view
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [self.tableView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line_seperator.png"]]];
    
    self.tableView.tableHeaderView = searchBar; //this line add the searchBar
    //on the top of tableView.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [searchData removeAllObjects];
    
    if(searchString.length==0)
        return false;
    
    /*before starting the search is necessary to remove all elements from the
     array that will contain found items */
    
//    NSArray *group;
    
    /* in this loop I search through every element (group) (see the code on top) in
     the "originalData" array, if the string match, the element will be added in a
     new array called newGroup. Then, if newGroup has 1 or more elements, it will be
     added in the "searchData" array. shortly, I recreated the structure of the
     original array "originalData". */
    

    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSMutableArray *storeValues = [[NSMutableArray alloc] init];
    NSLog(@"opportunity count %d and opprtunity array %@",opportunity.count,[[opportunity valueForKey:@"Name"] objectAtIndex:0]);
    
    for (int i=0; i<opportunity.count; i++) {
        [data addObject:[[opportunity valueForKey:@"Name"] objectAtIndex:i]];
    }
    
    
     NSString *element;
    for(element in data) //take the n group (eg. group1, group2, group3)
        //in the original data
    {
        NSMutableArray *newGroup = [[NSMutableArray alloc] init];
       
//        NSLog(@"search string %@ aND GROUP IS %@",searchString,group);
//        for(element in group) //take the n element in the group
//        {                    //(eg. @"Napoli, @"Milan" etc.)
            NSRange range = [element rangeOfString:searchString
                                           options:NSCaseInsensitiveSearch];
            
            if (range.length > 0) { //if the substring match
                [newGroup addObject:element]; //add the element to group
            }
//        }
//        NSLog(@"new groupan values %@",newGroup);
        
        if ([newGroup count] > 0) {
            [storeValues addObject:newGroup];
        }
        
        [newGroup release];
    }
    
    if(storeValues.count!=0){
//    NSLog(@"search data count %d and %@",storeValues.count,[storeValues objectAtIndex:0]);
    for (int k=0;k<storeValues.count;k++) {
        [searchData addObject:[storeValues objectAtIndex:k]];
        
    }
    }else
        return false;
    
//    NSLog(@"store values %@",[searchData objectAtIndex:0]);
    return YES;
}


-(IBAction)logoutButtonPressed:(id)sender{
    
    [self.view removeAllSubviews];
    
    [MM_LoginViewController logout];
    if(![MM_LoginViewController isLoggedIn]){
        [logOutButton setTitle:@"LogIn"];
        
    }
    
    
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign In"
                                                                    style:UIBarButtonSystemItemDone target:self action:@selector(signIn)];
    self.navigationItem.rightBarButtonItem = rightButton;
   

    
}

-(void)signIn{
    [MM_LoginViewController setRedirectURI:kOAuthRedirectURI];
    [MM_LoginViewController setLoginDomain:kOAuthLoginDomain];
	[MM_LoginViewController setRemoteAccessConsumerKey:kRemoteAccessConsumerKey];
    
    [MM_LoginViewController presentModallyInParent:self];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(searchData.count==0)
        return opportunity.count;
    else
        return searchData.count;
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
   
	
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    cell.textLabel.textColor = [UIColor colorWithRed:131.0/255.0 green:75.0/255.0 blue:24.0/255.0 alpha:1];
    if(searchData.count==0)
        cell.textLabel.text = [[opportunity valueForKey:@"Name"] objectAtIndex:indexPath.row];
    else{
        for( NSString *values in [searchData objectAtIndex:indexPath.row])
        cell.textLabel.text = values;
        
    }
    
	return cell;
}

// Step 9 a - Load audio when Attachment is selected
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        detailViewController =[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        
        detailViewController.rowValue=indexPath.row;
        [self.navigationController pushViewController:detailViewController animated:YES];
    } else {
        detailViewController =[[DetailViewController alloc] initWithNibName:@"DetailViewController_ipad" bundle:nil];
        
        detailViewController.rowValue=indexPath.row;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
  
    
}

//support both orientations
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}


@end
