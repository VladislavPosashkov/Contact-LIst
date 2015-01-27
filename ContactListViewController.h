//
//  ContactListViewController.h
//  Task2
//
//  Created by Vladislav Posashkov on 26.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactListViewController : UIViewController

@property(weak, nonatomic) IBOutlet UITableView *tableView;

@property(weak, nonatomic)
    IBOutlet UISegmentedControl *networkSettingSegmentedControl;

@end
