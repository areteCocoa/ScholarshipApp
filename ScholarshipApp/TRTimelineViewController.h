//
//  TRTimelineViewController.h
//  ScholarshipApp
//
//  Created by Thomas Ring on 4/28/13.
//  Copyright (c) 2013 Thomas Ring. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRTimelineViewController : UIViewController

- (void)timelineInteracted: (UIGestureRecognizer*)sender;
- (void)displayID: (int)ID;

@property (nonatomic, retain) IBOutlet UIView *timelineView;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, retain, readonly) NSDictionary* nodes;
@property (strong, retain) NSArray* dates;

@end
