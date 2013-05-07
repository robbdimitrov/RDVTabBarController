//
//  RDVTabBarItem.m
//  RDVTabBarController
//
//  Created by Robert Dimitrov on 5/7/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVTabBarItem.h"

@interface RDVTabBarItem ()

@end

@implementation RDVTabBarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (UIImage *)finishedSelectedImage {
    return [self imageForState:UIControlStateReserved];
}

- (UIImage *)finishedUnselectedImage {
    return [self imageForState:UIControlStateNormal];
}

- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage) {
        [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
        [self setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    }
    
    if (unselectedImage) {
        [self setBackgroundImage:unselectedImage forState:UIControlStateNormal];
    }
}

- (void)setImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}

- (UIImage *)image {
    return [self imageForState:UIControlStateNormal];
}

@end
