//
//  NetworkSettings.h
//  Task2
//
//  Created by Vladislav Posashkov on 26.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkSettings : NSObject

@property(assign, nonatomic) BOOL isNative;
@property(assign, nonatomic) BOOL isSynchronous;

- (instancetype)initWithSettingsNative:(BOOL)isNative
                           synchronous:(BOOL)isSynchronous;

- (void)setSettingsNative:(BOOL)isNative synchronous:(BOOL)isSynchronous;

@end
