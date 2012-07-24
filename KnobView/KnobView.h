//
//  KnobView.h
//  KnobView
//
//  Created by Richard Owens on 7/9/12.
//  Copyright (c) 2012 Richard J Owens. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KnobViewProtocol <NSObject>
- (void)knobDidChange:(id)knob toPercentage:(CGFloat)percentage;
@end

@interface KnobView : UIView

@property (unsafe_unretained) id<KnobViewProtocol> delegate;
@property (strong) UIColor* baseColor;

@property (assign) CGFloat percentage;
@property (assign) CGFloat stopAngle;
@property (assign) BOOL adjusting;
@end
