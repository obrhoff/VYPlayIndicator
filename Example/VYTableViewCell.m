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
    [self.accessoryView.layer addSublayer:self.playIndicator];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    (selected) ? [self.playIndicator animatePlayback] : [self.playIndicator stopPlayback];
}

-(void)prepareForReuse {
    [self.playIndicator reset];
}

-(void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    self.playIndicator.frame = self.accessoryView.bounds;
}

@end
