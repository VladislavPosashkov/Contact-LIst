//
//  ContactListViewController,m
//  Task2
//
//  Created by Vladislav Posashkov on 26.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import "ContactListViewController.h"
#import "ContactDetailTableViewController.h"
#import "ContactAPI.h"
#import "Contact.h"
#import "NetworkSettings.h"
#import <JGProgressHUD.h>

@interface ContactListViewController ()

@property(strong, nonatomic) NSMutableArray *contactList;
@property(strong, nonatomic) UIRefreshControl *refreshControl;

- (void)loadData;
- (void)refreshData;
- (void)showAlert;

@end

@implementation ContactListViewController

@synthesize refreshControl = _refreshControl;

#pragma mark - UITableView Life Cycle

- (void)viewDidLoad {
  [super viewDidLoad];
  _refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self
                          action:@selector(refreshData)
                forControlEvents:UIControlEventValueChanged];
  [self.tableView addSubview:self.refreshControl];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(loadData)
                                               name:@"ReloadDataFromServer"
                                             object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (!_contactList) {
    [self loadData];
  }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
  if (newWindow == nil) {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"ReloadDataFromServer"
                                                  object:nil];
  }
}

#pragma mark -

- (void)loadData {
  JGProgressHUD *HUD =
      [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
  HUD.textLabel.text = @"Loading";
  [HUD showInView:self.tableView];

  [[ContactAPI sharedManager] loadContactListCompletionBlockWithSuccess:^{
    _contactList = [[ContactAPI sharedManager] contactList];
    [self.tableView reloadData];
    [HUD dismissAnimated:YES];
  } failure:^{
    [self showAlert];
    [HUD dismissAnimated:YES];
  }];
}

- (void)refreshData {
  [[ContactAPI sharedManager] loadContactListCompletionBlockWithSuccess:^{
    _contactList = [[ContactAPI sharedManager] contactList];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
  } failure:^{
    [self showAlert];
    [self.refreshControl endRefreshing];
  }];
}

- (void)showAlert {
  UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:@"Try again later"
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
  [aler show];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:@"ShowContactDetail"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [[segue destinationViewController]
        performSelector:@selector(setContactDetail:)
             withObject:[_contactList objectAtIndex:indexPath.row]];
  }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [_contactList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                      forIndexPath:indexPath];

  Contact *contact = [_contactList objectAtIndex:indexPath.row];

  cell.textLabel.text = contact.fullName;

  return cell;
}

- (BOOL)tableView:(UITableView *)tableView
    canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    JGProgressHUD *HUD =
        [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"Deleting";
    [HUD showInView:self.tableView animated:YES];
    [[ContactAPI sharedManager]
        deleteContact:[_contactList objectAtIndex:[indexPath row]]
        completionBlockWithSuccess:^{
          _contactList = [[ContactAPI sharedManager] contactList];
          [tableView deleteRowsAtIndexPaths:@[ indexPath ]
                           withRowAnimation:UITableViewRowAnimationFade];
          [HUD dismissAnimated:YES];
        }
        failure:^{
          [self showAlert];
          [HUD dismissAnimated:YES];
        }];
  }
}

- (IBAction)networkSettingsChanged:(id)sender {
  NetworkSettings *settings = [[NetworkSettings alloc] init];
  switch (self.networkSettingSegmentedControl.selectedSegmentIndex) {
  case 0: // AFNetworking
    [settings setSettingsNative:NO synchronous:NO];

    break;
  case 1: // Native Asynchronous
    [settings setSettingsNative:YES synchronous:NO];
    break;
  case 2: // Native Synchronous
    [settings setSettingsNative:YES synchronous:YES];
    break;
  default:
    break;
  }
  [[ContactAPI sharedManager] setNetworkSetting:settings];
}

@end
