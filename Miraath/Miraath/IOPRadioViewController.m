//
//  IOPRadioViewController.m
//  Miraath
//
//  Created by Jonathan Flintham on 18/04/2013.
//  Copyright (c) 2013 Jonathan Flintham. All rights reserved.
//

#import "IOPRadioViewController.h"
#import "UIColor+Extension.h"

@interface IOPRadioViewController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *buttonImageView;
@property (nonatomic, assign) BOOL shouldResumeAfterInterruption;
@property (nonatomic, strong) UILabel *trackTitleLabel;
@property (nonatomic, strong) UILabel *radioStationLabel;
@property (nonatomic, strong) MPVolumeView *volumeView;

@end

@implementation IOPRadioViewController




- (void)dealloc
{
    if (FW_isIOS6())
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];

    [self.player removeObserver:self forKeyPath:@"status" context:nil];

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

	CGRect theFrame = self.view.bounds;
	self.defaultBackgroundImageView = [[UIImageView alloc] initWithFrame:theFrame];
	self.defaultBackgroundImageView.userInteractionEnabled = YES;
	
	[self.view insertSubview:self.defaultBackgroundImageView belowSubview:self.view];
	
	self.buttonImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	UIImage *buttonImage = [UIImage imageNamed:@"radio_player_button.png"];
	self.buttonImageView.image = buttonImage;
	self.buttonImageView.frame =  CGRectMake(0.0f, 0.0f, buttonImage.size.width, buttonImage.size.height);
	self.buttonImageView.alpha = 0.0f;
	self.buttonImageView.userInteractionEnabled = YES;

	[self.view addSubview:self.buttonImageView];
	
	//Add the volume slider
    //self.volumeView = [[MPVolumeView alloc] initWithFrame:self.view.bounds];
	self.volumeView = [[MPVolumeView alloc] initWithFrame:CGRectZero];
	//[self.volumeView sizeToFit];
	
	for (UIView *view in self.volumeView.subviews){
		if ([view isKindOfClass:[UISlider class]]) {
			((UISlider *) view).minimumTrackTintColor = [UIColor peachTextColor];
			((UISlider *) view).maximumTrackTintColor = [UIColor offWhiteTextColor];
		}
	}
	
    [self.view addSubview:self.volumeView];

    //Add the button
	self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"radio_player_play.png"];
    [self.button setBackgroundImage:image forState:UIControlStateNormal];
    self.button.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
	self.button.backgroundColor = [UIColor clearColor];
    [self.button addTarget:self action:@selector(togglePlayPause:) forControlEvents:UIControlEventTouchUpInside];
	self.button.adjustsImageWhenHighlighted = NO;
	[self.view addSubview:self.button];
	
	//Add Radio Station Label
	
	
	self.radioStationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	self.radioStationLabel.backgroundColor = [UIColor clearColor];
	self.radioStationLabel.textColor = [UIColor peachTextColor];
	self.radioStationLabel.shadowColor = [UIColor darkTextColor];
	self.radioStationLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
	self.radioStationLabel.textAlignment = NSTextAlignmentCenter;
	self.radioStationLabel.text = [NSString stringWithFormat:@"Miraath %@", [self.channelInfo objectForKey:@"title"]];
	
	self.radioStationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
	self.radioStationLabel.adjustsFontSizeToFitWidth = YES;
	
	[self.view addSubview:self.radioStationLabel];
	
	//Add the track title label
	self.trackTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	self.trackTitleLabel.backgroundColor = [UIColor clearColor];
	self.trackTitleLabel.textColor = [UIColor offWhiteTextColor];
	self.trackTitleLabel.shadowColor = [UIColor blackColor];
	self.trackTitleLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
	self.trackTitleLabel.textAlignment = NSTextAlignmentCenter;
	self.trackTitleLabel.numberOfLines = 2;
	self.trackTitleLabel.lineBreakMode = UILineBreakModeWordWrap;
	
	
	self.trackTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f];
	self.trackTitleLabel.adjustsFontSizeToFitWidth = YES;
	
	[self.view addSubview:self.trackTitleLabel];
	
	
	
	
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
	self.button.center = CGPointMake(self.view.bounds.size.width / 2.0f, self.view.bounds.size.height / 2.0f);

	self.buttonImageView.center = CGPointMake(self.view.bounds.size.width / 2.0f, self.view.bounds.size.height / 2.0f);

	self.radioStationLabel.frame = CGRectMake(10.0f, 80.0f, self.view.bounds.size.width - 20.0f, 50.0f);
	
	self.trackTitleLabel.frame = CGRectMake(10.0f, 10.0f, self.view.bounds.size.width - 20.0f, 70.0f);
	
	BOOL isIPhone5 = self.view.window.frame.size.height == 568.0f;
	self.defaultBackgroundImageView.image = [UIImage imageNamed:isIPhone5 ? @"black_bg-568h.png" : @"black_bg.png"];
	

	self.volumeView.frame = CGRectMake(10.0f, self.view.bounds.size.height - 100.0f, self.view.bounds.size.width - 20.0f, 50.0f);
	
	
	self.defaultBackgroundImageView.frame =  CGRectMake(0.0f, -20.0f, self.view.window.bounds.size.width, self.view.window.bounds.size.height + 20.0f);
	
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self.channelInfo objectForKey:@"trackTitleUrl"]]];
	[request setValue:@"Mozilla/1.0 SHOUTcast example" forHTTPHeaderField:@"user-agent"];
	// Create url connection and fire request
	NSURLConnection *conn = [[NSURLConnection alloc] init];
	(void)[conn initWithRequest:request delegate:self];
	
    [self initialiseAudio];
	
	self.trackTitleLabel.alpha = 0.0f;
	self.radioStationLabel.alpha = 0.0f;
	self.volumeView.alpha = 0.0f;
	
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
	[self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
	//[self.player play];
	
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

#pragma mark - AVAudioSessionDelegate


//iOS 5
- (void)beginInterruption
{
    if (FW_isIOS6())
		return;
	if(self.player.rate == 0.0f)
	{
		NSLog(@"Rate equals zero");
		self.shouldResumeAfterInterruption = NO;
	}else{
		NSLog(@"Rate NOT zero");
		self.shouldResumeAfterInterruption = YES;
	}
	
}


//iOS 5
- (void)endInterruptionWithFlags:(NSUInteger)flags
{
    if (FW_isIOS6())
		return;
	NSLog(@"Resume Flag = %d", self.shouldResumeAfterInterruption);
	if (flags == AVAudioSessionInterruptionFlags_ShouldResume && self.shouldResumeAfterInterruption)
        [self.player play];
}
//iOS 6
- (void)audioSessionInterruption:(NSNotification *)notification
{
    AVAudioSessionInterruptionType interruptionType = [[[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey] integerValue];
    NSLog(@"interruptionType = %i", interruptionType);
	/*if(interruptionType == AVAudioSessionInterruptionTypeBegan)
	{
		if(self.player.rate == 0.0f)
		{
			NSLog(@"Rate equals zero");
			self.shouldResumeAfterInterruption = NO;
		}else{
			NSLog(@"Rate NOT zero");
			self.shouldResumeAfterInterruption = YES;
		}
	}*/
	if (interruptionType == AVAudioSessionInterruptionTypeEnded) {
        AVAudioSessionInterruptionOptions option = [[[notification userInfo] objectForKey:AVAudioSessionInterruptionOptionKey] integerValue];
        if (option == AVAudioSessionInterruptionOptionShouldResume)
            [self.player play];
    }
}

#pragma mark - RemoveControlEvents

- (void)togglePlayPause:(id)sender
{
	__block UIImage *image = nil;
	CGFloat animationDuration = .5f;
    if (self.player.rate == 0.0f){
		[UIView animateWithDuration:animationDuration
						 animations:^{
							 self.button.alpha = 0.0f;
							 self.buttonImageView.alpha = 1.0f;
						 }
						 completion:^(BOOL finished) {
							 [UIView animateWithDuration:animationDuration animations:^{
								 image = [UIImage imageNamed:@"radio_player_pause.png"];
								 [self.button setBackgroundImage:image forState:UIControlStateNormal];
								 self.button.alpha = 1.0f;
								 self.buttonImageView.alpha = .0f;
							 }];
						 }
		 ];

		[self.player play];
    }else{
		[UIView animateWithDuration:animationDuration
						 animations:^{
							 self.button.alpha = 0.0f;
							 self.buttonImageView.alpha = 1.0f;
						 }
						 completion:^(BOOL finished) {
							 [UIView animateWithDuration:animationDuration animations:^{
								 image = [UIImage imageNamed:@"radio_player_play.png"];
								 [self.button setBackgroundImage:image forState:UIControlStateNormal];
								 self.button.alpha = 1.0f;
								 self.buttonImageView.alpha = .0f;
							 }];
						 }
		 ];
		
        [self.player pause];
	}
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"Player ststus is Ready to Play");
        } else if (self.player.status == AVPlayerStatusFailed) {
            NSLog(@"Player ststus is FAILED");
        }
    }
}


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    //_responseData = [[NSMutableData alloc] init];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self extractTrackTitle:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"connectionDidFinishLoading");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
	NSLog(@"An Error occurred: @%", error.description);
}


- (void)extractTrackTitle:(NSData *)data {
    //NSString *metadata = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

	NSString *myStr = [[NSString alloc] initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingWindowsArabic) ];
	myStr = [myStr stringByReplacingOccurrencesOfString:@"encoding=\"windows-1256\"" withString:@""];
	NSData* newData = [myStr dataUsingEncoding:NSUTF8StringEncoding];
	
	NSString *metadata = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
	
	NSLog(@"Data: %@", metadata);
	
	int index = ([metadata rangeOfString:@"<body>"].location + 1);
	
	//Now let’s remove the first part of the junk.
	metadata = [metadata substringFromIndex:index];
	
	//Now let’s remove the rest of the HTML tags. We have to know where the body tag is closed.
	index = [metadata rangeOfString:@"</body>"].location;
	
	//Now we need to remove the rest of the tags.
	metadata = [metadata substringToIndex:index];
    
	NSArray *metadataComponents = [metadata componentsSeparatedByString:@","];

	self.trackTitleLabel.text = [metadataComponents lastObject];
	NSLog(@"Track Title: %@", self.trackTitleLabel.text);

	[UIView animateWithDuration:.75f
					 animations:^{
						self.trackTitleLabel.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {
						 [UIView animateWithDuration:1.5f animations:^{
							self.radioStationLabel.alpha = 1.0f;
						 }completion:^(BOOL finished) {
							 [UIView animateWithDuration:1.5f animations:^{
								 self.volumeView.alpha = 1.0f;
							 }];
						 }];
					 }
	 ];
	
	
	
	
}


@end
