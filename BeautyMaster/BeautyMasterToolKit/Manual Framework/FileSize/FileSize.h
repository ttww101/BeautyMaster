//
//  FileSize.h
//  CMSNews
//
//  Created by ieliwb  on 13-7-23.
//  Copyright (c) 2013年 www.app4cms.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSize : NSObject

+ (NSString *)stringFolderSizeAtPath:(NSString*) folderPath;
+ (long long) folderSizeAtPath:(NSString*) folderPath;

@end
