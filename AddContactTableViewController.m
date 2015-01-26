//
//  AddContactTableViewController.m
//  Task2
//
//  Created by Vladislav Posashkov on 24.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import "AddContactTableViewController.h"
#import "ContactAPI.h"
#import <JGProgressHUD/JGProgressHUD.h>

@interface AddContactTableViewController ()

@end

@implementation AddContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)saveButtonClicked:(id)sender {
    
    [[ContactAPI sharedManager] creteContactWithFullName:self.fullNameTextField.text email:self.emailTextField.text completionBlockWithSuccess:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadDataFromServer" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

@end
