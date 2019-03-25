//
//  AVOSCloudIM.m
//  AVOS
//
//  Created by Tang Tianyong on 1/6/16.
//  Copyright © 2016 LeanCloud Inc. All rights reserved.
//

#import "AVOSCloudIM.h"

@implementation AVIMOptions

@end

@implementation AVOSCloudIM

+ (AVIMOptions *)defaultOptions
{
    static AVIMOptions *options;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        options = [[AVIMOptions alloc] init];
    });
    return options;
}

@end
