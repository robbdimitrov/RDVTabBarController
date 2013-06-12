// RDVAppDelegate.m
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

#import "RDVAppDelegate.h"
#import "RDVFirstViewController.h"
#import "RDVSecondViewController.h"
#import "RDVThirdViewController.h"
#import "RDVTabBarController.h"

@implementation RDVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupViewControllers];
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - Methods

- (void)setupViewControllers {
    UIViewController *firstViewController = [[RDVFirstViewController alloc] initWithNibName:nil bundle:nil];
    UIViewController *firstNavigationController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    
    UIViewController *secondViewController = [[RDVSecondViewController alloc] initWithNibName:nil bundle:nil];
    UIViewController *secondNavigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    
    UIViewController *thirdViewController = [[RDVThirdViewController alloc] initWithNibName:nil bundle:nil];
    UIViewController *thirdNavigationController = [[UINavigationController alloc] initWithRootViewController:thirdViewController];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController, thirdNavigationController]];
    self.viewController = tabBarController;
    
    [self customizeTabBarForController:tabBarController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    UIImage *finishedImage = [[UIImage imageNamed:@"tabbar_selected_background"]
                              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
    UIImage *unfinishedImage = [[UIImage imageNamed:@"tabbar_unselected_background"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
    [tabBarController setTabBarHeight:63];
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *image = [UIImage imageNamed:@"first"];
        [item setFinishedSelectedImage:image withFinishedUnselectedImage:image];
    }
}

@end
