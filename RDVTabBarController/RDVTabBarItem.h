//
//  RDVTabBarItem.h
//  RDVTabBarController
//
//  Created by Robert Dimitrov on 5/7/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDVTabBarItem : UIControl

- (NSString *)title;
- (void)setTitle:(NSString *)title;

- (UIOffset)titlePositionAdjustment;
- (void)setTitlePositionAdjustment:(UIOffset)adjustment;

/**
 * For title's text attributes see
 * https://developer.apple.com/library/ios/documentation/uikit/reference/NSString_UIKit_Additions/Reference/Reference.html
 */
- (NSDictionary *)unselectedTitleAttributes;
- (void)setUnselectedTitleAttributes:(NSDictionary *)attributes;
- (NSDictionary *)selectedTitleAttributes;
- (void)setSelectedTitleAttributes:(NSDictionary *)attributes;

- (UIImage *)backgroundSelectedImage;
- (UIImage *)backgroundUnselectedImage;
- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage;

- (UIImage *)finishedSelectedImage;
- (UIImage *)finishedUnselectedImage;
- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage;

/**
 * itemHeight is an optional property. When set it is used instead of tabBar's height
 */
@property CGFloat itemHeight;

@end
