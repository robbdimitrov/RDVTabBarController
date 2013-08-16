//
//  RDVTabBarItem.m
//  RDVTabBarController
//
//  Created by Robert Dimitrov on 5/7/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVTabBarItem.h"

@implementation RDVTabBarItem

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
        UILabel *titleLabel = [self titleLabel];
        if ([titleLabel respondsToSelector:@selector(minimumScaleFactor)]) {
            [titleLabel setMinimumScaleFactor:8];
        } else {
            [titleLabel setMinimumFontSize:8];
        }
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat imageWidth = CGRectGetWidth(self.imageView.frame);
    CGFloat imageHeight = CGRectGetHeight(self.imageView.frame);
    
    if (![[[self titleLabel] text] length]) {
        [[self imageView] setFrame:CGRectMake(roundf(width / 2 - imageWidth / 2), roundf(height / 2 - imageHeight / 2),
                                              imageWidth, imageHeight)];
        [[self titleLabel] setFrame:CGRectZero];
    } else {
        CGSize titleSize = [[self titleLabel] sizeThatFits:CGSizeMake(width, 20)];
        CGFloat imageStartingY = roundf((height - imageHeight - titleSize.height) / 2);
        
        [[self imageView] setFrame:CGRectMake(roundf(width / 2 - imageWidth / 2), imageStartingY,
                                              imageWidth, imageHeight)];
        [[self titleLabel] setFrame:CGRectMake(roundf(width / 2 - titleSize.width / 2),
                                               CGRectGetMaxY(self.imageView.frame), titleSize.width, titleSize.height)];
    }
}

#pragma mark - Methods

- (UIImage *)backgroundSelectedImage {
    return [self backgroundImageForState:UIControlStateSelected];
}

- (UIImage *)backgroundUnselectedImage {
    return [self backgroundImageForState:UIControlStateNormal];
}

- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage) {
        [self setBackgroundImage:selectedImage forState:UIControlStateSelected|UIControlStateHighlighted];
        [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
    }
    
    if (unselectedImage) {
        [self setBackgroundImage:unselectedImage forState:UIControlStateNormal];
    }
}

- (UIImage *)finishedSelectedImage {
    return [self imageForState:UIControlStateSelected];
}

- (UIImage *)finishedUnselectedImage {
    return [self imageForState:UIControlStateNormal];
}

- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage) {
        [self setImage:selectedImage forState:UIControlStateSelected|UIControlStateHighlighted];
        [self setImage:selectedImage forState:UIControlStateSelected];
    }
    
    if (unselectedImage) {
        [self setImage:unselectedImage forState:UIControlStateNormal];
    }
}

@end
