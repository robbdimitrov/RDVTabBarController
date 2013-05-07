// RDVTabBar.m
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

#import "RDVTabBar.h"
#import "RDVTabBarItem.h"

@interface RDVTabBar ()

@property (nonatomic) CGFloat itemOffset;

@end

@implementation RDVTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemWidth = 0;
        _itemOffset = 0;
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews {
    if (![self itemWidth]) {
        [self setItemWidth:self.frame.size.width / [[self items] count]];
    }
    
    for (NSInteger i = 0; i < [[self items] count]; i++) {
        RDVTabBarItem *item = [[self items] objectAtIndex:i];
        [item setFrame:CGRectMake(self.itemOffset + (i * self.itemWidth), 0, self.itemWidth, self.frame.size.height)];
    }
}

- (void)setItemWidth:(CGFloat)itemWidth {
    if (itemWidth > 0) {
        _itemWidth = itemWidth;
    }
}

- (void)setItems:(NSArray *)items {
    for (RDVTabBarItem *item in items) {
        [item removeFromSuperview];
    }
    
    _items = [items copy];
    for (RDVTabBarItem *item in items) {
        [self addSubview:item];
    }
}

@end
