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

@property (nonatomic) CGFloat itemWidth;

@end

@implementation RDVTabBar

- (void)layoutSubviews {
    CGSize frameSize = self.frame.size;
    
    [self setItemWidth:roundf((frameSize.width - [self edgeContentInsets].left -
                               [self edgeContentInsets].right) / [[self items] count])];
    
    NSInteger index = 0;
    
    for (RDVTabBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        
        if (!itemHeight) {
            itemHeight = frameSize.height;
        }
        
        [item setFrame:CGRectMake(self.edgeContentInsets.left + (index * self.itemWidth),
                                  roundf(frameSize.height - itemHeight) - self.edgeContentInsets.top,
                                  self.itemWidth, itemHeight - self.edgeContentInsets.bottom)];
        [item setNeedsDisplay];
        
        index++;
    }
}

#pragma mark - Methods

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
        [item addTarget:self action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
    }
}

- (void)tabBarItemWasSelected:(id)sender {
    if ([[self delegate] respondsToSelector:@selector(tabBar:shouldSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:sender];
        if (![[self delegate] tabBar:self shouldSelectItemAtIndex:index]) {
            return;
        }
    }
    
    [self setSelectedItem:sender];
    
    if ([[self delegate] respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:self.selectedItem];
        [[self delegate] tabBar:self didSelectItemAtIndex:index];
    }
}

- (void)setSelectedItem:(RDVTabBarItem *)selectedItem {
    if (selectedItem == _selectedItem) {
        return;
    }
    [_selectedItem setSelected:NO];
    
    _selectedItem = selectedItem;
    [_selectedItem setSelected:YES];
}

@end
