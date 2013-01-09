//
//  MM_BasicRecordsTable.h
//  SOQLBrowser
//
//  Created by Ben Gottlieb on 11/30/11.
//  Copyright (c) 2011 Stand Alone, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MM_Headers.h"

@interface MM_BasicRecordsTable : UITableView <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, retain) NSArray *records;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSString *entityName, *sortField;
@property (nonatomic, retain) MM_SFObjectDefinition *objectDefinition;

@property (nonatomic, retain) UIColor *evenColumnBackgroundColor, *oddColumnBackgroundColor, *evenColumnTextColor, *oddColumnTextColor;
@property (nonatomic, retain) UIFont *headerFont, *contentFont;

- (void) reloadRecords;

@end
