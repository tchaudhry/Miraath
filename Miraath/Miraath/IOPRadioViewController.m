//
//  IOPRadioViewController.m
//  Miraath
//
//  Created by Jonathan Flintham on 18/04/2013.
//  Copyright (c) 2013 Jonathan Flintham. All rights reserved.
//

#import "IOPRadioViewController.h"

@interface IOPRadioViewController ()

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation IOPRadioViewController

- (void)dealloc
{
    if (FW_isIOS6())
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *error = nil;
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
        [audioSession setActive:YES error:&error];
        if (error)
            NSLog(@"Failed to create audio session: %@", [error localizedDescription]);
        
        if (FW_isIOS5())
            audioSession.delegate = self;
        
        if (FW_isIOS6())
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruption:) name:AVAudioSessionInterruptionNotification object:audioSession];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:volumeView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(50.0f, 200.0f, 200.0f, 50.0f);
    [button addTarget:self action:@selector(togglePlayPause:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Play/Pause" forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self resignFirstResponder];
}

- (void)initialiseAudio
{
    NSString *urlString = [self.channelInfo objectForKey:@"url"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    self.player = [[AVPlayer alloc] initWithURL:url];
    [self.player play];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

#pragma mark - AVAudioSessionDelegate

- (void)endInterruptionWithFlags:(NSUInteger)flags
{
    if (flags == AVAudioSessionInterruptionFlags_ShouldResume)
        [self.player play];
}

- (void)audioSessionInterruption:(NSNotification *)notification
{
    AVAudioSessionInterruptionType interruptionType = [[[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey] integerValue];
    if (interruptionType == AVAudioSessionInterruptionTypeEnded) {
        AVAudioSessionInterruptionOptions option = [[[notification userInfo] objectForKey:AVAudioSessionInterruptionOptionKey] integerValue];
        if (option == AVAudioSessionInterruptionOptionShouldResume)
            [self.player play];
    }
}

#pragma mark - RemoveControlEvents

- (void)togglePlayPause:(id)sender
{
    if (self.player.rate == 0.0f)
        [self.player play];
    else
        [self.player pause];
}

- (BOOL)canBecomeFirstResponder {

    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self togglePlayPause:nil];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                //[self previousTrack: nil];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                //[self nextTrack: nil];
                break;
                
            default:
                break;
        }
    }
}

@end
