//
//  UIView+Constraint.m
//  SKBank
//
//  Created by Bomi on 2018/4/16.
//

#import "UIView+Constraint.h"

@implementation UIView (Constraint)

- (void)removeAllConstraints {
    UIView *superview = self.superview;
    while (superview != nil) {
        for (NSLayoutConstraint *c in superview.constraints) {
            if (c.firstItem == self || c.secondItem == self) {
                [superview removeConstraint:c];
            }
        }
        superview = superview.superview;
    }
    
    [self removeConstraints:self.constraints];
    self.translatesAutoresizingMaskIntoConstraints = YES;
}

/**
 constraints self to constraintsView bounds
 */
- (UIView *)constraints:(UIView *)constraintsView __attribute__((warn_unused_result)) {
    return [self constraints:constraintsView constant:UIEdgeInsetsMake(0, 0, 0, 0)];;
}

/**
 constraints self to constraintsView bounds with constant
 */
- (UIView *)constraints:(UIView *)constraintsView constant:(UIEdgeInsets)constant __attribute__((warn_unused_result)) {
    return [self constraintsTop:constraintsView toLayoutAttribute:NSLayoutAttributeTop leading:constraintsView toLayoutAttribute:NSLayoutAttributeLeading bottom:constraintsView toLayoutAttribute:NSLayoutAttributeBottom trailing:constraintsView toLayoutAttribute:NSLayoutAttributeTrailing constant:constant];
}

/**
 constraints self with
 1. top view, top LayoutAttribute
 2. leading view, leading LayoutAttribute
 3. bottom view, bottom LayoutAttribute
 4. trailing view, trailing LayoutAttribute
 5. constant
 */
- (UIView *)constraintsTop:(UIView *)topView toLayoutAttribute:(NSLayoutAttribute)topLayoutAttribute leading:(UIView *)leadingView toLayoutAttribute:(NSLayoutAttribute)leadingLayoutAttribute bottom:(UIView *)bottomView toLayoutAttribute:(NSLayoutAttribute)bottomLayoutAttribute trailing:(UIView *)trailingView toLayoutAttribute:(NSLayoutAttribute)trailingLayoutAttribute constant:(UIEdgeInsets)constant __attribute__((warn_unused_result)) {
    
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    if (topView) [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:topLayoutAttribute multiplier:1.0 constant:constant.top]];
    if (leadingView) [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:leadingView attribute:leadingLayoutAttribute multiplier:1.0 constant:constant.left]];
    if (bottomView) [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:bottomLayoutAttribute multiplier:1.0 constant:constant.bottom]];
    if (trailingView) [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:trailingView attribute:trailingLayoutAttribute multiplier:1.0 constant:constant.right]];
    
    return self;
}

//Top
- (UIView *)constraintsTop:(UIView *)topView toLayoutAttribute:(NSLayoutAttribute)topLayoutAttribute __attribute__((warn_unused_result)) {
    return [self constraintsTop:topView toLayoutAttribute:topLayoutAttribute constant:0];
}

- (UIView *)constraintsTop:(UIView *)topView toLayoutAttribute:(NSLayoutAttribute)topLayoutAttribute constant:(CGFloat)constant __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    if (topView) [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:topLayoutAttribute multiplier:1.0 constant:constant]];
    return self;
}

- (UIView *)constraintsTop:(UIView *)topView toLayoutAttribute:(NSLayoutAttribute)topLayoutAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    if (topView) [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:relation toItem:topView attribute:topLayoutAttribute multiplier:1.0 constant:constant]];
    return self;
}

//Bottom
- (UIView *)constraintsBottom:(UIView *)bottomView toLayoutAttribute:(NSLayoutAttribute)bottomLayoutAttribute  __attribute__((warn_unused_result)) {
    return [self constraintsBottom:bottomView toLayoutAttribute:bottomLayoutAttribute constant:0];
}

- (UIView *)constraintsBottom:(UIView *)bottomView toLayoutAttribute:(NSLayoutAttribute)bottomLayoutAttribute constant:(CGFloat)constant __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    if (bottomView) [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:bottomLayoutAttribute multiplier:1.0 constant:constant]];
    return self;
}

- (UIView *)constraintsBottom:(UIView *)bottomView toLayoutAttribute:(NSLayoutAttribute)bottomLayoutAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    if (bottomView) [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:relation toItem:bottomView attribute:bottomLayoutAttribute multiplier:1.0 constant:constant]];
    return self;
}

//Leading
- (UIView *)constraintsLeading:(UIView *)leadingView toLayoutAttribute:(NSLayoutAttribute)leadingLayoutAttribute __attribute__((warn_unused_result)) {
    return [self constraintsLeading:leadingView toLayoutAttribute:leadingLayoutAttribute constant:0];
}

- (UIView *)constraintsLeading:(UIView *)leadingView toLayoutAttribute:(NSLayoutAttribute)leadingLayoutAttribute constant:(CGFloat)constant __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    if (leadingView) [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:leadingView attribute:leadingLayoutAttribute multiplier:1.0 constant:constant]];
    return self;
}

- (UIView *)constraintsLeading:(UIView *)leadingView toLayoutAttribute:(NSLayoutAttribute)leadingLayoutAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    if (leadingView) [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:relation toItem:leadingView attribute:leadingLayoutAttribute multiplier:1.0 constant:constant]];
    return self;
}

//Trailing
- (UIView *)constraintsTrailing:(UIView *)trailingView toLayoutAttribute:(NSLayoutAttribute)trailingLayoutAttribute __attribute__((warn_unused_result)) {
    return [self constraintsTrailing:trailingView toLayoutAttribute:trailingLayoutAttribute constant:0];
}

- (UIView *)constraintsTrailing:(UIView *)trailingView toLayoutAttribute:(NSLayoutAttribute)trailingLayoutAttribute constant:(CGFloat)constant __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    if (trailingView) [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:trailingView attribute:trailingLayoutAttribute multiplier:1.0 constant:constant]];
    return self;
}

- (UIView *)constraintsTrailing:(UIView *)trailingView toLayoutAttribute:(NSLayoutAttribute)trailingLayoutAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    if (trailingView) [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:relation toItem:trailingView attribute:trailingLayoutAttribute multiplier:1.0 constant:constant]];
    return self;
}

//CenterX
- (UIView *)constraintsCenterX:(UIView *)centerXView toLayoutAttribute:(NSLayoutAttribute)centerXLayoutAttribute  __attribute__((warn_unused_result)) {
    [self constraintsCenterX:centerXView toLayoutAttribute:centerXLayoutAttribute constant:0];
    return self;
}

- (UIView *)constraintsCenterX:(UIView *)centerXView toLayoutAttribute:(NSLayoutAttribute)centerXLayoutAttribute constant:(CGFloat)constant __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    if (centerXView) [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:centerXView attribute:centerXLayoutAttribute multiplier:1.0 constant:constant]];
    return self;
}

- (UIView *)constraintsCenterX:(UIView *)centerXView toLayoutAttribute:(NSLayoutAttribute)centerXLayoutAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    if (centerXView) [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:relation toItem:centerXView attribute:centerXLayoutAttribute multiplier:1.0 constant:constant]];
    return self;
}

//CenterY
- (UIView *)constraintsCenterY:(UIView *)centerYView toLayoutAttribute:(NSLayoutAttribute)centerYLayoutAttribute  __attribute__((warn_unused_result)) {
    [self constraintsCenterY:centerYView toLayoutAttribute:centerYLayoutAttribute constant:0];
    return self;
}

- (UIView *)constraintsCenterY:(UIView *)centerYView toLayoutAttribute:(NSLayoutAttribute)centerYLayoutAttribute constant:(CGFloat)constant __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    if (centerYView)
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:centerYView attribute:centerYLayoutAttribute multiplier:1.0 constant:constant]];
    return self;
}

- (UIView *)constraintsCenterY:(UIView *)centerYView toLayoutAttribute:(NSLayoutAttribute)centerYLayoutAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    if (centerYView)
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:relation toItem:centerYView attribute:centerYLayoutAttribute multiplier:1.0 constant:constant]];
    return self;
}

//Width, Height
- (UIView *)constraintsWidthWithConstant:(CGFloat)constant __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:constant]];
    return self;
}

- (UIView *)constraintsHeightWithConstant:(CGFloat)constant __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:constant]];
    return self;
}

- (UIView *)constraintSelfWidthHeightByRatio:(CGFloat)ratio __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:ratio constant:0]];
    return self;
}

- (UIView *)constraintWidthToView:(UIView *)ratioView ByRatio:(CGFloat)ratio __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:ratioView attribute:NSLayoutAttributeWidth multiplier:ratio constant:0]];
    return self;
}

- (UIView *)constraintHeightToView:(UIView *)ratioView ByRatio:(CGFloat)ratio __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:ratioView attribute:NSLayoutAttributeHeight multiplier:ratio constant:0]];
    return self;
}

- (UIView *)constraintLayoutAttribute:(NSLayoutAttribute)fromLayoutAttribute toView:(UIView *)ratioView layoutAttribute:(NSLayoutAttribute)toLayoutAttribute ByRatio:(CGFloat)ratio __attribute__((warn_unused_result)) {
    if (!self.superview) { return self; }
    if (self.translatesAutoresizingMaskIntoConstraints) self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:fromLayoutAttribute relatedBy:NSLayoutRelationEqual toItem:ratioView attribute:toLayoutAttribute multiplier:ratio constant:0]];
    return self;
}

- (void)autoSizefromWidth:(CGFloat)fixedWidth {
    self.translatesAutoresizingMaskIntoConstraints = false;
    
    UIView  *dummyContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fixedWidth, 10000000)];
    [dummyContainerView addSubview:self];
    [self constraintsTop:dummyContainerView toLayoutAttribute:NSLayoutAttributeTop constant:0];
    [self constraintsLeading:dummyContainerView toLayoutAttribute:NSLayoutAttributeLeading constant:0];
    [self constraintsTrailing:dummyContainerView toLayoutAttribute:NSLayoutAttributeTrailing constant:0];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self removeFromSuperview];
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.translatesAutoresizingMaskIntoConstraints = true;
}

@end
