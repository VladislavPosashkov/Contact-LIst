//
//  ContactListTableViewController.m
//  Task2
//
//  Created by Vladislav Posashkov on 20.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import "ContactListTableViewController.h"
#import "ContactDetailTableViewController.h"
#import "ContactAPI.h"
#import "Contact.h"

@interface ContactListTableViewController ()

@property (strong, nonatomic) NSMutableArray *contactList;

- (void)loadData;
- (void)refreshData;

@end

@implementation ContactListTableViewController

#pragma mark - UITableView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"ReloadDataFromServer" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_contactList) {
        [self loadData];
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow == nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReloadDataFromServer" object:nil];
    }
}

#pragma mark -

- (void)loadData {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"Loading";
    [HUD showInView:self.view];
    
    
    [[ContactAPI sharedManager] loadContactListCompletionBlockWithSuccess:^{
        _contactList = [[ContactAPI sharedManager] contactList];
        [self.tableView reloadData];
        [HUD dismissAnimated:YES];
    } failure:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data is not loaded try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [HUD dismissAnimated:YES];
    }];
}


- (void)refreshData {
    [[ContactAPI sharedManager] loadContactListCompletionBlockWithSuccess:^{
        _contactList = [[ContactAPI sharedManager] contactList];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^{
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Update error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [aler show];
        [self.refreshControl endRefreshing];
    }];
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowContactDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] performSelector:@selector(setContactDetail:) withObject:[_contactList objectAtIndex:indexPath.row]];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contactList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Contact *contact = [_contactList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = contact.fullName;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
        HUD.textLabel.text = @"Deleting";
        [HUD showInView:self.view animated:YES];
        [[ContactAPI sharedManager] deleteContact:[_contactList objectAtIndex:[indexPath row]]
                       completionBlockWithSuccess:^{
                           _contactList = [[ContactAPI sharedManager] contactList];
                           [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                           [HUD dismissAnimated:YES];
                       }
                                          failure:^{
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Delete failde, try agine" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                           [alert show];
                                              [HUD dismissAnimated:YES];
        }];
    }
}

@end
