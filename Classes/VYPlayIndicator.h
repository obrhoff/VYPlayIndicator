//
//  VYPlayIndicator.h
//
//  Created by Dennis Oberhoff on 05/04/15.
//  Copyright (c) 2015 Dennis Oberhoff. All rights reserved.
//

@import QuartzCore;

#if TARGET_OS_OSX
@import AppKit;
#define VYColor NSColor
#else
@import UIKit;
#define VYColor UIColor
#endif

typedef NS_ENUM(NSUInteger, VYPlayState) {
    VYPlayStateStopped = 0,
    VYPlayStatePlaying = 1,
    VYPlayStatePaused = 2
};


@interface VYPlayIndicator : CALayer

@property (nonatomic, readwrite, strong) VYColor *color;
@property (nonatomic, readwrite, assign) VYPlayState state;
@property (nonatomic, readwrite, copy) dispatch_block_t completionBlock;

-(void)animatePlayback;
-(void)stopPlayback;
-(void)pausePlayback;
-(void)reset;

@end
