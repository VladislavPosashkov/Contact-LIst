//
//  HTTPClient.m
//  Task2
//
//  Created by Vladislav Posashkov on 20.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import "HTTPClient.h"
#import "NativeAsynchronousHTTPClient.h"
#import "NativeSynchronousHTTPClient.h"
#import "AFNetworkingHTTPCLient.h"

typedef void(^voidBlock)();

@implementation HTTPClient

static NSString *kAPIkey = @"d41b921e94d21892720ce5634e0c7f1534eec04e";
static NSString *kAPIBaseURL = @"http://demo.resthooks.org/api/v1/contacts/";

- (instancetype)init {
    self = [super init];
    if (self) {
        _isNative = NO;
        _isSynchronous = NO;
        _baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?api_key=%@",kAPIBaseURL,kAPIkey]];
    }
    return self;
}

- (NSURL *)prepareURLForRequestWithContactId:(NSNumber *)contactId {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/?api_key=%@",kAPIBaseURL,contactId,kAPIkey]];
}

- (NSMutableURLRequest *)requestWithURL:(NSURL *)url HTTPMethod:(NSString *)HTTPMethod body:(NSData *)body {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:HTTPMethod];
    
    if ([HTTPMethod isEqualToString:@"POST"] || [HTTPMethod isEqualToString:@"PUT"]) {
        [request setHTTPBody:body];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    return request;
}
#pragma mark - Factory methods

- (void)loadContactListCompletionBlockWithSuccess:(voidBlock)success failure:(voidBlock)failure {
    if (self.isNative) {
        if (self.isSynchronous) {
            NSLog(@"Load Native Synchronos");
            [[NativeSynchronousHTTPClient sharedManager] loadContactListCompletionBlockWithSuccess:success failure:failure];
        } else {
            NSLog(@"Load Native Asynchronous");
            [[NativeAsynchronousHTTPClient sharedManager] loadContactListCompletionBlockWithSuccess:success failure:failure];
        }
    } else {
            NSLog(@"Load AFNetworking");
            [[AFNetworkingHTTPCLient sharedManager] loadContactListCompletionBlockWithSuccess:success failure:failure];
    }
}

- (void)createContactWithFullName:(NSString *)fullName email:(NSString *)email completionBlockWithSuccess:(voidBlock)success failure:(voidBlock)failure {
    if (self.isNative) {
        if (self.isSynchronous) {
            [[NativeSynchronousHTTPClient sharedManager] createContactWithFullName:fullName email:email completionBlockWithSuccess:success failure:failure];
        } else {
            [[NativeAsynchronousHTTPClient sharedManager] createContactWithFullName:fullName email:email completionBlockWithSuccess:success failure:failure];
        }
    } else {
        [[AFNetworkingHTTPCLient sharedManager] createContactWithFullName:fullName email:email completionBlockWithSuccess:success failure:failure];
    }
}

- (void)updateContact:(Contact *)contact completionBlockWithSuccess:(voidBlock)success failure:(voidBlock)failure {
    if (self.isNative) {
        if (self.isSynchronous) {
            [[NativeSynchronousHTTPClient sharedManager] updateContact:contact completionBlockWithSuccess:success failure:failure];
        } else {
            [[NativeAsynchronousHTTPClient sharedManager] updateContact:contact completionBlockWithSuccess:success failure:failure];
        }
    } else {
        [[AFNetworkingHTTPCLient sharedManager] updateContact:contact completionBlockWithSuccess:success failure:failure];
    }
}

- (void)deleteContact:(Contact *)contact completionBlockWithSuccess:(voidBlock)success failure:(voidBlock)failure {
    if (self.isNative) {
        if (self.isSynchronous) {
            [[NativeSynchronousHTTPClient sharedManager] deleteContact:contact completionBlockWithSuccess:success failure:failure];
        } else {
            [[NativeAsynchronousHTTPClient sharedManager] deleteContact:contact completionBlockWithSuccess:success failure:failure];
        }
    } else {
        [[AFNetworkingHTTPCLient sharedManager] deleteContact:contact completionBlockWithSuccess:success failure:failure];
    }
}

@end
