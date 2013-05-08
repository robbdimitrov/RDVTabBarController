//
//  RDVTabBarItem.h
//  RDVTabBarController
//
//  Created by Robert Dimitrov on 5/7/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDVTabBarItem : UIButton

- (UIImage *)finishedSelectedImage;
- (UIImage *)finishedUnselectedImage;
- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;

- (void)changeSelected:(BOOL)selected;

@end
