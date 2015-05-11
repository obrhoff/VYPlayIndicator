//
//  VYTableViewCell.h
//  playindicator
//
//  Created by Dennis Oberhoff on 08/05/15.
//  Copyright (c) 2015 Dennis Oberhoff. All rights reserved.
//

@import UIKit;
#import "VYPlayIndicator.h"

@interface VYTableViewCell : UITableViewCell

@property (nonatomic, readonly, strong) VYPlayIndicator *playIndicator;

@end
