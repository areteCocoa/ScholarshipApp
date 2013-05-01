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

@property int currentID;

@property CGFloat nodeWidth;
@property NSDate *minimumDate;
@property NSDate *maximumDate;

@property BOOL isDoneAnimating;

@property NSArray *contentKeys;

@end

@implementation TRTimelineViewController

@synthesize timelineView = _timelineView, contentView = _contentView, dateView = _dateView, nodes = _nodes,
    nodeImageViews = _nodeImageViews, dateLabel = _dateLabel;
@synthesize topLabel, dates;

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
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timelineInteracted:)];
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    self.dateView.userInteractionEnabled = YES;
    [self.dateView addGestureRecognizer:dateRecognizer];
    
    self.timelineView.userInteractionEnabled = YES;
    [self.timelineView addGestureRecognizer:timelineRecognizer];
    [self.timelineView addGestureRecognizer:tapRecognizer];
    
    self.contentView.userInteractionEnabled = YES;
    [self.contentView addGestureRecognizer:swipeRightRecognizer];
    [self.contentView addGestureRecognizer:swipeLeftRecognizer];
    
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
        // NSDate *birthday = [formatter dateFromString:@"1996 01 30"];
        
        NSDate *logo = [formatter dateFromString:@"2007 05 16"];
        NSDate *C = [formatter dateFromString:@"2008 03 16"];
        NSDate *basic = [formatter dateFromString:@"2009 10 06"];
        
        NSDate *highSchool = [formatter dateFromString:@"2010 09 07"];
        
        NSDate *python = [formatter dateFromString:@"2011 06 18"];
        
        NSDate *EVDate1 = [formatter dateFromString:@"2012 07 26"];
        NSDate *EVDate2 = [formatter dateFromString:@"2013 03 02"];
        // Last commit 2013 03 02
        
        NSDate *comboWizard = [formatter dateFromString:@"2013 03 10"];
        
        NSDate *today = [formatter dateFromString:@"2013 04 30"];
        
        NSArray *unsortedDates = @[python, C, EVDate1, EVDate2, logo, basic, highSchool, comboWizard, today];
        dates = [self sortDateArray:unsortedDates];
        
        // Define content views
        // Do all this in .plist later
        self.contentKeys = [NSArray arrayWithObjects:@"topText", @"image", @"captionText", @"bottomText", nil];
        
        NSDictionary *logoDictionary = [self contentDictionary:@"At age 11 I was introduced to LOGO in my fifth grade class." :[UIImage imageNamed:@"logo.png"] :@"ACSLogo: The first programming software I used" :@"From the moment I laid eyes on it I knew it was something great."];
        
        NSDictionary *CDictionary = [self contentDictionary:@"At age 12, my dad gave me K&R's C book" :[UIImage imageNamed:@"c_book"] :@"Still one of my favorite books" :@"I found things I could barely understand, but they intrigued me."];
        
        NSDictionary *basicDictionary = [self contentDictionary:@"At age 13, my math teacher showed us TI-BASIC" :[UIImage imageNamed:@"calc.png"] :@"My TI-84 with all my old programs" :@"BASIC running on TI calculators drove me to spend the majority of classes programming."];
        
        NSDictionary *highSchoolDictionary = [self contentDictionary:@"My first day of high school" :[UIImage imageNamed:@"highschool.png"] :@"14 year old me walking out the door" :@""];
        
        NSDictionary *pythonDictionary = [self contentDictionary:@"At age 15 I learned Python." :[UIImage imageNamed:@"python.png"] :@"My first big CS book." :@"I picked up a python book and just started learning on an old iMac that I had installed Ubuntu on."];
        
        NSDictionary *evolutionDictionary = [self contentDictionary:@"At age 16 I entered our school's science fair" :[UIImage imageNamed:@"evolution.png"] :@"The finished program" :@"After learning Java, I decided to write a simulator for evolution, another of my academic interests."];
        
        NSDictionary *evolutionResultDictionary = [self contentDictionary:@"At the science fair, I got to present my project " :[UIImage imageNamed:@"medal.png"] :@"My third place medal" :@"as well as talk to other devs my age. A very worthwhile experience."];
        
        NSDictionary *comboDictionary = [self contentDictionary:@"After the science fair a partner and I entered" :[UIImage imageNamed:@"combo.png"] :@"One of my level designs in action" :@"Clay.io's Got Game? contest. We had to make our game strictly in HTML5 and Javascript."];
        
        NSDictionary *todayDictionary = [self contentDictionary:@"Today I'm 17 and I attend Reynolds High School." :[UIImage imageNamed:@"me.png"] :@"" :@"I'm looking forward to working with computers in the future and seeing how far I can actually go."];
        
        NSArray *content = @[logoDictionary, CDictionary, basicDictionary, highSchoolDictionary, pythonDictionary, evolutionDictionary, evolutionResultDictionary, comboDictionary, todayDictionary];
        
        self.nodes = [[NSDictionary alloc] initWithObjects:content forKeys:dates];
        
        double minimumDate = [[dates objectAtIndex:0] timeIntervalSince1970];
        double maximumDate = [[dates lastObject] timeIntervalSince1970];
        double dateIncrement;
        UIImage *node = [UIImage imageNamed:@"node.png"];
        double width = 300.0-node.size.width;
        
        for (NSDate *date in self.dates) {
            dateIncrement = ([date timeIntervalSince1970]-minimumDate)/(maximumDate-minimumDate);
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(dateIncrement*width, 20, node.size.width, node.size.height)];
            imageView.userInteractionEnabled = YES;
            imageView.layer.opacity = .7;
            imageView.image = node;
            imageView.contentMode = UIViewContentModeCenter;
            
            // [self.imageRecognizers addObject:imageRecognizer];
            [self.nodeImageViews addObject:imageView];
            [self.timelineView addSubview:imageView];
        }
    }
    return _nodes;
}

- (void)swipeRight:(UISwipeGestureRecognizer*)sender {
    if (self.currentID > 0) [self displayID:self.currentID-1];
}

- (void)swipeLeft:(UISwipeGestureRecognizer*)sender {
    if (self.currentID+1 < self.nodes.count) [self displayID:self.currentID+1];
}

// What ID should be displayed for the x location
- (int)IDForTapLocation: (CGPoint) tap {
    int closestID = 0;
    float distance = 320;
    for (UIImageView *imageView  in self.nodeImageViews) {
        if (abs(imageView.frame.origin.x-tap.x) < distance) {
            distance = abs(imageView.frame.origin.x-tap.x);
            closestID = [self.nodeImageViews indexOfObject:imageView];
        }
    }
    
    return closestID;
}

- (void)displayID: (int)ID {
    if (self.contentImageView.image == nil) {
        ID = 0;
    }
    
    if ((ID != self.currentID && [self.dateLabel.layer animationKeys].count <= 0) || self.contentImageView.image == nil) {
        // Change old node
        UIImageView *lastIndexImage = [self.nodeImageViews objectAtIndex:self.currentID];
        lastIndexImage.image = [UIImage imageNamed:@"node.png"];
        
        self.currentID = ID;
        
        // Move the dateLabel
        NSDate *indexedDate = [self.dates objectAtIndex:ID];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        
        // [self.dateLabel removeFromSuperview];
        
        UIImageView *indexedImage = ((UIImageView*)[self.nodeImageViews objectAtIndex:ID]);
        CGFloat x = indexedImage.frame.origin.x + (self.dateLabel.frame.size.width)/2;
        CGFloat width = self.nodeWidth;
        
        /*
        if (x > self.dateView.frame.size.width/2) {
            NSLog(@"Ahead of mid");
            x += indexedImage.frame.size.width/2;
        } else {
            NSLog(@"Behind mid");
            x -= indexedImage.frame.size.width/2;
        }
         */
        x += indexedImage.frame.size.width - width;
        
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
        if ([contentObject isKindOfClass:[NSDictionary class]]) {
            [self changeContentView:contentObject];
        } else {
            // Clear content with empty dictionary
            [self changeContentView:[NSDictionary dictionary]];
        }
        
        // Enlarge selected node
        indexedImage = [self.nodeImageViews objectAtIndex:ID];
        indexedImage.image = [UIImage imageNamed:@"node_big.png"];
        
        self.currentID = ID;
        
        [self.dateView setNeedsDisplay];
    }
}
                                                                            

- (void)changeContentView:(NSDictionary*)contentObject {
    self.topLabel.text = nil;
    self.contentImageView.image = nil;
    self.contentImageCaption.text = nil;
    self.bottomLabel.text = nil;
    
    NSString *topText = [contentObject valueForKey:@"topText"];
    UIImage *image = [contentObject valueForKey:@"image"];
    NSString *caption = [contentObject valueForKey:@"captionText"];
    NSString *bottomText = [contentObject valueForKey:@"bottomText"];
    
    if (topText) self.topLabel.text = topText;
    if (image) self.contentImageView.image = image;
    if (caption) self.contentImageCaption.text = caption;
    if (bottomText) self.bottomLabel.text = bottomText;
}

- (NSDictionary*)contentDictionary:(NSString*)topText :(UIImage*)image :(NSString*)caption :(NSString*)bottomText {
    NSArray *values = [NSArray arrayWithObjects:topText, image, caption, bottomText, nil];
    NSDictionary* contentDictionary = [[NSDictionary alloc] initWithObjects:values forKeys:self.contentKeys];
    return contentDictionary;
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
