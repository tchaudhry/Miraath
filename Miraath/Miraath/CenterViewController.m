//
//  CenterViewController.m
//  SlideOutMenuContainerViewControllerExample
//
//  Created by Sam Watts on 25/03/2013.
//  Copyright (c) 2013 Sam Watts. All rights reserved.
//

#import "CenterViewController.h"

@interface CenterViewController ()

@end

@implementation CenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Menu", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
    self.navigationItem.leftBarButtonItem = menuButton;
}

- (void)showMenu
{
    [self.containerViewController toggleMenuViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController{
	
	[self.navigationController setViewControllers:@[viewController] animated:YES];
}

@end
