//
//  TRTimelineViewController.m
//  ScholarshipApp
//
//  Created by Thomas Ring on 4/28/13.
//  Copyright (c) 2013 Thomas Ring. All rights reserved.
//

#import "TRTimelineViewController.h"

#define NAV_HEIGHT 55

@interface TRTimelineViewController ()

@property (nonatomic, retain) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, retain) UILabel *dateLabel;
@property CGFloat nodeWidth;
@property int currentID;

@end

@implementation TRTimelineViewController

@synthesize timelineView = _timelineView;
@synthesize contentView = _contentView;
@synthesize dateView = _dateView;
@synthesize progressBar;
@synthesize nodes = _nodes;

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
	
    // init dictionary to be displayed
    [self getNodes];
    
    // Init gesture recognizers for timeline and add to view
    self.panRecognizer =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(timelineInteracted:)];
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timelineInteracted:)];
    
    self.timelineView.userInteractionEnabled = YES;
    [self.timelineView addGestureRecognizer:self.panRecognizer];
    [self.timelineView addGestureRecognizer:self.tapRecognizer];
    
    [self displayID:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timelineInteracted:(UIGestureRecognizer*)sender {
    // Move to proper date
    float progress = [sender locationInView:self.timelineView].x/self.timelineView.frame.size.width;
    self.progressBar.progress = progress;
    [self displayID:[self IDForTapLocation:[sender locationInView:self.timelineView]]];
}

- (NSDictionary*)getNodes {
    if (!_nodes) {
        // Init default values
        NSLog(@"Timeline has no nodes!");
        
        NSArray *dates = @[[NSDate dateWithTimeIntervalSinceNow:0], [NSDate dateWithTimeIntervalSinceNow:500], [NSDate dateWithTimeIntervalSinceNow:1000]];
        
        NSArray *contentProgress = @[@0, @1, @2];
        
        self.nodes = [[NSDictionary alloc] initWithObjects:dates forKeys:contentProgress];
    }
    return _nodes;
}

- (void)setNodes:(NSDictionary *)nodes {
    _nodes = nodes;
    self.nodeWidth = self.view.frame.size.width/_nodes.count;
    
    /*
    CGFloat nodeHeight = NAV_HEIGHT;
    
    NSDate *indexedDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    
    for (int count = 0; count < self.nodes.count; count++) {
        UILabel *nodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.timelineView.frame.origin.x + ((float)count*self.nodeWidth), self.timelineView.frame.origin.y, self.nodeWidth, nodeHeight)];
        [self styleLabel:nodeLabel];
        
        indexedDate = [self.nodes.allValues objectAtIndex:count];
        NSString *dateText = [formatter stringFromDate:indexedDate];
        
        NSLog(@"%i: %@ AND %f", count, dateText, [indexedDate timeIntervalSinceNow]);
        
        nodeLabel.text = dateText;
        
        [self.timelineView addSubview:nodeLabel];
    }
    [self.timelineView setNeedsDisplay];
     
     */
}

- (int)IDForTapLocation: (CGPoint) tap {
    return tap.x/self.nodeWidth;
}

- (void)displayID: (int)ID {
    if (ID != self.currentID) {
        [self.dateLabel removeFromSuperview];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(ID*self.nodeWidth, 0, self.nodeWidth, self.dateView.frame.size.height)];
        self.dateLabel.text = @"Selected Date";
        [self styleLabel:self.dateLabel];
        
        if (![[self.dateView subviews] containsObject:self.dateLabel]) {
            [self.dateView addSubview:self.dateLabel];
        }
        [self.dateView setNeedsDisplay];
        self.currentID = ID;
    }
}

- (void)styleLabel: (UILabel*)label {
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

@end
