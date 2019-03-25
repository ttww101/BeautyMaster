//
//  UIView+Constraint.h
//  SKBank
//
//  Created by Bomi on 2018/4/16.
//

#import <UIKit/UIKit.h>

@interface UIView (Constraint)

- (void)removeAllConstraints;

- (UIView *)constraints:(UIView *)constraintsView;
- (UIView *)constraints:(UIView *)constraintsView constant:(UIEdgeInsets)constant;
- (UIView *)constraintsTop:(UIView *)topView toLayoutAttribute:(NSLayoutAttribute)topLayoutAttribute leading:(UIView *)leadingView toLayoutAttribute:(NSLayoutAttribute)leadingLayoutAttribute bottom:(UIView *)bottomView toLayoutAttribute:(NSLayoutAttribute)bottomLayoutAttribute trailing:(UIView *)trailingView toLayoutAttribute:(NSLayoutAttribute)trailingLayoutAttribute constant:(UIEdgeInsets)constant;

- (UIView *)constraintsTop:(UIView *)topView toLayoutAttribute:(NSLayoutAttribute)topLayoutAttribute;
- (UIView *)constraintsTop:(UIView *)topView toLayoutAttribute:(NSLayoutAttribute)topLayoutAttribute constant:(CGFloat)constant;
- (UIView *)constraintsTop:(UIView *)topView toLayoutAttribute:(NSLayoutAttribute)topLayoutAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

- (UIView *)constraintsBottom:(UIView *)bottomView toLayoutAttribute:(NSLayoutAttribute)bottomLayoutAttribute;
- (UIView *)constraintsBottom:(UIView *)bottomView toLayoutAttribute:(NSLayoutAttribute)bottomLayoutAttribute constant:(CGFloat)constant;
- (UIView *)constraintsBottom:(UIView *)bottomView toLayoutAttribute:(NSLayoutAttribute)bottomLayoutAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

- (UIView *)constraintsLeading:(UIView *)leadingView toLayoutAttribute:(NSLayoutAttribute)leadingLayoutAttribute;
- (UIView *)constraintsLeading:(UIView *)leadingView toLayoutAttribute:(NSLayoutAttribute)leadingLayoutAttribute constant:(CGFloat)constant;
- (UIView *)constraintsLeading:(UIView *)leadingView toLayoutAttribute:(NSLayoutAttribute)leadingLayoutAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

- (UIView *)constraintsTrailing:(UIView *)trailingView toLayoutAttribute:(NSLayoutAttribute)trailingLayoutAttribute;
- (UIView *)constraintsTrailing:(UIView *)trailingView toLayoutAttribute:(NSLayoutAttribute)trailingLayoutAttribute constant:(CGFloat)constant;
- (UIView *)constraintsTrailing:(UIView *)trailingView toLayoutAttribute:(NSLayoutAttribute)trailingLayoutAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

- (UIView *)constraintsCenterX:(UIView *)centerXView toLayoutAttribute:(NSLayoutAttribute)centerXLayoutAttribute;
- (UIView *)constraintsCenterX:(UIView *)centerXView toLayoutAttribute:(NSLayoutAttribute)centerXLayoutAttribute constant:(CGFloat)constant;
- (UIView *)constraintsCenterX:(UIView *)centerXView toLayoutAttribute:(NSLayoutAttribute)centerXLayoutAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

- (UIView *)constraintsCenterY:(UIView *)centerYView toLayoutAttribute:(NSLayoutAttribute)centerYLayoutAttribute;
- (UIView *)constraintsCenterY:(UIView *)centerYView toLayoutAttribute:(NSLayoutAttribute)centerYLayoutAttribute constant:(CGFloat)constant;
- (UIView *)constraintsCenterY:(UIView *)centerYView toLayoutAttribute:(NSLayoutAttribute)centerYLayoutAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

- (UIView *)constraintsWidthWithConstant:(CGFloat)constant;
- (UIView *)constraintsHeightWithConstant:(CGFloat)constant;

- (UIView *)constraintSelfWidthHeightByRatio:(CGFloat)ratio;

- (UIView *)constraintWidthToView:(UIView *)ratioView ByRatio:(CGFloat)ratio;
- (UIView *)constraintHeightToView:(UIView *)ratioView ByRatio:(CGFloat)ratio;

- (UIView *)constraintLayoutAttribute:(NSLayoutAttribute)fromLayoutAttribute toView:(UIView *)ratioView layoutAttribute:(NSLayoutAttribute)toLayoutAttribute ByRatio:(CGFloat)ratio;

/**
 For adding subview to scroll view.
 Call it before => [self.scrollView setContentSize:self.exampleView.frame.size];
 */
- (void)autoSizefromWidth:(CGFloat)fixedWidth;
@end
