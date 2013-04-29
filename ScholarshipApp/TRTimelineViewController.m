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
@property CGFloat nodeWidth;

@end

@implementation TRTimelineViewController

@synthesize timelineView = _timelineView;
@synthesize contentView = _contentView;
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
}

- (NSDictionary*)getNodes {
    if (!_nodes) {
        // Init default values
        NSLog(@"Timeline has no nodes!");
        
        NSArray *dates = @[[NSDate dateWithTimeIntervalSince1970:500], [NSDate dateWithTimeIntervalSince1970:1000], [NSDate dateWithTimeIntervalSince1970:1500]];
        
        NSArray *contentProgress = @[@0, @1, @2];
        
        self.nodes = [[NSDictionary alloc] initWithObjects:dates forKeys:contentProgress];
    }
    return _nodes;
}

- (void)setNodes:(NSDictionary *)nodes {
    _nodes = nodes;
    self.nodeWidth = self.view.frame.size.width/_nodes.count;
    CGFloat nodeHeight = NAV_HEIGHT;
    
    NSString *dateText;
    NSDate *indexedDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    for (int count = 0; count < self.nodes.count; count++) {
        UILabel *nodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.timelineView.frame.origin.x + ((float)count*self.nodeWidth), self.timelineView.frame.origin.y, self.nodeWidth, nodeHeight)];
        [self styleLabel:nodeLabel];
        
        indexedDate = [self.nodes.allValues objectAtIndex:count];
        dateText = [formatter stringFromDate:indexedDate];
        
        nodeLabel.text = dateText.copy;
        
        [self.timelineView addSubview:nodeLabel];
    }
    [self.timelineView setNeedsDisplay];
}

- (void)styleLabel: (UILabel*)label {
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

@end
