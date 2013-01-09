//
//  ViewController.h
//  IIM-PUSH
//
//  Created by Ajay Hegde on 12/24/12.
//  Copyright (c) 2012 Ajay Hegde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate,UIPopoverControllerDelegate>{
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *searchData;
    NSArray *storeData;
    UIBarButtonItem *logOutButton;
    UIBarButtonItem *filterButton;
    
    UIPopoverController *popOver;
}

@property(nonatomic,strong)NSArray *opportunity;
@property(nonatomic,strong)UISearchBar *searchBar;
 

@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic) DetailViewController *detailViewController;


@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *activityIndicator;
@property(strong,nonatomic)IBOutlet UIPopoverController *popOver;

-(void)displayTableView;


@end
