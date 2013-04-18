//
//  SlideOutMenuContainerViewController.h
//  SlideOutMenuContainerViewControllerExample
//
//  Created by Sam Watts on 25/03/2013.
//  Copyright (c) 2013 Sam Watts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+SlideMenu.h"

@protocol SlideOutMenuContainerViewControllerDelegate <NSObject>
- (void)pushViewController:(UIViewController *)viewController;
@end


@interface SlideOutMenuContainerViewController : UIViewController


- (id)initWithMenuViewController:(UIViewController *)menuViewController andCenterViewController:(UIViewController *)centerViewController;

- (void)presentMenuViewControllerAnimated:(BOOL)animated;
- (void)dismissMenuViewControllerAnimated:(BOOL)animated;

- (void)dismissMenuViewController:(BOOL)animated andPresentViewController:(UIViewController *)viewController;

- (void)toggleMenuViewControllerAnimated:(BOOL)animated;

@property (nonatomic, strong) id <SlideOutMenuContainerViewControllerDelegate> containerDelegate;

@end
