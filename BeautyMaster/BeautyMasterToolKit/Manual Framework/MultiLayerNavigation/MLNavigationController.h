//
//  MLNavigationController.h
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeNavigationController.h"

@interface MLNavigationController : ThemeNavigationController <UIGestureRecognizerDelegate>

// Enable the drag to back interaction, Defalt is YES.
@property (nonatomic,assign) BOOL canDragBack;

- (void)setBackgroudColor:(UIColor *)color;

@end
