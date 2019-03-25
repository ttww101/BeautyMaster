//
//  NavigationTheme.h
//  iHealthS
//
//  Created by Wu on 2019/3/19.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NavigationTheme : NSObject

- (instancetype)initWithTintColor:(UIColor *)fontColor barColor:(UIColor *)barColor titleAttributes:(NSDictionary <NSAttributedStringKey, id> *)titleAttributes;

@property (assign, nonatomic) UIStatusBarStyle statusBarStyle;
@property (strong, nonatomic) UIColor *barTintColor;
@property (strong, nonatomic) UIColor *tintColor;
@property (strong, nonatomic) NSDictionary <NSAttributedStringKey, id> *titleTextAttributes;

@end

NS_ASSUME_NONNULL_END
