//
//  SlideOutMenuContainerViewController.m
//  SlideOutMenuContainerViewControllerExample
//
//  Created by Sam Watts on 25/03/2013.
//  Copyright (c) 2013 Sam Watts. All rights reserved.
//

#import "SlideOutMenuContainerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SlideOutMenuContainerViewController () {
    BOOL _menuVisible;
	CGFloat _xStart;
	CGFloat _centerStartX;
}

@property (nonatomic, strong) UIViewController *menuViewController;
@property (nonatomic, strong) UIViewController *centerViewController;

@end

@implementation SlideOutMenuContainerViewController

- (id)initWithMenuViewController:(UIViewController *)menuViewController andCenterViewController:(UIViewController *)centerViewController
{
    self = [super init];
    if (self)
    {
        _menuViewController = menuViewController;
        _centerViewController = centerViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor blackColor];
    
    self.centerViewController.view.frame = self.view.bounds;
    
    [self addChildViewController:self.centerViewController];
    [self.centerViewController willMoveToParentViewController:self];
    [self.view addSubview:self.centerViewController.view];
    [self.centerViewController didMoveToParentViewController:self];
	
	[self addChildViewController:self.menuViewController];
	[self.menuViewController willMoveToParentViewController:self];
	[self.view addSubview:self.menuViewController.view];
	[self.view sendSubviewToBack:self.menuViewController.view];
	[self.menuViewController didMoveToParentViewController:self];
    
    self.centerViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.centerViewController.view.layer.shadowOffset = CGSizeMake(-2.0f, 0.0f);
    self.centerViewController.view.layer.shadowRadius = 2.0f;
    self.centerViewController.view.layer.shadowOpacity = 0.8f;

	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(centrePanGestureRecognizer:)];
	[self.centerViewController.view addGestureRecognizer:panGestureRecognizer];
	
}


- (void)hideMenuControllerWithAnimationDuration:(CGFloat) duration
{
    //DLog(@"Duration is: %f", duration);
	[UIView animateWithDuration:duration animations:^{
        
        self.centerViewController.view.frame = CGRectOffset(self.view.bounds, -15.0f, 0.0f);
        self.centerViewController.view.alpha = 1.0f;
        self.menuViewController.view.transform = CGAffineTransformMakeScale(0.95f, 0.85f);
        self.menuViewController.view.alpha = 0.8f;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.4f animations:^{
            self.centerViewController.view.frame = CGRectOffset(self.view.bounds, 3.0f, 0.0f);
        }completion:^(BOOL finished2) {
            [UIView animateWithDuration:0.2f animations:^{
                self.centerViewController.view.frame = self.view.bounds;
            }completion:^(BOOL finished3) {
                //                [self.menuViewController removeFromParentViewController];
                //                [self.menuViewController willMoveToParentViewController:nil];
                //                [self.menuViewController.view removeFromSuperview];
                //                [self.menuViewController didMoveToParentViewController:nil];
                
                self.menuViewController.view.transform = CGAffineTransformIdentity;
                
                _menuVisible = NO;
            }];
        }];
    }];
}

- (void)showMenuControllerWithAnimationDuration:(CGFloat) duration
{
	//DLog(@"Duration is: %f", duration);
	[UIView animateWithDuration:duration  animations:^{
        
        self.centerViewController.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.size.width * 0.95f, 0.0f);
        self.centerViewController.view.alpha = 0.8f;
        self.menuViewController.view.transform = CGAffineTransformIdentity;
        self.menuViewController.view.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{
            self.centerViewController.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.size.width * 0.9f, 0.0f);
        }completion:^(BOOL finished2) {
            
        }];
        _menuVisible = YES;
    }];
}

- (void) centrePanGestureRecognizer:(UIPanGestureRecognizer *) panGestureRecognizer
{
	CGPoint locationOfDrag = [panGestureRecognizer locationInView:self.view];
	if(panGestureRecognizer.state == UIGestureRecognizerStateBegan)
	{
		self.menuViewController.view.frame = self.view.bounds;
		self.menuViewController.view.transform = CGAffineTransformMakeScale(0.95f, 0.85f);
		self.menuViewController.view.alpha = 0.25f;
		
		
		
		_xStart = locationOfDrag.x;
		_centerStartX = self.centerViewController.view.frame.origin.x;
		CGFloat xPercentageDragged = self.centerViewController.view.frame.origin.x / (self.view.bounds.size.width * .9f);
		self.menuViewController.view.alpha = 0.25f + (0.75 * xPercentageDragged);
		self.menuViewController.view.transform = CGAffineTransformMakeScale(.95f + (.05f * xPercentageDragged), 0.85 + (0.15 * xPercentageDragged));
	
		
		
	}
	else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
	{
		CGFloat xDelta = locationOfDrag.x - _xStart;
		//DLog(@"Delta:  %f", xDelta);
		CGRect centreFrame = CGRectOffset(self.view.bounds, xDelta + _centerStartX, .0f);
		if (centreFrame.origin.x < 0.0f)
			centreFrame.origin.x = 0.0f;
		self.centerViewController.view.frame = centreFrame;
		
//		NSLog(@"move center: %f", xDelta - _centerStartX);
//		NSLog(@"start: %f", _centerStartX);
		
		CGFloat xPercentageDragged = self.centerViewController.view.frame.origin.x / (self.view.bounds.size.width * .9f);
//		DLog(@"Percentage Dragged:  %f", xPercentageDragged);
		self.menuViewController.view.alpha = 0.25f + (0.75 * xPercentageDragged);
		self.menuViewController.view.transform = CGAffineTransformMakeScale(.95f + (.05f * xPercentageDragged), 0.85 + (0.15 * xPercentageDragged));
		
	}
	else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
	{
		//BOOL dismissMenu = self.centerViewController.view.frame.origin.x < CGRectGetMidX(self.view.bounds);
		
		CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
		NSLog(@"velocity: %@", NSStringFromCGPoint(velocity));
		
		if(self.centerViewController.view.frame.origin.x < (self.view.frame.size.width * 0.15))
		{
			[self hideMenuControllerWithAnimationDuration: fabsf(self.centerViewController.view.frame.origin.x/ velocity.x)];
		}
		else if (self.centerViewController.view.frame.origin.x > (self.view.frame.size.width * 0.85))
		{
			[self showMenuControllerWithAnimationDuration:fabsf((self.view.frame.size.width - self.centerViewController.view.frame.origin.x) / velocity.x)];
		}else{
			if(velocity.x < 0){
				NSLog(@"%f", velocity.x);
				NSLog(@"%f", self.centerViewController.view.frame.origin.x);
				CGFloat duration = self.centerViewController.view.frame.origin.x / velocity.x;
				NSLog(@"%f", duration);
				[self hideMenuControllerWithAnimationDuration: fabsf(duration)];
			}else{
				[self showMenuControllerWithAnimationDuration:fabsf((self.view.frame.size.width - self.centerViewController.view.frame.origin.x) / velocity.x)];
			}
		}
		
	}
}


- (void)presentMenuViewControllerAnimated:(BOOL)animated
{
    self.menuViewController.view.frame = self.view.bounds;
    self.menuViewController.view.transform = CGAffineTransformMakeScale(0.95f, 0.85f);
    self.menuViewController.view.alpha = 0.25f;
    
    [self addChildViewController:self.menuViewController];
    [self.menuViewController willMoveToParentViewController:self];
    [self.view addSubview:self.menuViewController.view];
    [self.view sendSubviewToBack:self.menuViewController.view];
    [self.menuViewController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:animated ? 0.4f : 0.0f animations:^{
        
        self.centerViewController.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.size.width * 0.95f, 0.0f);
		self.centerViewController.view.alpha = 0.8f;
        self.menuViewController.view.transform = CGAffineTransformIdentity;
        self.menuViewController.view.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{
            self.centerViewController.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.size.width * 0.9f, 0.0f);
        }completion:^(BOOL finished2) {
		
		}];
        _menuVisible = YES;
    }];
}

- (void)toggleMenuViewControllerAnimated:(BOOL)animated
{
    if (_menuVisible)
        [self dismissMenuViewControllerAnimated:animated];
    else
        [self presentMenuViewControllerAnimated:animated];
}

- (void)dismissMenuViewControllerAnimated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? 0.3f : 0.0f animations:^{
        
        self.centerViewController.view.frame = CGRectOffset(self.view.bounds, -15.0f, 0.0f);
		self.centerViewController.view.alpha = 1.0f;
        self.menuViewController.view.transform = CGAffineTransformMakeScale(0.95f, 0.85f);
        self.menuViewController.view.alpha = 0.8f;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.4f animations:^{
            self.centerViewController.view.frame = CGRectOffset(self.view.bounds, 3.0f, 0.0f);
        }completion:^(BOOL finished2) {
            [UIView animateWithDuration:0.2f animations:^{
                self.centerViewController.view.frame = self.view.bounds;
            }completion:^(BOOL finished3) {
//                [self.menuViewController removeFromParentViewController];
//                [self.menuViewController willMoveToParentViewController:nil];
//                [self.menuViewController.view removeFromSuperview];
//                [self.menuViewController didMoveToParentViewController:nil];
                
                self.menuViewController.view.transform = CGAffineTransformIdentity;
                
                _menuVisible = NO;
            }];
        }];
    }];
}




- (void)dismissMenuViewController:(BOOL)animated andPresentViewController:(UIViewController *)viewController;
{
	[self dismissMenuViewControllerAnimated:animated];
	[self.containerDelegate pushViewController:viewController];
	//[self.centerViewController.navigationController pushViewController:viewController animated:YES];
}









@end
