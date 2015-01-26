//
//  Contact.h
//  Task2
//
//  Created by Vladislav Posashkov on 23.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject <NSCopying>

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSString * resourceURL;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * contactId;

- (id)copyWithZone:(NSZone *)zone;

@end
