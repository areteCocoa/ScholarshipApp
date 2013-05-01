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
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, frame.size.width, frame.size.height-12)];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.9];
        self.dateLabel.layer.cornerRadius = 10;
        self.dateLabel.layer.masksToBounds = YES;
        self.dateLabel.font = [UIFont fontWithName:self.dateLabel.font.familyName size:16.0f];
        
        [self addSubview: self.dateLabel];
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:.5 alpha:0];
        
        self.dateLabel.backgroundColor = [self.backgroundColor colorWithAlphaComponent:.5];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetRGBFillColor(context, .5, .5, .5, .5);
    CGContextSetLineWidth(context, 5);
    
    CGPoint rightPoint = CGPointMake(self.dateLabel.frame.size.width-10, self.dateLabel.frame.size.height);
    CGPoint leftPoint =  CGPointMake(self.dateLabel.frame.size.width-30, self.dateLabel.frame.size.height);
    
    CGContextMoveToPoint(context, rightPoint.x, rightPoint.y);
    CGContextAddLineToPoint(context, leftPoint.x, leftPoint.y);
    CGContextAddLineToPoint(context, (rightPoint.x + leftPoint.x)/2, rightPoint.y + 8);
    CGContextAddLineToPoint(context, rightPoint.x, rightPoint.y);
    CGContextFillPath(context);
}
*/

- (NSString*)dateText {
    if (!_dateText) {
        _dateText = @"";
    }
    return _dateText;
}

- (void)setDateText:(NSString *)dateText {
    _dateText = dateText;
    self.dateLabel.text = dateText;
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.dateLabel setFrame:CGRectMake(0, 12, frame.size.width, frame.size.height-10)];
}

@end
