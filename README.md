# RDVTabBarController

RDVTabbarController can be used inside UINavigationController and is highly customizable.

![Current status](https://raw.github.com/robbdimitrov/RDVTabBarController/master/Screenshots/iPad.png)

![Current status](https://raw.github.com/robbdimitrov/RDVTabBarController/master/Screenshots/iPhone.png)

* UIButton tabBarItems
* Supports iPad and iPhone
* Supports landscape and portrait orientations

## Setup

Add the items from `RDVTabBarController` directory to your project. If you don't have ARC enabled, you will need to set a `-fobjc-arc` compiler flag on the `.m` source files.

## Example Usage

Initialize RDVTabBarController:

``` objective-c
UIViewController *firstViewController = [[RDVFirstViewController alloc] initWithNibName:nil bundle:nil];
UIViewController *firstNavigationController = [[UINavigationController alloc] initWithRootViewController:firstViewController];

UIViewController *secondViewController = [[RDVSecondViewController alloc] initWithNibName:nil bundle:nil];
UIViewController *secondNavigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];

UIViewController *thirdViewController = [[RDVThirdViewController alloc] initWithNibName:nil bundle:nil];
UIViewController *thirdNavigationController = [[UINavigationController alloc] initWithRootViewController:thirdViewController];

RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
[tabBarController setViewControllers:@[firstNavigationController, secondNavigationController, thirdNavigationController]];
self.viewController = tabBarController;
```

Customize RDVTabBarController:

``` objective-c
UIImage *finishedImage = [[UIImage imageNamed:@"tabbar_selected_background"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
UIImage *unfinishedImage = [[UIImage imageNamed:@"tabbar_unselected_background"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
    
RDVTabBar *tabBar = [tabBarController tabBar];

[tabBar setFrame:CGRectMake(CGRectGetMinX(tabBar.frame), CGRectGetMinY(tabBar.frame), CGRectGetWidth(tabBar.frame), 63)];
for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
    [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
    UIImage *image = [UIImage imageNamed:@"first"];
    [item setFinishedSelectedImage:image withFinishedUnselectedImage:image];
}
```

## Requirements

* ARC
* iOS 5.0 or later

## Contact

[Robert Dimitrov](http://github.com/robbdimitrov)  
[@robbdimitrov](https://twitter.com/robbdimitrov)

## License

RDVTabBarController is available under the MIT license. See the LICENSE file for more info.
