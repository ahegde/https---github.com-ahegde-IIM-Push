//
//  SA_MemoryDisplayView.h
//  Crosswords
//
//  Created by Ben Gottlieb on 12/23/08.
//  Copyright 2008 Stand Alone, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SA_MemoryDisplayView : UIView {
	NSTimer					*_timer;
}

+ (id) addMemoryView: (UIView *) parent;
+ (id) addMemoryView: (UIView *) parent atYPosition: (float) yPosition;

+ (void) showMemoryView;
+ (void) hideMemoryView;

@end
