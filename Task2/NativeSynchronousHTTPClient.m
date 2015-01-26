//
//  NativeSynchronousHTTPClient.m
//  Task2
//
//  Created by Vladislav Posashkov on 19.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import "NativeSynchronousHTTPClient.h"
#import "Contact.h"
#import "ContactAPI.h"
#import "JSONUtilities.h"

@interface NativeSynchronousHTTPClient()

- (BOOL)performRequest:(NSMutableURLRequest *)request data:(NSData **)data;

@end

@implementation NativeSynchronousHTTPClient

+ (NativeSynchronousHTTPClient *)sharedManager {
    static NativeSynchronousHTTPClient *nativeClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nativeClient = [[NativeSynchronousHTTPClient alloc] init];
    });
    
    return nativeClient;
}

#pragma mark - 

- (BOOL)performRequest:(NSMutableURLRequest *)request data:(NSData **)data {
    NSURLResponse *response = nil;
    NSError *error = nil;
    *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if ([httpResponse statusCode] >= 300 || error != nil) {
        NSLog(@"Error: %@, HTTP Status: %ld",[error localizedDescription],(long)[httpResponse statusCode]);
        return NO;
    }
    return YES;
}

#pragma mark - 

- (void)loadContactListCompletionBlockWithSuccess:(voidBlock) success failure:(voidBlock) failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSMutableURLRequest *request = [self requestWithURL:[self baseURL] HTTPMethod:@"GET" body:nil];
        NSData *data = nil;
        BOOL isSuccess = [self performRequest:request data:&data];
        if (data) {
            [[ContactAPI sharedManager] setContactList:[JSONUtilities contactListWithJSONData:data] sender:self];
        }
        if (isSuccess && success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success();
            });
        } else if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure();
            });
        }
    });
}

- (void)createContactWithFullName:(NSString *)fullName email:(NSString *)email completionBlockWithSuccess:(voidBlock)success failure:(voidBlock)failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSMutableURLRequest *request = [self requestWithURL:[self baseURL] HTTPMethod:@"POST" body:[JSONUtilities JSONDataWithFullName:fullName email:email]];
        NSLog(@"Req; %@",request);
        NSData *data = nil;
        BOOL isSuccess = [self performRequest:request data:&data];
        if (isSuccess && success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success();
            });
        } else if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure();
            });
        }
    });
}

- (void)updateContact:(Contact *)contact completionBlockWithSuccess:(voidBlock)success failure:(voidBlock)failure {
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSURL *url = [self prepareURLForRequestWithContactId:contact.contactId];
        NSData *data = nil;
        NSMutableURLRequest *request = [self requestWithURL:url HTTPMethod:@"PUT" body:[JSONUtilities JSONDataWithFullName:contact.fullName email:contact.email]];
        BOOL isSuccess = [self performRequest:request data:&data];
        if (isSuccess && success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success();
                });
        } else if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure();
                });
        }
    });
}

- (void)deleteContact:(Contact *)contact completionBlockWithSuccess:(voidBlock)success failure:(voidBlock)failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSURL *url = [self prepareURLForRequestWithContactId:[contact contactId]];
        NSData *data = nil;
        NSMutableURLRequest *request = [self requestWithURL:url HTTPMethod:@"DELETE" body:nil];
        BOOL isSuccess = [self performRequest:request data:&data];
        if (isSuccess && success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success();
            });
        } else if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure();
            });
        }
    });
}

@end
