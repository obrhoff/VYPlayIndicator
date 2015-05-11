//
//  VYPlayIndicator.h
//
//  Created by Dennis Oberhoff on 05/04/15.
//  Copyright (c) 2015 Dennis Oberhoff. All rights reserved.
//

@import UIKit;
@import QuartzCore;

@interface VYPlayIndicator : CALayer

@property (nonatomic, readwrite, strong) UIColor *color;
@property (nonatomic, readwrite, copy) dispatch_block_t completionBlock;

-(void)animatePlayback;
-(void)stopPlayback;
-(void)reset;

@end
