//
//  NetworkSettings.m
//  Task2
//
//  Created by Vladislav Posashkov on 26.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import "NetworkSettings.h"

@implementation NetworkSettings

- (instancetype)initWithSettingsNative:(BOOL)isNative
                           synchronous:(BOOL)isSynchronous {
  self = [super init];

  if (self) {
    self.isNative = isNative;
    self.isSynchronous = isSynchronous;
  }

  return self;
}
- (void)setSettingsNative:(BOOL)isNative synchronous:(BOOL)isSynchronous {
  self.isNative = isNative;
  self.isSynchronous = isSynchronous;
}

@end
