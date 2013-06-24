// RDVTabBarController.m
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

#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"

@interface RDVTabBarController ()

@property (nonatomic, readwrite) RDVTabBar *tabBar;
@property (nonatomic, readwrite) UIView *contentView;

@end

@implementation RDVTabBarController

#pragma mark - View lifecycle

- (void)loadView {
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    UIView *view = [[UIView alloc] initWithFrame:applicationFrame];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    [view addSubview:self.contentView];
    [view addSubview:self.tabBar];
    
    self.view = view;
}

- (void)viewWillLayoutSubviews {
    CGSize viewSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    CGFloat tabBarHeight = CGRectGetHeight([[self tabBar] frame]);
    if (!tabBarHeight) {
        tabBarHeight = 49;
    }
    
    if (!self.parentViewController) {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            viewSize = CGSizeMake(CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame));
        }
    }
    
    [[self contentView] setFrame:CGRectMake(0, 0, viewSize.width, viewSize.height - tabBarHeight)];
    [[self tabBar] setFrame:CGRectMake(0, viewSize.height - tabBarHeight, viewSize.width, tabBarHeight)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setSelectedIndex:[self selectedIndex]];
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
    
    UIInterfaceOrientationMask orientationMask = UIInterfaceOrientationMaskAll;
    for (UIViewController *viewCotroller in [self viewControllers]) {
        if (![viewCotroller respondsToSelector:@selector(supportedInterfaceOrientations)]) {
            return UIInterfaceOrientationMaskPortrait;
        }
        
        if (orientationMask > [viewCotroller supportedInterfaceOrientations]) {
            orientationMask = [viewCotroller supportedInterfaceOrientations];
        }
    }
    
    return orientationMask;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    for (UIViewController *viewCotroller in [self viewControllers]) {
        if (![viewCotroller respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)] ||
            ![viewCotroller shouldAutorotateToInterfaceOrientation:toInterfaceOrientation]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Methods

- (void)backButtonTapped:(id)sender {
    if ([[self selectedViewController] isKindOfClass:[UINavigationController class]]) {
        UINavigationController *selectedController = (UINavigationController *)[self selectedViewController];
        
        if ([selectedController topViewController] != [selectedController viewControllers][0]) {
            [selectedController popViewControllerAnimated:YES];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIViewController *)selectedViewController {
    return [[self viewControllers] objectAtIndex:[self selectedIndex]];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if ([self selectedViewController]) {
        [[self selectedViewController] willMoveToParentViewController:nil];
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    
    _selectedIndex = selectedIndex;
    [[self tabBar] setSelectedItem:[[self tabBar] items][selectedIndex]];
    
    [self setSelectedViewController:[[self viewControllers] objectAtIndex:selectedIndex]];
    [self addChildViewController:[self selectedViewController]];
    [[[self selectedViewController] view] setFrame:[[self contentView] bounds]];
    [[self contentView] addSubview:[[self selectedViewController] view]];
    [[self selectedViewController] didMoveToParentViewController:self];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = [viewControllers copy];
        
        NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
        
        for (UIViewController *viewController in viewControllers) {
            RDVTabBarItem *tabBarItem = [[RDVTabBarItem alloc] init];
            [tabBarItem setTitle:viewController.title forState:UIControlStateNormal];
            [tabBarItems addObject:tabBarItem];
        }
        
        [[self tabBar] setItems:tabBarItems];
    } else {
        _viewControllers = nil;
    }
}

- (NSInteger)indexForViewController:(UIViewController *)viewController {
    UIViewController *searchedController = viewController;
    if ([self navigationController]) {
        searchedController = [viewController navigationController];
    }
    return [[self viewControllers] indexOfObject:searchedController];
}

- (RDVTabBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[RDVTabBar alloc] init];
        [_tabBar setBackgroundColor:[UIColor lightGrayColor]];
        [_tabBar setDelegate:self];
    }
    return _tabBar;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return _contentView;
}

#pragma mark - RDVTabBarDelegate

- (BOOL)tabBar:(RDVTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {
    if ([[self delegate] respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        if (![[self delegate] tabBarController:self shouldSelectViewController:[self viewControllers][index]]) {
            return NO;
        }
    }
    
    if ([self selectedViewController] == [self viewControllers][index]) {
        if ([[self selectedViewController] isKindOfClass:[UINavigationController class]]) {
            UINavigationController *selectedController = (UINavigationController *)[self selectedViewController];
            
            if ([selectedController topViewController] != [selectedController viewControllers][0]) {
                [selectedController popViewControllerAnimated:YES];
            }
        }
        
        return NO;
    }
    
    return YES;
}

- (void)tabBar:(RDVTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    if (index < 0 || index >= [[self viewControllers] count]) {
        return;
    }
    
    [self setSelectedIndex:index];
    
    if ([[self delegate] respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [[self delegate] tabBarController:self didSelectViewController:[self viewControllers][index]];
    }
}

@end

#pragma mark - UIViewController+RDVTabBarControllerItem

@implementation UIViewController (RDVTabBarControllerItem)

- (RDVTabBarController *)rdv_tabBarController {
    if ([self navigationController]) {
        return (RDVTabBarController *)[[self navigationController] parentViewController];
    }
    return (RDVTabBarController *)[self parentViewController];
}

- (RDVTabBarItem *)rdv_tabBarItem {
    RDVTabBarController *tabBarController = [self rdv_tabBarController];
    NSInteger index = [tabBarController indexForViewController:self];
    return [[[tabBarController tabBar] items] objectAtIndex:index];
}

- (void)rdv_setTabBarItem:(RDVTabBarItem *)tabBarItem {
    RDVTabBarController *tabBarController = [self rdv_tabBarController];
    
    if (!tabBarController) {
        return;
    }
    
    RDVTabBar *tabBar = [tabBarController tabBar];
    NSInteger index = [tabBarController indexForViewController:self];
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] initWithArray:[tabBar items]];
    [tabBarItems replaceObjectAtIndex:index withObject:tabBarItem];
    [tabBar setItems:tabBarItems];
}

@end
