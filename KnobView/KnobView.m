//
//  KnobView.m
//  KnobView
//
//  Created by Richard Owens on 7/9/12.
//  Copyright (c) 2012 Richard J Owens. All rights reserved.
//

#import "KnobView.h"


@interface KnobView ()
@property (strong) NSMutableArray* deltas;

@property (strong) UIColor* innerKnobFillColor;
@property (strong) UIColor* innerKnobStrokeColor;
@property (strong) UIColor* outerKnobFillColor;
@property (strong) UIColor* outerKnobStrokeColor;
@property (strong) UIColor* indicatorFillColor;
@property (strong) UIColor* indicatorBackgroundColor;
@property (assign) CGFloat angleAdjust;
@property (assign) CGPoint currentTouchPoint;

@end

@implementation KnobView

@synthesize delegate;
@synthesize percentage;
@synthesize stopAngle;
@synthesize angleAdjust;
@synthesize deltas;
@synthesize adjusting;
@synthesize innerKnobFillColor;
@synthesize innerKnobStrokeColor;
@synthesize outerKnobFillColor;
@synthesize outerKnobStrokeColor;
@synthesize indicatorFillColor;
@synthesize indicatorBackgroundColor;
@synthesize currentTouchPoint;
@synthesize baseColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
        self.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:216.0/255.0 alpha:1.0];        
        self.deltas = [[NSMutableArray alloc] init];
        self.adjusting = NO;
        
        self.stopAngle = 0.5;
        self.angleAdjust = self.stopAngle;
        
        self.innerKnobFillColor = [UIColor colorWithRed:203.0/255 green:204/255.0 blue:194.0/255 alpha:1.0];
        self.innerKnobStrokeColor = [UIColor colorWithRed:233.0/255 green:235/255.0 blue:223.0/255 alpha:1.0];
        self.outerKnobFillColor = [UIColor colorWithRed:166.0/255 green:166/255.0 blue:159.0/255 alpha:1.0];
        self.outerKnobStrokeColor = [UIColor colorWithRed:133.0/255 green:133/255.0 blue:127.0/255 alpha:1.0];
        self.indicatorFillColor = [UIColor colorWithRed:105.0/255 green:105/255.0 blue:100.0/255 alpha:1.0];
        self.indicatorBackgroundColor = [UIColor colorWithRed:255.0/255 green:255/255.0 blue:245.0/255 alpha:1.0];       
    }
    return self;
}

- (void)setBaseColor:(UIColor *)_baseColor {
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    
    self.baseColor = _baseColor;

    [baseColor getHue:&hue saturation:&saturation brightness:&brightness alpha:nil];
    
    self.innerKnobFillColor = [UIColor  colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
    self.innerKnobStrokeColor = [UIColor  colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
    self.outerKnobFillColor = [UIColor  colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
    self.outerKnobStrokeColor = [UIColor  colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
    self.indicatorFillColor = [UIColor  colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
    self.indicatorBackgroundColor = [UIColor  colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];           
}

- (UIColor*)getBaseColor {
    return self.baseColor;
}

- (CGFloat)toRadians:(CGFloat)degrees 
{
    return degrees/180 * M_PI;
}

- (CGFloat)dotFromArray:(NSArray*)ar1 andArray:(NSArray*)ar2 
{
    return ([[ar1 objectAtIndex:0] floatValue] * [[ar2 objectAtIndex:0] floatValue]) + ([[ar1 objectAtIndex:1] floatValue] * [[ar2 objectAtIndex:1] floatValue]);
}

- (NSArray*)crossFromArray:(NSArray*)ar1 andArray:(NSArray*)ar2 
{
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    [resultArray addObject:[NSNumber numberWithFloat:0.0]];
    [resultArray addObject:[NSNumber numberWithFloat:[[ar1 objectAtIndex:0] floatValue] * [[ar2 objectAtIndex:1] floatValue] + [[ar1 objectAtIndex:1] floatValue] * [[ar2 objectAtIndex:0] floatValue]]];
    return resultArray;
}

- (CGFloat)length:(NSArray*)v
{
    return sqrt([[v objectAtIndex:0] floatValue] * [[v objectAtIndex:0] floatValue] + [[v objectAtIndex:1] floatValue] * [[v objectAtIndex:1] floatValue]);    
}

- (CGFloat)angleBetweenVector:(NSArray*)v1 andVector:(NSArray*)v2 
{
    return atan([self length:[self crossFromArray:v1 andArray:v2]] / [self dotFromArray:v1 andArray:v2]);
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint centerPoint = CGPointMake(rect.size.width/2, rect.size.height/2);
    
    CGContextSetFillColorWithColor(context, self.indicatorBackgroundColor.CGColor);            
    CGContextSetStrokeColorWithColor(context, [self.indicatorFillColor colorWithAlphaComponent:0.3].CGColor);
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:centerPoint];
    [path addArcWithCenter:centerPoint radius:rect.size.width/2 - 1 startAngle:M_PI_2 - self.stopAngle endAngle:M_PI_2 + self.stopAngle clockwise:NO];        
    [path closePath];
    [path fill];
    [path stroke];
    
    CGContextSetFillColorWithColor(context, self.indicatorFillColor.CGColor);            
    path = [UIBezierPath bezierPath];
    [path moveToPoint:centerPoint];
    [path addArcWithCenter:centerPoint radius:rect.size.width/2 - 1 startAngle:M_PI_2 + self.angleAdjust endAngle:M_PI_2 + self.stopAngle clockwise:NO];       
    [path closePath];
    [path fill];
    
    CGContextSetShadowWithColor(context, CGSizeMake(0.0, 0.0), 0.0, UIColor.clearColor.CGColor);    
    CGContextSetStrokeColorWithColor(context, self.innerKnobStrokeColor.CGColor);
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);           
    CGFloat padding = rect.size.width/12;  
    if (padding < 8) {
        padding = 8.0;
    }
    CGRect rectangle = CGRectMake(padding, padding, rect.size.width - 2 * padding, rect.size.width - 2 * padding);
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextDrawPath(context, kCGPathFill);

    [self drawKnob:context inRect:rect];
    [self drawTick:context inRect:rect];

    CGFloat emptyCircleX = rect.size.width/2 - 0.16 * rect.size.width * sinf(M_PI_2 + self.stopAngle) - padding/2;
    
    CGFloat emptyCircleY = 0.90 * rect.size.height;
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context,  self.indicatorFillColor.CGColor);
    CGContextSetFillColorWithColor(context,  self.indicatorBackgroundColor.CGColor);
    CGContextAddEllipseInRect(context,  CGRectMake(emptyCircleX, emptyCircleY, padding/2, padding/2));
    CGContextDrawPath(context, kCGPathFillStroke);
   
    emptyCircleX = rect.size.width/2 + 0.16 * rect.size.width * sinf(M_PI_2 + self.stopAngle);
    emptyCircleY = 0.90 * rect.size.height;
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context,  self.indicatorFillColor.CGColor);
    CGContextSetFillColorWithColor(context,  self.indicatorFillColor.CGColor);
    CGContextAddEllipseInRect(context,  CGRectMake(emptyCircleX, emptyCircleY, padding/2, padding/2));
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawKnob:(CGContextRef)context inRect:(CGRect)rect {
    CGFloat dialPadding = 0.15 * rect.size.width;
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, self.outerKnobStrokeColor.CGColor);
    CGContextSetFillColorWithColor(context, self.outerKnobFillColor.CGColor);
    
    CGContextBeginPath(context);
    CGRect rectangle = CGRectMake(dialPadding, dialPadding, rect.size.width - 2 * dialPadding, rect.size.width - 2*dialPadding);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextSetStrokeColorWithColor(context, self.innerKnobStrokeColor.CGColor);
    CGContextSetFillColorWithColor(context, self.innerKnobFillColor.CGColor);
    rectangle = CGRectMake(dialPadding + 4, dialPadding + 4, rect.size.width - 2 * dialPadding - 8, rect.size.width - 2*dialPadding - 8);
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawTick:(CGContextRef)context inRect:(CGRect)rect {
    CGFloat startAngle = M_PI_2 + self.angleAdjust;
    
    CGFloat tickYStart = self.frame.size.height/2 + 0.28 * rect.size.width * sinf(startAngle);
    CGFloat tickXStart = self.frame.size.width/2 + 0.28 * rect.size.width * cosf(startAngle);

    CGFloat width = rect.size.width/28;
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context, self.outerKnobStrokeColor.CGColor);
    CGRect rectangle = CGRectMake(tickXStart, tickYStart, width, width);
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextDrawPath(context, kCGPathFill);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    self.currentTouchPoint = [[touches anyObject] locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    
    CGPoint p1 = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGPoint p2 = CGPointMake(self.currentTouchPoint.x, self.currentTouchPoint.y);
    CGPoint p3 = CGPointMake([[touches anyObject] locationInView:self].x, [[touches anyObject] locationInView:self].y);
    
    NSArray* v0 = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:10], nil];
    NSArray* v1 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:p2.x - p1.x], [NSNumber numberWithFloat:p2.y - p1.y], nil];
    NSArray* v2 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:p3.x - p1.x], [NSNumber numberWithFloat:p3.y - p1.y], nil];
    
    CGFloat delta = [self angleBetweenVector:v1 andVector:v0] - [self angleBetweenVector:v2 andVector:v0];
    
    if (delta > M_PI / 2) {
        delta = delta - M_PI; 
    }
    if (delta < -M_PI / 2) {
        delta = delta + M_PI; 
    }    
    
    if (p2.x < p1.x) {
        [self.deltas addObject:[NSNumber numberWithFloat:(-1 * delta)]];
    } else {
        [self.deltas addObject:[NSNumber numberWithFloat:delta]];
    }
    
    if (!self.adjusting) {
        self.adjusting = YES;
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self adjustKnob];
        });
    }
    
    self.currentTouchPoint = [[touches anyObject] locationInView:self];
    
}

- (void) adjustKnob 
{
    if ([self.deltas count] == 0) {
        self.adjusting = NO;
        [self.deltas removeAllObjects];
        return;
    }
    
    CGFloat sum = 0;
    for (NSNumber* delta in self.deltas) {
        sum += [delta floatValue];
    }
    
    self.angleAdjust += sum / [self.deltas count];
    
    if (self.angleAdjust < self.stopAngle) {
        self.angleAdjust = self.stopAngle;
    }
    
    if (self.angleAdjust > 2*M_PI - self.stopAngle) {
        self.angleAdjust = 2*M_PI - self.stopAngle;
    }
    
    self.percentage = 100 * ((self.angleAdjust - self.stopAngle) / (2*M_PI - 2*self.stopAngle));
    
    if ([self.deltas count] >= 1) {
        [self.deltas removeObjectAtIndex:0];
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self adjustKnob];
        });
    }
    [self.delegate knobDidChange:self toPercentage:self.percentage];

    NSLog(@"%f", self.angleAdjust);
    [self setNeedsDisplay];
}

@end
