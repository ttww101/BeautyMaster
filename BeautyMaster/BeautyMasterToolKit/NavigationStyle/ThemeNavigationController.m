//
//  ThemeNavigationController.m
//  iHealthS
//
//  Created by Wu on 2019/3/19.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import "ThemeNavigationController.h"

@implementation ThemeNavigationController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.statusBarStyle = UIStatusBarStyleDefault;
    }
    return self;
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

@end
