//
//  Contact.m
//  Task2
//
//  Created by Vladislav Posashkov on 23.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import "Contact.h"


@implementation Contact

- (id)copyWithZone:(NSZone *)zone {
    Contact *copy = [[Contact alloc] init];
    copy.createdDate = self.createdDate;
    copy.updatedDate = self.updatedDate;
    copy.resourceURL = self.resourceURL;
    copy.fullName = self.fullName;
    copy.email = self.email;
    copy.contactId = self.contactId;
    
    return copy;
}

@end
