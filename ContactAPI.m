//
//  ContactAPI.m
//  Task2
//
//  Created by Vladislav Posashkov on 22.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import "ContactAPI.h"
#import "HTTPClient.h"
#import "NetworkSettings.h"

@interface ContactAPI ()

@property(strong, nonatomic) HTTPClient *httpClient;
@property(strong, nonatomic) NSMutableArray *dataManager;
@property(strong, nonatomic) NetworkSettings *settings;

@end

@implementation ContactAPI

@synthesize httpClient = _httpClient;
@synthesize dataManager = _dataManager;
@synthesize settings = _settings;

- (instancetype)init {
  self = [super init];

  if (self) {
    _httpClient = [[HTTPClient alloc] init];
    _dataManager = [[NSMutableArray alloc] init];
    _settings =
        [[NetworkSettings alloc] initWithSettingsNative:NO synchronous:NO];
  }

  return self;
}

+ (ContactAPI *)sharedManager {
  static ContactAPI *manager = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[self alloc] init];
  });

  return manager;
}

- (void)setNetworkSetting:(NetworkSettings *)settings {
  if (settings) {
    _settings = settings;
    [_httpClient setSettings:settings];
  }
}

- (NetworkSettings *)networkSetting {
  return _settings;
}

#pragma mark -

- (void)loadContactListCompletionBlockWithSuccess:(void (^)())success
                                          failure:(void (^)())failure {
  [_httpClient loadContactListCompletionBlockWithSuccess:success
                                                 failure:failure];
}

- (void)creteContactWithFullName:(NSString *)fullName
                           email:(NSString *)email
      completionBlockWithSuccess:(void (^)())success
                         failure:(void (^)())failure {
  [_httpClient createContactWithFullName:fullName
                                   email:email
              completionBlockWithSuccess:success
                                 failure:failure];
}

- (void)updateContact:(Contact *)contact
    completionBlockWithSuccess:(void (^)())success
                       failure:(void (^)())failure {
  [_httpClient updateContact:contact
      completionBlockWithSuccess:success
                         failure:failure];
}

- (void)deleteContact:(Contact *)contact
    completionBlockWithSuccess:(void (^)())success
                       failure:(void (^)())failure {
  [_httpClient deleteContact:contact
      completionBlockWithSuccess:success
                         failure:failure];
  [_dataManager removeObject:contact];
}

- (NSMutableArray *)contactList {
  return _dataManager;
}

#pragma mark -

- (void)setContactList:(NSMutableArray *)contactList sender:(id)sender {
  if ([sender isKindOfClass:[HTTPClient class]]) {
    if (contactList) {
      _dataManager = contactList;
    }
  } else {
    NSLog(@"Access denied class is not a subclass of HTTPClient");
  }
}

@end
