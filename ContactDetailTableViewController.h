//
//  ContactDetailTableViewController.h
//  Task2
//
//  Created by Vladislav Posashkov on 24.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contact;

@interface ContactDetailTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *resourceURLLabel;

@property (strong, nonatomic) Contact *contactDetail;

@end
