//
//  RDVTabBarItem.m
//  RDVTabBarController
//
//  Created by Robert Dimitrov on 5/7/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVTabBarItem.h"

@interface RDVTabBarItem ()

@property (nonatomic) UIImage *selectedImage;
@property (nonatomic) UIImage *unselectedImage;

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
        [self setSelectedImage:selectedImage];
        [self setBackgroundImage:selectedImage forState:UIControlStateSelected|UIControlStateHighlighted];
        [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
        [self setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    }
    
    if (unselectedImage) {
        [self setUnselectedImage:unselectedImage];
        [self setBackgroundImage:unselectedImage forState:UIControlStateNormal];
    }
}

- (void)setImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}

- (UIImage *)image {
    return [self imageForState:UIControlStateNormal];
}

- (void)changeSelected:(BOOL)selected {
    [self setSelected:selected];
    if (selected) {
//        [self setBackgroundImage:[self selectedImage] forState:UIControlStateNormal];
    } else {
//        [self setBackgroundImage:[self unselectedImage] forState:UIControlStateNormal];
    }
}

@end
