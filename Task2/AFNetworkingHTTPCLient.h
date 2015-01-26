//
//  AFNetworkingHTTPCLient.h
//  Task2
//
//  Created by Vladislav Posashkov on 21.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import "HTTPClient.h"

@interface AFNetworkingHTTPCLient : HTTPClient

+ (AFNetworkingHTTPCLient *)sharedManager;

@end
