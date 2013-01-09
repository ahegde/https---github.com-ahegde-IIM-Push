//
//  DetailViewController.h
//  IIM-PUSH
//
//  Created by Ajay Hegde on 12/30/12.
//  Copyright (c) 2012 Ajay Hegde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface DetailViewController : UIViewController<MFMailComposeViewControllerDelegate>{
 
    NSInteger rowValue;

}

@property (nonatomic,strong) NSArray *opportunity;
@property (nonatomic, assign) NSInteger rowValue;
@property (nonatomic,strong) NSArray *ids;

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *closeDate;
@property (strong, nonatomic) IBOutlet UILabel *amount;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UILabel *account;
@property (strong, nonatomic) IBOutlet UILabel *owner;
@property (strong, nonatomic) IBOutlet UILabel *leadSource;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *closeDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountLabel;
@property (strong, nonatomic) IBOutlet UILabel *ownerLabel;
@property (strong, nonatomic) IBOutlet UILabel *leadSourceLabel;


@property (strong, nonatomic) IBOutlet UIImageView *imageView;


-(void)displayData:(NSString*)name;
-(void)detailId:(NSArray*)ids;
@end
