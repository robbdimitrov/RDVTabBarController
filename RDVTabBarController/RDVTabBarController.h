// RDVTabBarController.h
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
#import "RDVTabBar.h"

@protocol RDVTabBarControllerDelegate;

@interface RDVTabBarController : UIViewController <RDVTabBarDelegate>

@property (nonatomic, weak) id<RDVTabBarControllerDelegate> delegate;
@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, readonly) RDVTabBar *tabBar;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic) NSUInteger selectedIndex;

@end

@protocol RDVTabBarControllerDelegate <NSObject>
@optional

- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(RDVTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end

@interface UIViewController (RDVTabBarControllerItem)

@property(nonatomic, strong, setter = rdv_setTabBarItem:) RDVTabBarItem *rdv_tabBarItem;
@property(nonatomic, readonly, strong) RDVTabBarController *rdv_tabBarController;

@end
