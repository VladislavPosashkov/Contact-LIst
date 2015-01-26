//
//  JSONUtilities.h
//  Task2
//
//  Created by Vladislav Posashkov on 22.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Contact;

@interface JSONUtilities : NSObject

+ (Contact *)contactWithJSONObject:(id)JSONObject;

+ (NSMutableArray *)contactListWithJSONObject:(id)JSONObject;

+ (NSMutableArray *)contactListWithJSONData:(NSData *)JSONData;

#pragma mark - Contact to JSON

+ (NSDictionary *)JSONObjectWithFullName:(NSString *)fullName email:(NSString *)email;

+ (NSData *)JSONDataWithFullName:(NSString *)fullName email:(NSString *)email;
#pragma mark - JSON to Data

+ (NSData *)dataWithContentOfJSONObject:(id)JSONObject;

#pragma mark - Data to JSON

+ (NSDictionary *)JSONObjectWithData:(NSData *)data;


@end
