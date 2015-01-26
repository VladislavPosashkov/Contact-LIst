//
//  JSONUtilities.m
//  Task2
//
//  Created by Vladislav Posashkov on 22.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import "JSONUtilities.h"
#import "Contact.h"

@implementation JSONUtilities

static NSString * const kDateFormatterString = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSS";

+ (NSMutableArray *)contactListWithJSONData:(NSData *)JSONData {
    NSDictionary *JSONObject = [JSONUtilities JSONObjectWithData:JSONData];
    NSMutableArray *contactList = [JSONUtilities contactListWithJSONObject:[JSONObject valueForKey:@"objects"]];
    return contactList;
}

+ (NSData *)JSONDataWithFullName:(NSString *)fullName email:(NSString *)email {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"full_name":fullName ,@"email":email} options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        NSLog(@"JSONDataWithFullName:email: Error: %@",[error localizedDescription]);
        return nil;
    }
    
    return data;
}

#pragma mark - JSON to Contact

+ (Contact *)contactWithJSONObject:(id)JSONObject {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormatterString];
    Contact *contact = [[Contact alloc] init];
    contact.contactId = [JSONObject valueForKey:@"id"];
    contact.fullName = [JSONObject valueForKey:@"full_name"];
    contact.email = [JSONObject valueForKey:@"email"];
    contact.resourceURL = [JSONObject valueForKey:@"resource_uri"];
    contact.createdDate = [dateFormatter dateFromString:[JSONObject valueForKey:@"created"]];
    contact.updatedDate = [dateFormatter dateFromString:[JSONObject valueForKey:@"updated"]];
    return contact;
}

+ (NSMutableArray *)contactListWithJSONObject:(id)JSONObject {
    NSMutableArray *contactList = [[NSMutableArray alloc] init];
    
    for(id object in JSONObject){
        [contactList addObject:[JSONUtilities contactWithJSONObject:object]];
    }
    
    return contactList;
}

#pragma mark - Contact to JSON

+ (NSDictionary *)JSONObjectWithFullName:(NSString *)fullName email:(NSString *)email {
    return @{@"full_name":fullName ,@"email":email};
}


#pragma mark - JSON to Data

+ (NSData *)dataWithContentOfJSONObject:(id)JSONObject {
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:JSONObject options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        NSLog(@"JSON Error: %@",[error localizedDescription]);
        return nil;
    }
    
    return data;
}

#pragma mark - Data to JSON

+ (NSDictionary *)JSONObjectWithData:(NSData *)data{
    NSError *error = nil;
    NSDictionary *JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        NSLog(@"JSON Error: %@",[error localizedDescription]);
        return nil;
    }
    
    return JSONObject;
}

@end
