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
    UIImage *timelineImage = [UIImage imageNamed:@"timeline.png"];
    [self.timelineView addSubview:[[UIImageView alloc] initWithImage:timelineImage]];
    
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
        [formatter setDateFormat:@"yyyy m dd"];
        
        NSString *birthDate = [NSString stringWithFormat:@"%d %d %d", 1996, 1, 30];
        NSDate *birthday = [formatter dateFromString:birthDate];
        
        NSArray *unsortedDates = @[[NSDate dateWithTimeIntervalSinceNow:0], birthday, [NSDate dateWithTimeIntervalSinceNow:500000000], [NSDate dateWithTimeIntervalSinceNow:2000000]];
        dates = [self sortDateArray:unsortedDates];
        
        NSArray *contentProgress = @[@"The day I was born", @"Today", @"Sometime in the future", @"Way in the future"];
        
        self.nodes = [[NSDictionary alloc] initWithObjects:contentProgress forKeys:dates];
        
        double minimumDate = [[dates objectAtIndex:0] timeIntervalSince1970];
        double maximumDate = [[dates lastObject] timeIntervalSince1970];
        double dateIncrement;
        double width = [[UIScreen mainScreen] bounds].size.width;
        UIImage *node = [UIImage imageNamed:@"node.png"];
        
        for (NSDate *date in self.dates) {
            dateIncrement = ([date timeIntervalSince1970]-minimumDate)/(maximumDate-minimumDate);
            
            UITapGestureRecognizer *imageRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(imageTapped:)];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(dateIncrement*width - (node.size.width/2), 20, node.size.width, node.size.height)];
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
    if (ID != self.currentID) {
        NSDate *indexedDate = [self.dates objectAtIndex:ID];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        
        [self.dateLabel removeFromSuperview];
        
        CGFloat x = ((UIImageView*)[self.nodeImageViews objectAtIndex:ID]).frame.origin.x;
        CGFloat width = self.nodeWidth;
        
        if (x > self.dateView.frame.size.width/2) {
            x -= width;
        }
        
        if (x < 10) {
            x = 10;
        } else if(x + width + 10 > self.dateView.frame.size.width) {
            x = self.dateView.frame.size.width - width - 10;
        }
        
        [self.dateLabel setFrame:CGRectMake(x, 0, self.nodeWidth, self.dateView.frame.size.height-15)];
        self.dateLabel.dateText = [formatter stringFromDate:indexedDate];
        
        if (![[self.dateView subviews] containsObject:self.dateLabel]) {
            [self.dateView addSubview:self.dateLabel];
        }
        [self.dateView setNeedsDisplay];
        
        contentLabel.text = [self.nodes objectForKey:indexedDate];
        
        UIImageView *lastIndexImage = [self.nodeImageViews objectAtIndex:self.currentID];
        // [lastIndexImage setFrame:CGRectMake(lastIndexImage.frame.origin.x, 20, lastIndexImage.frame.size.width, lastIndexImage.frame.size.height)];
        lastIndexImage.image = [UIImage imageNamed:@"node.png"];
        
        UIImageView *indexedImage = [self.nodeImageViews objectAtIndex:ID];
        //[indexedImage setFrame:CGRectMake(indexedImage.frame.origin.x, indexedImage.frame.origin.y-10, indexedImage.frame.size.width, indexedImage.frame.size.height)];
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
    self.nodeWidth = self.view.frame.size.width/_nodes.count;
}

- (TRDialogView*)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[TRDialogView alloc] initWithFrame:CGRectMake(0, 0, self.nodeWidth, 15)];
    }
    return _dateLabel;
}

@end