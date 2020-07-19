//
//  VYPlayIndicator.m
//
//  Created by Dennis Oberhoff on 05/04/15.
//  Copyright (c) 2015 Dennis Oberhoff. All rights reserved.
//

#import "VYPlayIndicator.h"

typedef NS_ENUM(NSUInteger, VYState) {
    VYStateMinimized = 0,
    VYStateMaximized = 1,
    VYStateRandomized = 2,
};

@interface VYPlayIndicator() <CAAnimationDelegate>

@property (nonatomic, readwrite, strong) CAShapeLayer *firstBeam;
@property (nonatomic, readwrite, strong) CAShapeLayer *secondBeam;
@property (nonatomic, readwrite, strong) CAShapeLayer *thirdBeam;

@end

@implementation VYPlayIndicator

NSString * const kPathKey = @"path";
NSString * const kOpacityKey = @"opacity";
NSString * const kFrameKey = @"keyFrame";

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
    
    self.color = [VYColor redColor];
    self.firstBeam.fillColor = self.color.CGColor;
    self.secondBeam.fillColor = self.color.CGColor;
    self.thirdBeam.fillColor = self.color.CGColor;
    
    self.thirdBeam.lineCap = kCALineJoinRound;
    
    self.firstBeam.opaque = YES;
    self.secondBeam.opaque = YES;
    self.thirdBeam.opaque = YES;

    self.opacity = 0.0;
    self.geometryFlipped = YES;
}

-(void)applyPath {
    CGRect bounds = CGPathGetPathBoundingBox([self pathForState:VYStateMaximized]);
    CGPathRef path = [self pathForState:VYStateMinimized];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.firstBeam.frame = bounds;
    self.secondBeam.frame = bounds;
    self.thirdBeam.frame = bounds;
    
    self.firstBeam.path = path;
    self.secondBeam.path = path;
    self.thirdBeam.path = path;
    
    self.secondBeam.position = (CGPoint) {CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)};
    self.thirdBeam.position = (CGPoint) {CGRectGetMaxX(self.bounds) - CGRectGetWidth(self.thirdBeam.bounds) / 2, CGRectGetMidY(self.bounds)};
    [CATransaction commit];
    
}

-(void)animatePlayback {
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:kOpacityKey];
    opacity.toValue = @(1.0);
    opacity.fromValue = [self.presentationLayer valueForKeyPath:opacity.keyPath];
    opacity.duration = 0.2;
    opacity.fillMode = kCAFillModeBoth;
    opacity.removedOnCompletion = NO;
    
    CAKeyframeAnimation *keyframe = [CAKeyframeAnimation animationWithKeyPath:kPathKey];
    keyframe.duration = 1.5;
    keyframe.beginTime = CACurrentMediaTime() + 0.2;
    keyframe.fillMode = kCAFillModeForwards;
    keyframe.removedOnCompletion = NO;
    keyframe.autoreverses = NO;
    keyframe.repeatCount = INFINITY;
    
    CAKeyframeAnimation *secondBeam = keyframe.copy;
    CAKeyframeAnimation *thirdBeam = keyframe.copy;
    
    NSUInteger count = 6;
    
    NSArray *firstPaths = [self randomPaths:count];
    NSArray *secondPaths = [self randomPaths:count];
    NSArray *thirdPaths = [self randomPaths:count];

    keyframe.values = firstPaths;
    secondBeam.values = secondPaths;
    thirdBeam.values = thirdPaths;

    keyframe.keyTimes = [self randomKeytimes:firstPaths.count];
    secondBeam.keyTimes = [self randomKeytimes:secondPaths.count];
    thirdBeam.keyTimes = [self randomKeytimes:thirdPaths.count];
    
    keyframe.timingFunctions = [self randomTimingFunctions:firstPaths.count];
    secondBeam.timingFunctions = [self randomTimingFunctions:secondPaths.count];
    thirdBeam.timingFunctions = [self randomTimingFunctions:thirdPaths.count];
    
    CABasicAnimation *begin = [CABasicAnimation animationWithKeyPath:kPathKey];
    begin.duration = 0.2;
    begin.fillMode = kCAFillModeRemoved;
    begin.removedOnCompletion = YES;
    
    CABasicAnimation *secondBegin = begin.copy;
    CABasicAnimation *thirdBegin = begin.copy;
    
    begin.fromValue = [self.firstBeam.presentationLayer valueForKeyPath:begin.keyPath];
    secondBegin.fromValue = [self.secondBeam.presentationLayer valueForKeyPath:secondBeam.keyPath];
    thirdBegin.fromValue = [self.thirdBeam.presentationLayer valueForKeyPath:thirdBegin.keyPath];
    
    begin.toValue = keyframe.values.firstObject;
    secondBegin.toValue = secondBeam.values.firstObject;
    thirdBegin.toValue = thirdBeam.values.firstObject;
    
    [self.firstBeam addAnimation:begin forKey:begin.keyPath];
    [self.firstBeam addAnimation:keyframe forKey:kFrameKey];
    [self.secondBeam addAnimation:secondBegin forKey:secondBegin.keyPath];
    [self.secondBeam addAnimation:secondBeam forKey:kFrameKey];
    [self.thirdBeam addAnimation:thirdBegin forKey:thirdBegin.keyPath];
    [self.thirdBeam addAnimation:thirdBeam forKey:kFrameKey];
    [self addAnimation:opacity forKey:opacity.keyPath];
    
}

-(void)pausePlayback {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:kPathKey];
    animation.toValue = (id) [self pathForState:VYStateMinimized];
    animation.duration = 0.2;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.removedOnCompletion = NO;
    
    for (CAShapeLayer *beam in @[self.firstBeam, self.secondBeam, self.thirdBeam]) {
        CABasicAnimation *step = animation.copy;
        step.fromValue = [beam.presentationLayer valueForKeyPath:step.keyPath];
        [beam removeAnimationForKey:kFrameKey];
        [beam addAnimation:step forKey:step.keyPath];
    }
    
}

-(void)stopPlayback {
    
    [self pausePlayback];
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:kOpacityKey];
    opacity.toValue = @(0.0);
    opacity.fromValue = [self.presentationLayer valueForKeyPath:opacity.keyPath];
    opacity.beginTime = CACurrentMediaTime() + 0.1;
    opacity.duration = 0.2;
    opacity.fillMode = kCAFillModeBoth;
    opacity.removedOnCompletion = NO;
    opacity.delegate = self;
    [self addAnimation:opacity forKey:opacity.keyPath];
    
}

-(void)reset {
    [self removeAllAnimations];
    for (CAShapeLayer *layer in @[self.firstBeam, self.secondBeam, self.thirdBeam]) {
        [self applyPath];
        [layer removeAllAnimations];
        layer.fillColor = self.color.CGColor;
    }
}

-(void)setState:(VYPlayState)state {
    switch (state) {
        case VYPlayStateStopped: {
            [self stopPlayback];
            break;
        }
        case VYPlayStatePlaying: {
            [self animatePlayback];
            break;
        }
        case VYPlayStatePaused: {
            [self pausePlayback];
            break;
        }
    }
}

-(VYPlayState)state {
    
    VYPlayState state;
    
    CABasicAnimation *opacity = (CABasicAnimation*) [self animationForKey:kOpacityKey];
    CAKeyframeAnimation *keyFrame = (CAKeyframeAnimation*) [self.firstBeam animationForKey:kFrameKey];
    if (keyFrame) {
        state = VYPlayStatePlaying;
    } else if ([opacity.toValue floatValue]) {
        state = VYPlayStatePaused;
    } else {
        state = VYPlayStateStopped;
    }
    
    return state;
}

#pragma mark Path

-(NSArray*)randomPaths:(NSUInteger)count {
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:count];
    while (count--) {
        [frames addObject: (id) [self pathForState:VYStateRandomized]];
    }
    [frames addObject:frames.firstObject];
    return frames.copy;
}

-(NSArray*)randomTimingFunctions:(NSUInteger)count {
    NSMutableArray *randomTimings = [NSMutableArray arrayWithCapacity:count];
    NSArray *timings = @[kCAMediaTimingFunctionLinear, kCAMediaTimingFunctionEaseInEaseOut, kCAMediaTimingFunctionEaseOut,kCAMediaTimingFunctionEaseIn];
    while (count--) {
        [randomTimings addObject:[CAMediaTimingFunction functionWithName:timings[arc4random() % timings.count]]];
    }
    return randomTimings.copy;
}

-(NSArray*)randomKeytimes:(NSUInteger)count {
    NSInteger timingsCount = count - 1;
    NSMutableArray *timings = [NSMutableArray arrayWithCapacity:timingsCount];
    for (int idx = 0; idx < timingsCount; idx++) {
        [timings addObject:@((CGFloat) idx / count)];
    }
    [timings addObject:@1.0];
    return timings.copy;
}

-(CGPathRef)pathForState:(VYState)state {
    CGFloat rectWidth = self.bounds.size.width * 0.25;
    CGFloat cornerRadius = self.indicatorStyle == VYPlayStyleLegacy ? 0.0 : rectWidth;
    CGFloat minimalHeight = self.indicatorStyle == VYPlayStyleLegacy ? 2 : cornerRadius;
    CGFloat rectHeight;
    
    switch (state) {
        case VYStateMinimized:
            rectHeight = minimalHeight;
            break;
        case VYStateMaximized:
            rectHeight = CGRectGetHeight(self.bounds);
            break;
        case VYStateRandomized:
            rectHeight = MAX(minimalHeight, ((CGFloat) rand() / RAND_MAX) * CGRectGetHeight(self.bounds));
            break;
    }

    CGRect rect = CGRectMake(0, 0, ceil(rectWidth), ceil(rectHeight));
    return CGPathCreateWithRoundedRect(rect, cornerRadius, cornerRadius, NULL);
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (!flag) return;
    if (self.completionBlock) self.completionBlock();
    self.completionBlock = nil;
}

-(VYColor *)color {
    return [VYColor colorWithCGColor:self.firstBeam.fillColor];
}

-(void)setColor:(VYColor *)color {
    self.firstBeam.fillColor = color.CGColor;
    self.secondBeam.fillColor = color.CGColor;
    self.thirdBeam.fillColor = color.CGColor;
}

-(void)layoutSublayers {
    [super layoutSublayers];
    [self applyPath];
}

@end
