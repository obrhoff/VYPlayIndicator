//
//  VYTableViewCell.m
//  playindicator
//
//  Created by Dennis Oberhoff on 08/05/15.
//  Copyright (c) 2015 Dennis Oberhoff. All rights reserved.
//

#import "VYTableViewCell.h"
#import "VYPlayIndicator.h"

@interface VYTableViewCell()

@property (nonatomic, readwrite, strong) VYPlayIndicator *playIndicator;

@end

@implementation VYTableViewCell

- (void)awakeFromNib {
    self.accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    self.playIndicator = [VYPlayIndicator new];
    self.playIndicator.frame = self.accessoryView.bounds;
    self.playIndicator.opacity = 0.0;
    [self.accessoryView.layer addSublayer:self.playIndicator];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.playIndicator.opacity = selected;
    (selected) ? [self.playIndicator animatePlayback] : [self.playIndicator stopPlayback:animated];
}

-(void)prepareForReuse {
    [self.playIndicator reset];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self.playIndicator setOpacity:0.0];
    [CATransaction commit];
}

-(void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    self.playIndicator.frame = self.accessoryView.bounds;
}

@end
