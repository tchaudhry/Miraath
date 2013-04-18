//
//  CenterViewController.m
//  SlideOutMenuContainerViewControllerExample
//
//  Created by Sam Watts on 25/03/2013.
//  Copyright (c) 2013 Sam Watts. All rights reserved.
//

#import "CenterViewController.h"

@interface CenterViewController ()

@property (nonatomic, strong) UIBarButtonItem *menuButton;

@end

@implementation CenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.menuButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Menu", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
}

- (void)showMenu
{
    [self.containerViewController toggleMenuViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController
{
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
	if ([viewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)viewController viewControllers] count] > 0) {
        
        UINavigationController *nc = (UINavigationController *)viewController;
        UIViewController *rootVC = nc.viewControllers[0];
        rootVC.navigationItem.leftBarButtonItem = self.menuButton;
    }
}

@end
