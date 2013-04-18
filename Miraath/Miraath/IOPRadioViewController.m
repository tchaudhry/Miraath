//
//  IOPRadioViewController.m
//  Miraath
//
//  Created by Jonathan Flintham on 18/04/2013.
//  Copyright (c) 2013 Jonathan Flintham. All rights reserved.
//

#import "IOPRadioViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface IOPRadioViewController ()

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation IOPRadioViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initialiseAudio];
}

- (void)initialiseAudio
{
    NSString *urlString = [self.channelInfo objectForKey:@"url"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    self.player = [[AVPlayer alloc] initWithURL:url];
    [self.player play];
}

@end
