//
//  NativeAsynchronousHTTPClient.m
//  Task2
//
//  Created by Vladislav Posashkov on 19.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import "NativeAsynchronousHTTPClient.h"
#import "Contact.h"
#import "ContactAPI.h"
#import "JSONUtilities.h"

@implementation NativeAsynchronousHTTPClient

+ (NativeAsynchronousHTTPClient *)sharedManager {
    static NativeAsynchronousHTTPClient *nativeClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nativeClient = [[NativeAsynchronousHTTPClient alloc] init];
    });
    
    return nativeClient;
}

#pragma mark -

- (void)loadContactListCompletionBlockWithSuccess:(voidBlock) success failure:(voidBlock) failure {
    NSMutableURLRequest *request = [self requestWithURL:[self baseURL] HTTPMethod:@"GET" body:nil];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
                               NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                               if (statusCode < 300 && connectionError == nil){
                                   [[ContactAPI sharedManager] setContactList:[JSONUtilities contactListWithJSONData:data] sender:self];
                                   if (success) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           success();
                                       });
                                   }
                               } else if (statusCode >= 300 || connectionError != nil){
                                   NSLog(@"Error: %@, HTTP Status: %ld",[connectionError localizedDescription],(long)statusCode);
                                   if (failure) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           failure();
                                       });
                                   }
                               }
                           }];
}

- (void)createContactWithFullName:(NSString *)fullName email:(NSString *)email completionBlockWithSuccess:(voidBlock)success failure:(voidBlock)failure {
    NSMutableURLRequest *request = [self requestWithURL:self.baseURL
                                             HTTPMethod:@"POST"
                                                   body:[JSONUtilities JSONDataWithFullName:fullName email:email]];
    
     NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                               if (statusCode < 300 && connectionError == nil) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       success();
                                   });
                               } else if (statusCode >= 300 || connectionError != nil){
                                   NSLog(@"Error: %@, HTTP Status: %ld",[connectionError localizedDescription],(long)statusCode);
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       failure();
                                   });
                               }
                           }];
}

- (void)updateContact:(Contact *)contact completionBlockWithSuccess:(voidBlock)success failure:(voidBlock)failure {
    NSMutableURLRequest *request = [self requestWithURL:[self prepareURLForRequestWithContactId:contact.contactId]
                                             HTTPMethod:@"PUT"
                                                   body:[JSONUtilities JSONDataWithFullName:contact.fullName email:contact.email]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                               if (statusCode < 300 && connectionError == nil) {
                                   if (success) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           success();
                                       });
                                   }
                               } else if (statusCode >= 300 || connectionError != nil) {
                                   NSLog(@"Error: %@, HTTP Status: %ld",[connectionError localizedDescription],(long)statusCode);
                                   if (failure) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           failure();
                                       });
                                   }
                               }
                           }];
}

- (void)deleteContact:(Contact *)contact completionBlockWithSuccess:(voidBlock)success failure:(voidBlock)failure {
    NSMutableURLRequest *request = [self requestWithURL:[self prepareURLForRequestWithContactId:contact.contactId]
                                             HTTPMethod:@"DELETE"
                                                   body:nil];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                               if (statusCode < 300 && connectionError == nil) {
                                   if (success) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           success();
                                       });
                                   }
                               } else if (statusCode >= 300 || connectionError != nil) {
                                   NSLog(@"Error: %@, HTTP Status: %ld",[connectionError localizedDescription],(long)statusCode);
                                   if (failure) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           failure();
                                       });
                                   }
                               }
                           }];
}

@end
