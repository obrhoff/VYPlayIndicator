//
//  VYTableViewController.m
//  playindicator
//
//  Created by Dennis Oberhoff on 08/05/15.
//  Copyright (c) 2015 Dennis Oberhoff. All rights reserved.
//

#import "VYTableViewController.h"
#import "VYTableViewCell.h"

@implementation VYTableViewController

NSString * const cellIdentifier = @"cellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Track No %lu", (long)indexPath.row];
    return cell;
}

@end
