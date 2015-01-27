//
//  HTTPClient.h
//  Task2
//
//  Created by Vladislav Posashkov on 20.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^voidBlock)();

@class Contact;
@class NetworkSettings;

@interface HTTPClient : NSObject

@property(assign, nonatomic) BOOL isSynchronous;
@property(assign, nonatomic) BOOL isNative;

@property(strong, nonatomic) NetworkSettings *settings;

@property(strong, nonatomic) NSURL *baseURL;

- (NSURL *)prepareURLForRequestWithContactId:(NSNumber *)contactid;

- (NSMutableURLRequest *)requestWithURL:(NSURL *)url
                             HTTPMethod:(NSString *)HTTPMethod
                                   body:(NSData *)body;

- (void)loadContactListCompletionBlockWithSuccess:(void (^)())success
                                          failure:(void (^)())failure;

- (void)createContactWithFullName:(NSString *)fullName
                            email:(NSString *)email
       completionBlockWithSuccess:(void (^)())success
                          failure:(void (^)())failure;

- (void)updateContact:(Contact *)contact
    completionBlockWithSuccess:(void (^)())success
                       failure:(void (^)())failure;

- (void)deleteContact:(Contact *)contact
    completionBlockWithSuccess:(void (^)())success
                       failure:(void (^)())failure;

@end
