//
//  ContactAPI.h
//  Task2
//
//  Created by Vladislav Posashkov on 22.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Contact;

@interface ContactAPI : NSObject

+ (ContactAPI *)sharedManager;

- (NSMutableArray *)contactList;

- (void)loadContactListCompletionBlockWithSuccess:(void(^)()) success failure:(void(^)()) failure;

- (void)creteContactWithFullName:(NSString *)fullName email:(NSString *)email completionBlockWithSuccess:(void(^)())success failure:(void(^)())failure;

- (void)updateContact:(Contact *)contact completionBlockWithSuccess:(void(^)())success failure:(void(^)())failure;

- (void)deleteContact:(Contact *)contact completionBlockWithSuccess:(void(^)())success failure:(void(^)())failure;

- (void) setContactList:(NSMutableArray *)contactList sender:(id)sender;

@end
