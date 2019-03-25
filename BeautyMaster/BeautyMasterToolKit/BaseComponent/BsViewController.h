//
//  BaseViewController.h
//  iHealthS
//
//  Created by Wu on 2019/3/19.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationTheme.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^NavigationIntialSetup)(NavigationTheme *);

@interface BsViewController : UIViewController

@property (nullable, copy, nonatomic) NavigationIntialSetup navigationSetup;

@end

NS_ASSUME_NONNULL_END
