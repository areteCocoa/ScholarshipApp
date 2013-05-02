//
//  TRDialogView.m
//  ScholarshipApp
//
//  Created by Thomas Ring on 4/29/13.
//  Copyright (c) 2013 Thomas Ring. All rights reserved.
//

#import "TRDialogView.h"
#import "QuartzCore/QuartzCore.h"

@interface TRDialogView ()

@property (nonatomic, retain) UILabel *dateLabel;
@property CGPoint focusPoint;

@end

@implementation TRDialogView

@synthesize dateText = _dateText;
@synthesize target;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /*
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-12)];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.9];
        self.dateLabel.layer.cornerRadius = 5;
        self.dateLabel.layer.masksToBounds = YES;
        self.dateLabel.font = [UIFont fontWithName:self.dateLabel.font.familyName size:16.0f];
         */
        
        // [self addSubview: self.dateLabel];
        
        self.backgroundColor = [UIColor colorWithWhite:.5 alpha:1];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { .8, .8, .8, 1,  // Start color
        .6, .6, .6, 1 }; // End color
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    CGPoint topCenter = CGPointMake(CGRectGetMidX(rect), 0.0f);
    CGPoint endCenter = CGPointMake(CGRectGetMidX(rect), rect.size.height);
    CGContextDrawLinearGradient(context, glossGradient, topCenter, endCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
    CGContextSetRGBFillColor(context, 1, 1, 1, .9);
    CGRect textRect = CGRectMake(0, CGRectGetMidY(rect)/2 - 2, rect.size.width, CGRectGetMidY(rect));
    [self.dateText drawInRect:textRect withFont:[UIFont fontWithName:@"Helvetica Neue" size:16.0] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
}

- (NSString*)dateText {
    if (!_dateText) {
        _dateText = @"";
    }
    return _dateText;
}

- (void)setDateText:(NSString *)dateText {
    _dateText = dateText;
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.dateLabel setFrame:CGRectMake(0, 12, frame.size.width, frame.size.height-10)];
}

@end
