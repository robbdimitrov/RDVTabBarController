// RDVTabBarItem.h
// RDVTabBarController
//
// Copyright (c) 2013 Robert Dimitrov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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

- (UIOffset)imagePositionAdjustment;
- (void)setImagePositionAdjustment:(UIOffset)adjustment;

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
