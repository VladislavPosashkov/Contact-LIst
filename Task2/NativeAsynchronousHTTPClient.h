//
//  NativeAsynchronousHTTPClient.h
//  Task2
//
//  Created by Vladislav Posashkov on 19.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import "HTTPClient.h"

@interface NativeAsynchronousHTTPClient : HTTPClient

+ (NativeAsynchronousHTTPClient *)sharedManager;

@end
