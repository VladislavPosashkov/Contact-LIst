//
//  AFNetworkingHTTPCLient.m
//  Task2
//
//  Created by Vladislav Posashkov on 21.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import "AFNetworkingHTTPCLient.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSONUtilities.h"
#import "ContactAPI.h"
#import "Contact.h"

@implementation AFNetworkingHTTPCLient

+ (AFNetworkingHTTPCLient *)sharedManager {
  static AFNetworkingHTTPCLient *nativeClient = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    nativeClient = [[AFNetworkingHTTPCLient alloc] init];
  });

  return nativeClient;
}

#pragma mark -

- (void)loadContactListCompletionBlockWithSuccess:(voidBlock)success
                                          failure:(voidBlock)failure {
  NSMutableURLRequest *request =
      [self requestWithURL:[self baseURL] HTTPMethod:@"GET" body:nil];
  AFHTTPRequestOperation *operation =
      [[AFHTTPRequestOperation alloc] initWithRequest:request];
  operation.responseSerializer = [AFJSONResponseSerializer serializer];
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,
                                             id responseObject) {
    NSMutableArray *contactList =
        [JSONUtilities contactListWithJSONObject:[(NSDictionary *)responseObject
                                                     valueForKey:@"objects"]];
    [[ContactAPI sharedManager] setContactList:contactList sender:self];
    if (success) {
      dispatch_async(dispatch_get_main_queue(), ^{
        success();
      });
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", [error localizedDescription]);
    if (failure) {
      failure();
    }
  }];

  [operation start];
}

- (void)createContactWithFullName:(NSString *)fullName
                            email:(NSString *)email
       completionBlockWithSuccess:(voidBlock)success
                          failure:(voidBlock)failure {
  NSMutableURLRequest *request = [self
      requestWithURL:[self baseURL]
          HTTPMethod:@"POST"
                body:[JSONUtilities JSONDataWithFullName:fullName email:email]];
  AFHTTPRequestOperation *operation =
      [[AFHTTPRequestOperation alloc] initWithRequest:request];
  operation.responseSerializer = [AFJSONResponseSerializer serializer];

  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,
                                             id responseObject) {
    if (success) {
      success();
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", [error localizedDescription]);
    if (failure) {
      failure();
    }
  }];

  [operation start];
}

- (void)updateContact:(Contact *)contact
    completionBlockWithSuccess:(voidBlock)success
                       failure:(voidBlock)failure {
  NSMutableURLRequest *request = [self
      requestWithURL:[self prepareURLForRequestWithContactId:contact.contactId]
          HTTPMethod:@"PUT"
                body:[JSONUtilities JSONDataWithFullName:contact.fullName
                                                   email:contact.email]];

  AFHTTPRequestOperation *operation =
      [[AFHTTPRequestOperation alloc] initWithRequest:request];
  operation.responseSerializer = [AFJSONResponseSerializer serializer];

  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,
                                             id responseObject) {
    if (success) {
      success();
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", [error localizedDescription]);
    if (failure) {
      failure();
    }
  }];

  [operation start];
}

- (void)deleteContact:(Contact *)contact
    completionBlockWithSuccess:(voidBlock)success
                       failure:(voidBlock)failure {
  NSMutableURLRequest *request = [self
      requestWithURL:[self prepareURLForRequestWithContactId:contact.contactId]
          HTTPMethod:@"DELETE"
                body:nil];

  AFHTTPRequestOperation *operation =
      [[AFHTTPRequestOperation alloc] initWithRequest:request];
  operation.responseSerializer = [AFHTTPResponseSerializer serializer];

  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,
                                             id responseObject) {
    if (success) {
      success();
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", [error localizedDescription]);
    if (failure) {
      failure();
    }
  }];

  [operation start];
}

@end
