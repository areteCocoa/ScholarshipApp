//
//  TRTimelineViewController.m
//  ScholarshipApp
//
//  Created by Thomas Ring on 4/28/13.
//  Copyright (c) 2013 Thomas Ring. All rights reserved.
//

#import "TRTimelineViewController.h"
#import "TRDialogView.h"
#import "QuartzCore/QuartzCore.h"

#define NAV_HEIGHT 55

@interface TRTimelineViewController ()

@property (nonatomic, retain) TRDialogView *dateLabel;

@property (nonatomic, retain) NSMutableArray *nodeImageViews;
@property (nonatomic, retain) NSMutableArray *imageRecognizers;

@property int currentID;

@property CGFloat nodeWidth;
@property NSDate *minimumDate;
@property NSDate *maximumDate;

@property BOOL isDoneAnimating;

@end

@implementation TRTimelineViewController

@synthesize timelineView = _timelineView, contentView = _contentView, dateView = _dateView, nodes = _nodes,
    nodeImageViews = _nodeImageViews, imageRecognizers = _imageRecognizers, dateLabel = _dateLabel;
@synthesize contentLabel, dates;

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
	
    // Add timeline image to timeline view
    UIImageView *timelineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline.png"]];
    timelineImageView.layer.opacity = .3;
    [self.timelineView addSubview:timelineImageView];
    
    // init dictionary to be displayed
    [self getNodes];
    
    // Init gesture recognizers for timeline and add to view
    UIPanGestureRecognizer *dateRecognizer =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(timelineInteracted:)];
    UIPanGestureRecognizer *timelineRecognizer =[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(timelineInteracted:)];
    self.dateView.userInteractionEnabled = YES;
    [self.dateView addGestureRecognizer:dateRecognizer];
    
    self.timelineView.userInteractionEnabled = YES;
    [self.timelineView addGestureRecognizer:timelineRecognizer];
    
    [NSTimer timerWithTimeInterval:1 target:self selector:@selector(displayID:) userInfo:self repeats:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timelineInteracted:(UIGestureRecognizer*)sender {
    // Move to proper date
    [self displayID:[self IDForTapLocation:[sender locationInView:[sender view]]]];
}

- (NSDictionary*)getNodes {
    if (!_nodes) {
        // Init default values
        NSLog(@"Timeline has no nodes!");
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy MM dd"];
        
        // Some constants
        // NSString *birthDate = [NSString stringWithFormat:@"%d %d %d", 1996, 1, 30];
        // NSDate *birthday = [formatter dateFromString:birthDate];
        
        NSDate *EVDate1 = [formatter dateFromString:@"2012 07 26"];
        NSDate *EVDate2 = [formatter dateFromString:@"2012 08 12"];
        NSDate *EVDate3 = [formatter dateFromString:@"2013 02 23"];
        NSDate *EVDate4 = [formatter dateFromString:@"2013 03 02"];
        
        NSArray *unsortedDates = @[[NSDate dateWithTimeIntervalSinceNow:0], EVDate1, EVDate2, EVDate3, EVDate4, [NSDate dateWithTimeIntervalSinceNow:60*60*24*5]];
        dates = [self sortDateArray:unsortedDates];
        
        NSArray *contentProgress = @[@"Started Evolution Simulator", @"First 'working' build", @"Days before due date", @"Due date, final product", @"Today", [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline.png"]]];
        
        self.nodes = [[NSDictionary alloc] initWithObjects:contentProgress forKeys:dates];
        
        double minimumDate = [[dates objectAtIndex:0] timeIntervalSince1970];
        double maximumDate = [[dates lastObject] timeIntervalSince1970];
        double dateIncrement;
        // double width = [[UIScreen mainScreen] bounds].size.width
        UIImage *node = [UIImage imageNamed:@"node.png"];
        double width = 300.0-node.size.width;
        
        for (NSDate *date in self.dates) {
            dateIncrement = ([date timeIntervalSince1970]-minimumDate)/(maximumDate-minimumDate);
            
            UITapGestureRecognizer *imageRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(imageTapped:)];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(dateIncrement*width, 20, node.size.width, node.size.height)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:imageRecognizer];
            imageView.image = node;
            imageView.contentMode = UIViewContentModeCenter;
            
            [self.imageRecognizers addObject:imageRecognizer];
            [self.nodeImageViews addObject:imageView];
            [self.timelineView addSubview:imageView];
        }
    }
    return _nodes;
}

- (void)imageTapped:(UIGestureRecognizer*)sender {
    [self displayID:[self.imageRecognizers indexOfObject:sender]];
}

- (int)IDForTapLocation: (CGPoint) tap {
    return tap.x/self.nodeWidth;
}

- (void)displayID: (int)ID {
    if (ID != self.currentID && [self.dateLabel.layer animationKeys].count <= 0) {
        // Move the dateLabel
        NSDate *indexedDate = [self.dates objectAtIndex:ID];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        
        // [self.dateLabel removeFromSuperview];
        
        UIImageView *indexedImage = ((UIImageView*)[self.nodeImageViews objectAtIndex:ID]);
        CGFloat x = indexedImage.frame.origin.x + (self.dateLabel.frame.size.width)/2;
        CGFloat width = self.nodeWidth;
        
        x -= width;
        if (x > self.dateView.frame.size.width/2) {
            x += indexedImage.frame.size.width/2;
        } else {
            x -= indexedImage.frame.size.width/2;
        }
        
        if (x < 10) {
            x = 10;
        } else if(x + width + 10 > self.dateView.frame.size.width) {
            x = self.dateView.frame.size.width - width - 10;
        }
        
        
        self.dateLabel.dateText = [formatter stringFromDate:indexedDate];
        
        if (![[self.dateView subviews] containsObject:self.dateLabel]) {
            [self.dateView addSubview:self.dateLabel];
            [self.dateLabel setFrame:CGRectMake(x, 0, self.nodeWidth, self.dateView.frame.size.height-15)];
            [self.dateView setNeedsDisplay];
            self.isDoneAnimating = YES;
        } else if(self.isDoneAnimating){
            self.isDoneAnimating = NO;
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [self.dateLabel setFrame:CGRectMake(x, 0, self.nodeWidth, self.dateView.frame.size.height-15)];
            }completion:^(BOOL finished) {
                self.isDoneAnimating = YES;
            }];
        } else {
            
        }
        
        // Change the content
        id contentObject = [self.nodes objectForKey:indexedDate];
        for (UIView *view in [self.contentView subviews]) {
            [view removeFromSuperview];
        }
        if ([contentObject isKindOfClass:[NSString class]]) {
            contentLabel.text = [self.nodes objectForKey:indexedDate];
            [self.contentView addSubview:self.contentLabel];
        } else if([contentObject isKindOfClass:[UIView class]]) {
            [self.contentView addSubview:contentObject];
        }
        
        
        
        // Edit the timeline to show selected node
        UIImageView *lastIndexImage = [self.nodeImageViews objectAtIndex:self.currentID];
        lastIndexImage.image = [UIImage imageNamed:@"node.png"];
        
        indexedImage = [self.nodeImageViews objectAtIndex:ID];
        indexedImage.image = [UIImage imageNamed:@"node_big.png"];
        
        self.currentID = ID;
        
        [self.dateView setNeedsDisplay];
    }
}

- (NSArray*)sortDateArray: (NSArray*) unsortedDates {
    NSArray *newDates = [unsortedDates sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate* first = obj1;
        NSDate* second = obj2;
        
        return [first compare:second];
    }];
    
    return newDates;
}

- (NSMutableArray*)nodeImageViews {
    if (!_nodeImageViews) {
        _nodeImageViews = [[NSMutableArray alloc] init];
    }
    return _nodeImageViews;
}

- (NSMutableArray*)imageRecognizers {
    if (!_imageRecognizers) {
        _imageRecognizers = [[NSMutableArray alloc] init];
    }
    return _imageRecognizers;
}

- (void)setNodes:(NSDictionary *)nodes {
    _nodes = nodes;
    self.nodeWidth = self.view.frame.size.width/4;
}

- (TRDialogView*)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[TRDialogView alloc] initWithFrame:CGRectMake(0, 0, self.nodeWidth, 15)];
    }
    return _dateLabel;
}

@end
