//
//  ContactDetailTableViewController.m
//  Task2
//
//  Created by Vladislav Posashkov on 24.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import "ContactDetailTableViewController.h"
#import "ContactAPI.h"
#import "Contact.h"
#import <JGProgressHUD/JGProgressHUD.h>

@interface ContactDetailTableViewController ()

- (void)checkTextField;
- (void)configureView;
- (void)showAlertWithText:(NSString *)text;

@end

@implementation ContactDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    self.tableView.allowsSelection = NO;
}

- (void)setContactDetail:(Contact *)contactDetail {
    if (self.contactDetail != contactDetail) {
        _contactDetail = contactDetail;
    }
}

- (void)configureView {
    if (self.contactDetail) {
        self.fullNameTextField.text = self.contactDetail.fullName;
        self.emailTextField.text = self.contactDetail.email;
        self.createdDateLabel.text = [self.contactDetail.createdDate description];
        self.updatedDateLabel.text = [self.contactDetail.updatedDate description];
        self.resourceURLLabel.text = self.contactDetail.resourceURL;
    }
}

- (void)checkTextField {
    if ([self.fullNameTextField.text length] == 0) {
        [self showAlertWithText:@"Full name can't be empty"];
    } else if ([self.emailTextField.text length] == 0) {
        [self showAlertWithText:@"Email can't be empty"];
    }
}

- (void)showAlertWithText:(NSString *)text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:text delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)saveButtonClicked:(id)sender {
    [self checkTextField];
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"Saving";
    [HUD showInView:self.view animated:YES];
    
    Contact *copy = self.contactDetail.copy;
    copy.fullName = self.fullNameTextField.text;
    copy.email = self.emailTextField.text;
    
    [[ContactAPI sharedManager] updateContact:copy completionBlockWithSuccess:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadDataFromServer" object:nil];
        [HUD dismissAnimated:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^{
        [HUD dismissAnimated:NO];
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Try agine" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [aler show];
    }];
}

@end
