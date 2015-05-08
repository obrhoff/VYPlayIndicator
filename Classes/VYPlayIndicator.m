//
//  VYPlayIndicator.m
//
//  Created by Dennis Oberhoff on 05/04/15.
//  Copyright (c) 2015 Dennis Oberhoff. All rights reserved.
//

#import "VYPlayIndicator.h"

@interface VYPlayIndicator()

@property (nonatomic, readwrite, strong) CAShapeLayer *firstBeam;
@property (nonatomic, readwrite, strong) CAShapeLayer *secondBeam;
@property (nonatomic, readwrite, strong) CAShapeLayer *thirdBeam;

@end

@implementation VYPlayIndicator

@synthesize color = _color;

-(instancetype)init {
    self = [super init];
    if (self) {
        self.firstBeam = [CAShapeLayer new];
        self.secondBeam = [CAShapeLayer new];
        self.thirdBeam = [CAShapeLayer new];
        [self addSublayer:self.firstBeam];
        [self addSublayer:self.secondBeam];
        [self addSublayer:self.thirdBeam];
        [self applyStyle];
        [self applyPath];
    }
    return self;
}

-(void)applyStyle {
    
    self.color = [UIColor redColor];
    self.firstBeam.fillColor = self.color.CGColor;
    self.secondBeam.fillColor = self.color.CGColor;
    self.thirdBeam.fillColor = self.color.CGColor;
    
    self.firstBeam.opaque = YES;
    self.secondBeam.opaque = YES;
    self.thirdBeam.opaque = YES;

}

-(void)applyPath {

    CGRect bounds = [self pathWithPercentage:100].bounds;
    UIBezierPath *path = [self pathWithPercentage:5];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.firstBeam.frame = bounds;
    self.secondBeam.frame = bounds;
    self.thirdBeam.frame = bounds;
    
    self.firstBeam.path = path.CGPath;
    self.secondBeam.path = path.CGPath;
    self.thirdBeam.path = path.CGPath;
    
    self.secondBeam.position = (CGPoint) {CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)};
    self.thirdBeam.position = (CGPoint) {CGRectGetMaxX(self.bounds) - CGRectGetWidth(self.thirdBeam.bounds) / 2, CGRectGetMidY(self.bounds)};
    [CATransaction commit];
    
}

-(void)animatePlayback {
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.toValue = @(1.0);
    opacity.fromValue = [self.presentationLayer valueForKeyPath:opacity.keyPath];
    opacity.duration = 0.2;
    opacity.fillMode = kCAFillModeBoth;
    opacity.removedOnCompletion = NO;
    
    CAKeyframeAnimation *keyframe = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    keyframe.duration = 2.75;
    keyframe.fillMode = kCAFillModeBoth;
    keyframe.removedOnCompletion = NO;
    keyframe.autoreverses = YES;
    keyframe.repeatCount = INFINITY;
    
    CAKeyframeAnimation *secondBeam = keyframe.copy;
    CAKeyframeAnimation *thirdBeam = keyframe.copy;
    
    NSUInteger count = 10;
    
    keyframe.values = [self randomPaths:count];
    secondBeam.values = [self randomPaths:count];
    thirdBeam.values = [self randomPaths:count];

    keyframe.keyTimes = [self randomKeytimes:count];
    secondBeam.keyTimes = [self randomKeytimes:count];
    thirdBeam.keyTimes = [self randomKeytimes:count];
    
    keyframe.timingFunctions = [self randomTimingFunctions:count];
    secondBeam.timingFunctions = [self randomTimingFunctions:count];
    thirdBeam.timingFunctions = [self randomTimingFunctions:count];
    
    CABasicAnimation *begin = [CABasicAnimation animationWithKeyPath:@"path"];
    begin.duration = 0.5;
    begin.fillMode = kCAFillModeBoth;
    begin.removedOnCompletion = NO;
    begin.delegate = self;
    
    CABasicAnimation *secondBegin = begin.copy;
    CABasicAnimation *thirdBegin = begin.copy;

    begin.fromValue = [self.firstBeam.presentationLayer valueForKeyPath:begin.keyPath];
    secondBegin.fromValue = [self.secondBeam.presentationLayer valueForKeyPath:secondBeam.keyPath];
    thirdBegin.fromValue = [self.thirdBeam.presentationLayer valueForKeyPath:thirdBegin.keyPath];

    begin.toValue = keyframe.values.firstObject;
    secondBegin.toValue = secondBeam.values.firstObject;
    thirdBegin.toValue = thirdBeam.values.firstObject;
    
    [begin setValue:keyframe forKey:@"keyFrame1"];
    [secondBegin setValue:secondBeam forKey:@"keyFrame2"];
    [thirdBegin setValue:thirdBeam forKey:@"keyFrame3"];

    [self.firstBeam addAnimation:begin forKey:begin.keyPath];
    [self.secondBeam addAnimation:secondBegin forKey:secondBegin.keyPath];
    [self.thirdBeam addAnimation:thirdBegin forKey:thirdBegin.keyPath];
    [self addAnimation:opacity forKey:opacity.keyPath];
    
}

-(void)stopPlayback:(BOOL)animated {
    
    UIBezierPath *path = [self pathWithPercentage:5];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.toValue = (id) path.CGPath;
    animation.duration = 0.2;
    animation.fillMode = kCAFillModeBoth;
    animation.removedOnCompletion = NO;

    for (CAShapeLayer *beam in @[self.firstBeam, self.secondBeam, self.thirdBeam]) {
        CABasicAnimation *step = animation.copy;
        step.fromValue = [beam.presentationLayer valueForKeyPath:step.keyPath];
        if (!animated) {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [beam addAnimation:step forKey:step.keyPath];
            [CATransaction commit];
        } else {
            [beam addAnimation:step forKey:step.keyPath];
        }
    }
    
}

-(void)reset {
    [self.firstBeam removeAllAnimations];
    [self.secondBeam removeAllAnimations];
    [self.thirdBeam removeAllAnimations];
    [self removeAllAnimations];
    self.firstBeam.fillColor = self.color.CGColor;
    self.secondBeam.fillColor = self.color.CGColor;
    self.thirdBeam.fillColor = self.color.CGColor;
}

-(NSArray*)randomPaths:(NSUInteger)count {
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:count];
    while (count--) [frames addObject: (id) [self pathWithPercentage:(CGFloat) rand() / RAND_MAX * 100].CGPath];
    return frames.copy;
}

-(NSArray*)randomTimingFunctions:(NSUInteger)count {
    NSMutableArray *randomTimings = [NSMutableArray arrayWithCapacity:count];
    NSArray *timings = @[kCAMediaTimingFunctionLinear, kCAMediaTimingFunctionEaseInEaseOut, kCAMediaTimingFunctionEaseOut,kCAMediaTimingFunctionEaseIn];
    while (count--) [randomTimings addObject:[CAMediaTimingFunction functionWithName:timings[arc4random() % timings.count]]];
    return randomTimings.copy;
}

-(NSArray*)randomKeytimes:(NSUInteger)count {
    NSMutableArray *timings = [NSMutableArray arrayWithCapacity:count];
    for (int idx = 0; idx < count; idx++) [timings addObject:@((CGFloat) idx / count)];
    return timings.copy;
}

-(UIBezierPath*)pathWithPercentage:(CGFloat)percentageFactor {
    
    CGFloat originY = CGRectGetHeight(self.bounds) - (CGRectGetHeight(self.bounds) * (percentageFactor / 100.0 ));
    CGFloat originX = CGRectGetMaxX(self.bounds) * 0.25;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(originX, CGRectGetMaxY(self.bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(self.bounds), originY)];
    [path addLineToPoint:CGPointMake(originX, originY)];
    [path closePath];
    return path;
}

-(void)setColor:(UIColor *)color {
    _color = color;
    self.firstBeam.fillColor = color.CGColor;
    self.secondBeam.fillColor = color.CGColor;
    self.thirdBeam.fillColor = color.CGColor;
}

-(void)setPosition:(CGPoint)position {
    [super setPosition:position];
    if (CGPointEqualToPoint(position, CGPointZero)) position = CGPointMake(27.5, 19.5);
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (!flag) return;
    if ([anim valueForKey:@"keyFrame1"]) {
        CAKeyframeAnimation *keyFrame = [anim valueForKey:@"keyFrame1"];
        [self.firstBeam addAnimation:keyFrame forKey:keyFrame.keyPath];
    }
    if ([anim valueForKey:@"keyFrame2"]) {
        CAKeyframeAnimation *keyFrame = [anim valueForKey:@"keyFrame2"];
        [self.secondBeam addAnimation:keyFrame forKey:keyFrame.keyPath];
    }
    if ([anim valueForKey:@"keyFrame3"]) {
        CAKeyframeAnimation *keyFrame = [anim valueForKey:@"keyFrame3"];
        [self.thirdBeam addAnimation:keyFrame forKey:keyFrame.keyPath];
    }
    
}

-(void)layoutSublayers {
    [super layoutSublayers];
    [self applyPath];
}

@end
