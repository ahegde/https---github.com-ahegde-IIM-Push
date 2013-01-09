//
//  MM_SOQLQueryString.h
//
//  Created by Ben Gottlieb on 1/3/12.
//  Copyright (c) 2012 Model Metrics, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MM_SOQLQueryString : NSObject

@property (nonatomic, readonly) NSString *queryString;

@property (nonatomic, strong) NSArray *fields;
@property (nonatomic, strong) NSMutableArray *predicateStrings;		//not actual predicates, just stuff like (ModifiedDate < 12/12/12)
@property (nonatomic, strong) NSString *objectName, *fetchOrderField, *rawSOQL;
@property (nonatomic) BOOL fetchOrderDescending, isIDOnlyQuery, isCountQuery;
@property (nonatomic) NSUInteger fetchLimit;
@property (nonatomic, strong) NSDate *lastModifiedDate;

+ (id) queryWithObjectName: (NSString *) name;
+ (NSString *) detokenizedSOQLString: (NSString *) base;
+ (id) queryWithSOQL: (NSString *) soql;

- (void) removeAllPredicateStrings;
- (void) addPredicateString: (NSString *) predString;
@end
