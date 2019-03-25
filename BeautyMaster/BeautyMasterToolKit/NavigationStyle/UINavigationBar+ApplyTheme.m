//
//  UINavigationBar+ApplyTheme.m
//  iHealthS
//
//  Created by Wu on 2019/3/19.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import "UINavigationBar+ApplyTheme.h"
#import "NavigationTheme.h"

@implementation UINavigationBar (ApplyTheme)

- (void)applyTheme:(NavigationTheme *)theme {
    self.barTintColor = theme.barTintColor;
    self.tintColor = theme.tintColor;
    self.titleTextAttributes = theme.titleTextAttributes;
}

@end
