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
        [self.titleLabel setMinimumFontSize:8];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([[[self titleLabel] text] length]) {
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
}

- (UIImage *)backgroundSelectedImage {
    return [self backgroundImageForState:UIControlStateHighlighted];
}

- (UIImage *)backgroundUnselectedImage {
    return [self backgroundImageForState:UIControlStateNormal];
}

- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage) {
        [self setBackgroundImage:selectedImage forState:UIControlStateSelected|UIControlStateHighlighted];
        [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
        [self setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    }
    
    if (unselectedImage) {
        [self setBackgroundImage:unselectedImage forState:UIControlStateNormal];
    }
}

- (UIImage *)finishedSelectedImage {
    return [self imageForState:UIControlStateReserved];
}

- (UIImage *)finishedUnselectedImage {
    return [self imageForState:UIControlStateNormal];
}

- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage) {
        [self setImage:selectedImage forState:UIControlStateSelected|UIControlStateHighlighted];
        [self setImage:selectedImage forState:UIControlStateSelected];
        [self setImage:selectedImage forState:UIControlStateHighlighted];
    }
    
    if (unselectedImage) {
        [self setImage:unselectedImage forState:UIControlStateNormal];
    }
}

- (void)setImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateSelected|UIControlStateHighlighted];
    [self setImage:image forState:UIControlStateSelected];
    [self setImage:image forState:UIControlStateHighlighted];
}

- (UIImage *)image {
    return [self imageForState:UIControlStateNormal];
}

- (void)changeSelected:(BOOL)selected {
    [self setSelected:selected];
}

@end
