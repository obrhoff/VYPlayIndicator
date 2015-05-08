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

-(void)animatePlayback;
-(void)stopPlayback:(BOOL)animated;
-(void)reset;

@end
