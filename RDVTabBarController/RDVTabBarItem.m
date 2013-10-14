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

#import "RDVTabBarItem.h"

@interface RDVTabBarItem () {
    NSString *_title;
    UIOffset _titlePositionAdjustment;
    UIOffset _imagePositionAdjustment;
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
        
        if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
            _unselectedTitleAttributes = @{
                                           NSFontAttributeName: [UIFont systemFontOfSize:12],
                                           NSForegroundColorAttributeName: [UIColor blackColor],
                                           };
        } else {
            _unselectedTitleAttributes = @{
                                           UITextAttributeFont: [UIFont systemFontOfSize:12],
                                           UITextAttributeTextColor: [UIColor blackColor],
                                           };
        }
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
        
        if (!titleAttributes) {
            titleAttributes = [self unselectedTitleAttributes];
        }
    } else {
        image = [self unselectedImage];
        backgroundImage = [self unselectedBackgroundImage];
        titleAttributes = [self unselectedTitleAttributes];
    }
    
    imageSize = [image size];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [backgroundImage drawInRect:self.bounds];
    
    if (![_title length]) {
        [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) +
                                     _imagePositionAdjustment.horizontal,
                                     roundf(frameSize.height / 2 - imageSize.height / 2) +
                                     _imagePositionAdjustment.vertical,
                                     imageSize.width, imageSize.height)];
    } else {
        if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
            CGSize titleSize = [_title boundingRectWithSize:CGSizeMake(frameSize.width, 20)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName: titleAttributes[NSFontAttributeName]}
                                                    context:nil].size;
            
            CGFloat imageStartingY = roundf((frameSize.height - imageSize.height - titleSize.height) / 2);
            
            [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) +
                                         _imagePositionAdjustment.horizontal,
                                         imageStartingY + _imagePositionAdjustment.vertical,
                                         imageSize.width, imageSize.height)];
            
            CGContextSetFillColorWithColor(context, [titleAttributes[NSForegroundColorAttributeName] CGColor]);
            
            [_title drawInRect:CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2) +
                                          _titlePositionAdjustment.horizontal,
                                          imageStartingY + imageSize.height + _titlePositionAdjustment.vertical,
                                          titleSize.width, titleSize.height)
                withAttributes:titleAttributes];
        } else {
            CGSize titleSize = [_title sizeWithFont:titleAttributes[UITextAttributeFont]
                                  constrainedToSize:CGSizeMake(frameSize.width, 20)];
            UIOffset titleShadowOffset = [titleAttributes[UITextAttributeTextShadowOffset] UIOffsetValue];
            CGFloat imageStartingY = roundf((frameSize.height - imageSize.height - titleSize.height) / 2);
            
            [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) +
                                         _imagePositionAdjustment.horizontal,
                                         imageStartingY + _imagePositionAdjustment.vertical,
                                         imageSize.width, imageSize.height)];
            
            CGContextSetFillColorWithColor(context, [titleAttributes[UITextAttributeTextColor] CGColor]);
            
            UIColor *shadowColor = titleAttributes[UITextAttributeTextShadowColor];
            
            if (shadowColor) {
                CGContextSetShadowWithColor(context, CGSizeMake(titleShadowOffset.horizontal, titleShadowOffset.vertical),
                                            1.0, [shadowColor CGColor]);
            }
            
            [_title drawInRect:CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2) +
                                          _titlePositionAdjustment.horizontal,
                                          imageStartingY + imageSize.height + _titlePositionAdjustment.vertical,
                                          titleSize.width, titleSize.height)
                      withFont:titleAttributes[UITextAttributeFont]
                 lineBreakMode:NSLineBreakByTruncatingTail];
        }
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

- (void)setUnselectedTitleAttributes:(NSDictionary *)attributes {
    @synchronized(_unselectedTitleAttributes) {
        if (attributes && ![_unselectedTitleAttributes isEqual:attributes]) {
            _unselectedTitleAttributes = [attributes copy];
        }
    }
}

- (NSDictionary *)selectedTitleAttributes {
    @synchronized(_selectedTitleAttributes) {
        return _selectedTitleAttributes;
    }
}

- (void)setSelectedTitleAttributes:(NSDictionary *)attributes {
    @synchronized(_selectedTitleAttributes) {
        if (attributes && ![_selectedTitleAttributes isEqual:attributes]) {
            _selectedTitleAttributes = [attributes copy];
        }
    }
}

#pragma mark - Images

- (UIOffset)imagePositionAdjustment {
    return _imagePositionAdjustment;
}

- (void)setImagePositionAdjustment:(UIOffset)adjustment {
    _imagePositionAdjustment = adjustment;
}

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
