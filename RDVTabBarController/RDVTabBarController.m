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

@end

@implementation RDVTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tabBarHeight = 49;
        _selectedIndex = 0;
    }
    return self;
}

- (id)init {
    return [self initWithNibName:nil bundle:nil];
}

#pragma mark - View lifecycle

- (void)loadView {
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    UIView *view = [[UIView alloc] initWithFrame:applicationFrame];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    [view addSubview:self.tabBar];
    
    self.view = view;
}

- (void)viewWillLayoutSubviews {
    [[self.selectedViewController view] setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarHeight)];
    [self.tabBar setFrame:CGRectMake(0, self.view.frame.size.height - self.tabBarHeight, self.view.frame.size.width, self.tabBarHeight)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setSelectedViewController:[self viewControllers][[self selectedIndex]]];
    [self addChildViewController:[self selectedViewController]];
    [[self view] addSubview:[[self selectedViewController] view]];
    [[self tabBar] setSelectedItem:[[[self tabBar] items] objectAtIndex:0]];
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

- (UIViewController *)selectedViewController {
    return [[self viewControllers] objectAtIndex:[self selectedIndex]];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = [viewControllers copy];
        
        NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
        
        for (UIViewController *viewController in viewControllers) {
            RDVTabBarItem *tabBarItem = [[RDVTabBarItem alloc] init];
            [tabBarItem setTitle:viewController.title];
            [tabBarItems addObject:tabBarItem];
        }
        
        [[self tabBar] setItems:tabBarItems];
    } else {
        _viewControllers = nil;
    }
}

- (RDVTabBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[RDVTabBar alloc] init];
        [_tabBar setBackgroundColor:[UIColor blackColor]];
        [_tabBar setDelegate:self];
    }
    
    return _tabBar;
}

- (NSInteger)indexForViewController:(UIViewController *)viewController {
    UIViewController *searchedController = viewController;
    if ([self navigationController]) {
        searchedController = [viewController navigationController];
    }
    return [[self viewControllers] indexOfObject:searchedController];
}

#pragma mark - RDVTabBarDelegate

- (BOOL)tabBar:(RDVTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {
    return YES;
}

- (void)tabBar:(RDVTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    if (index < 0 || index >= [[self viewControllers] count]) {
        return;
    }
    
    if ([self selectedViewController]) {
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    
    [self setSelectedIndex:index];
    [self setSelectedViewController:[self viewControllers][index]];
    [self addChildViewController:[self selectedViewController]];
    [[self view] addSubview:[[self selectedViewController] view]];
}

@end

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

- (void)rdv_setTabBarItem:(RDVTabBarItem *)rdv_tabBarItem {
    
}

@end
