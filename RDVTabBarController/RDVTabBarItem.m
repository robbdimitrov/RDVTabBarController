//
//  RDVTabBarItem.m
//  RDVTabBarController
//
//  Created by Robert Dimitrov on 5/7/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVTabBarItem.h"

@interface RDVTabBarItem () {
    NSString *_title;
    UIOffset _titlePositionAdjustment;
    NSDictionary *_unselectedTitleAttributes;
    NSDictionary *_selectedTitleAttributes;
}

@property UIImage *unselectedBackgroundImage;
@property UIImage *selectedBackgroundImage;
@property UIImage *unselectedImage;
@property UIImage *selectedImage;

@end

@implementation RDVTabBarItem

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _title = @"";
        _titlePositionAdjustment = UIOffsetZero;
        
        _unselectedTitleAttributes = @{UITextAttributeFont: [UIFont systemFontOfSize:12],
                                       UITextAttributeTextColor: [UIColor whiteColor],
                                       UITextAttributeTextShadowColor: [UIColor whiteColor],
                                       UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                                       };
        
        _selectedTitleAttributes = [_unselectedTitleAttributes copy];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)drawRect:(CGRect)rect {
    CGSize frameSize = self.frame.size;
    CGSize imageSize = CGSizeZero;
    NSDictionary *titleAttributes = nil;
    UIImage *backgroundImage = nil;
    UIImage *image = nil;
    
    if ([self isSelected]) {
        image = [self selectedImage];
        backgroundImage = [self selectedBackgroundImage];
        titleAttributes = [self selectedTitleAttributes];
    } else {
        image = [self unselectedImage];
        backgroundImage = [self unselectedBackgroundImage];
        titleAttributes = [self unselectedTitleAttributes];
    }
    
    imageSize = [image size];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    if (backgroundImage.size.width < frameSize.width) {
        [backgroundImage drawAsPatternInRect:self.bounds];
    } else {
        [backgroundImage drawInRect:self.bounds];
    }
    
    if (![_title length]) {
        [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2),
                                     roundf(frameSize.height / 2 - imageSize.height / 2),
                                     imageSize.width, imageSize.height)];
    } else {
        CGSize titleSize = [_title sizeWithFont:[UIFont systemFontOfSize:12]
                              constrainedToSize:CGSizeMake(frameSize.width, 20)];
        UIOffset titleShadowOffset = [titleAttributes[UITextAttributeTextShadowOffset] UIOffsetValue];
        CGFloat imageStartingY = roundf((frameSize.height - imageSize.height - titleSize.height) / 2);
        
        [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2), imageStartingY,
                                     imageSize.width, imageSize.height)];
        
        CGContextSetFillColorWithColor(context, [titleAttributes[UITextAttributeTextColor] CGColor]);
        CGContextSetShadowWithColor(context, CGSizeMake(titleShadowOffset.horizontal, titleShadowOffset.vertical),
                                    1.0, [titleAttributes[UITextAttributeTextShadowColor] CGColor]);
        
        [_title drawInRect:CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2) +
                                      _titlePositionAdjustment.horizontal,
                                      imageStartingY + imageSize.height + _titlePositionAdjustment.vertical,
                                      titleSize.width, titleSize.height)
                  withFont:titleAttributes[UITextAttributeFont]
             lineBreakMode:NSLineBreakByTruncatingTail];
    }
    
    CGContextRestoreGState(context);
}

#pragma mark - Title

- (NSString *)title {
    @synchronized(_title) {
        return _title;
    }
}

- (void)setTitle:(NSString *)title {
    @synchronized(_title) {
        if (title && ![_title isEqualToString:title]) {
            _title = [title copy];
        }
    }
}

- (UIOffset)titlePositionAdjustment {
    return _titlePositionAdjustment;
}

- (void)setTitlePositionAdjustment:(UIOffset)adjustment {
    _titlePositionAdjustment = adjustment;
}

- (NSDictionary *)unselectedTitleAttributes {
    @synchronized(_unselectedTitleAttributes) {
        return _unselectedTitleAttributes;
    }
}

- (void)setunselectedTitleAttributes:(NSDictionary *)attributes {
    @synchronized(_unselectedTitleAttributes) {
        if (attributes && [_unselectedTitleAttributes isEqual:attributes]) {
            _unselectedTitleAttributes = [attributes copy];
        }
    }
}

- (NSDictionary *)selectedTitleAttributes {
    @synchronized(_selectedTitleAttributes) {
        return _selectedTitleAttributes;
    }
}

- (void)selectedTitleAttributes:(NSDictionary *)attributes {
    @synchronized(_selectedTitleAttributes) {
        if (attributes && [_selectedTitleAttributes isEqual:attributes]) {
            _selectedTitleAttributes = [attributes copy];
        }
    }
}

#pragma mark - Images

- (UIImage *)backgroundSelectedImage {
    return [self selectedBackgroundImage];
}

- (UIImage *)backgroundUnselectedImage {
    return [self unselectedBackgroundImage];
}

- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage && (selectedImage != [self selectedBackgroundImage])) {
        [self setSelectedBackgroundImage:selectedImage];
    }
    
    if (unselectedImage && (unselectedImage != [self unselectedBackgroundImage])) {
        [self setUnselectedBackgroundImage:unselectedImage];
    }
}

- (UIImage *)finishedSelectedImage {
    return [self selectedImage];
}

- (UIImage *)finishedUnselectedImage {
    return [self unselectedImage];
}

- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage && (selectedImage != [self selectedImage])) {
        [self setSelectedImage:selectedImage];
    }
    
    if (unselectedImage && (unselectedImage != [self unselectedImage])) {
        [self setUnselectedImage:unselectedImage];
    }
}

@end
