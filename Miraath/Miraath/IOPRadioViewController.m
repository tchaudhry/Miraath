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
@property (nonatomic, strong) UIButton *pauseButton;
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
        
        //if (FW_isIOS6()){
            //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruption:) name:AVAudioSessionInterruptionNotification object:audioSession];
			//audioSession.delegate = self;
		//}
		//else
			audioSession.delegate = self;
		
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
			((UISlider *) view).maximumTrackTintColor = [UIColor clearColor];
		}
	}
	
    [self.view addSubview:self.volumeView];

    //Add the play button
	self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"radio_player_play.png"];
    [self.button setBackgroundImage:image forState:UIControlStateNormal];
    self.button.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
	self.button.backgroundColor = [UIColor clearColor];
    [self.button addTarget:self action:@selector(togglePlayPause:) forControlEvents:UIControlEventTouchUpInside];
	self.button.adjustsImageWhenHighlighted = NO;
	self.button.tag = 101;
	[self.view addSubview:self.button];

	
    //Add the button
	self.pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *pauseImage = [UIImage imageNamed:@"radio_player_pause.png"];
    [self.pauseButton setBackgroundImage:pauseImage forState:UIControlStateNormal];
    self.pauseButton.frame = CGRectMake(0.0f, 0.0f, pauseImage.size.width, pauseImage.size.height);
	self.pauseButton.backgroundColor = [UIColor clearColor];
    [self.pauseButton addTarget:self action:@selector(togglePlayPause:) forControlEvents:UIControlEventTouchUpInside];
	self.pauseButton.adjustsImageWhenHighlighted = NO;
	self.pauseButton.alpha = 0.0f;
	[self.view addSubview:self.pauseButton];
	
	
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
	self.trackTitleLabel.numberOfLines = 3;
	self.trackTitleLabel.lineBreakMode = UILineBreakModeWordWrap;
	
	self.trackTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f];
	//self.trackTitleLabel.adjustsFontSizeToFitWidth = YES;
	
	[self.view addSubview:self.trackTitleLabel];
	
	
	
	
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
	self.button.center = CGPointMake(self.view.bounds.size.width / 2.0f, self.view.bounds.size.height / 2.0f);
	self.pauseButton.center = CGPointMake(self.view.bounds.size.width / 2.0f, self.view.bounds.size.height / 2.0f);
	
	self.buttonImageView.center = CGPointMake(self.view.bounds.size.width / 2.0f, self.view.bounds.size.height / 2.0f);

	self.radioStationLabel.frame = CGRectMake(10.0f, 80.0f, self.view.bounds.size.width - 20.0f, 50.0f);
	
	self.trackTitleLabel.frame = CGRectMake(15.0f, 10.0f, self.view.bounds.size.width - 30.0f, 80.0f);
	
	BOOL isIPhone5 = self.view.window.frame.size.height == 568.0f;
	self.defaultBackgroundImageView.image = [UIImage imageNamed:isIPhone5 ? @"black_bg-568h.png" : @"black_bg.png"];
	

	self.volumeView.frame = CGRectMake(20.0f, self.view.bounds.size.height - 100.0f, self.view.bounds.size.width - 40.0f, 50.0f);
	
	
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
	if(self.player.rate == 0.0f)
	{
		NSLog(@"Rate equals zero");
		self.shouldResumeAfterInterruption = NO;
	}else{
		NSLog(@"Rate NOT zero");
		self.shouldResumeAfterInterruption = YES;
	}
}



- (void)endInterruptionWithFlags:(NSUInteger)flags
{
	
	if(flags == AVAudioSessionInterruptionFlags_ShouldResume && self.shouldResumeAfterInterruption)
		[self.player play];
		
}
//iOS 6 - This is a bit flaky.
- (void)audioSessionInterruption:(NSNotification *)notification
{
    AVAudioSessionInterruptionType interruptionType = [[[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey] integerValue];
    NSLog(@"interruptionType = %i", interruptionType);
	if(interruptionType == AVAudioSessionInterruptionTypeBegan)
	{
		if(self.player.rate == 0.0f)
		{
			NSLog(@"Rate equals zero");
			self.shouldResumeAfterInterruption = NO;
		}else{
			NSLog(@"Rate NOT zero");
			self.shouldResumeAfterInterruption = YES;
			[self.player pause];
		}
	}
	if (interruptionType == AVAudioSessionInterruptionTypeEnded) {
        AVAudioSessionInterruptionOptions option = [[[notification userInfo] objectForKey:AVAudioSessionInterruptionOptionKey] integerValue];
		NSLog(@"option = %i", option);
        if (option == AVAudioSessionInterruptionOptionShouldResume){
            [self.player play];
			NSLog(@"Player did play in notification");
		}
    }
}

#pragma mark - RemoveControlEvents

- (void)togglePlayPause:(id)sender
{
	__block UIImage *image = nil;
	CGFloat animationDuration = .5f;
    if (self.player.rate == 0.0f){
		[UIView transitionWithView:self.button
						  duration:animationDuration
						   options:UIViewAnimationOptionTransitionFlipFromLeft
						animations:^{
							image = [UIImage imageNamed:@"radio_player_pause.png"];
							[self.button setBackgroundImage:image forState:UIControlStateNormal];
						}
						completion:^(BOOL finished) {
							[UIView animateWithDuration:animationDuration animations:^{
								self.volumeView.alpha = 1.0f;
							}];
						}
		 ];
		[self.player play];
		NSArray *meta = [self.player currentItem].timedMetadata;
		NSLog(@"%@", meta.description);
		[[self.player currentItem] addObserver:self forKeyPath:@"timedMetadata" options:NSKeyValueObservingOptionNew   context:NULL];
		
    }else{
		[UIView transitionWithView:self.button
						  duration:animationDuration
						   options:UIViewAnimationOptionTransitionFlipFromRight
						animations:^{
							image = [UIImage imageNamed:@"radio_player_play.png"];
							[self.button setBackgroundImage:image forState:UIControlStateNormal];
							self.volumeView.alpha = 0.0f;
						}
						completion:^(BOOL finished) {
							[UIView animateWithDuration:animationDuration animations:^{
								
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
            NSLog(@"Player status is Ready to Play");
        } else if (self.player.status == AVPlayerStatusFailed) {
            NSLog(@"Player ststus is FAILED");
        }
    }
	
	if ([keyPath isEqualToString:@"timedMetadata"])
	{
		AVPlayerItem *playerItem = [self.player currentItem];
		
		for (AVMetadataItem* metadata in playerItem.timedMetadata)
		{
			
#warning Check the title when you localise the application
			NSString *title = metadata.stringValue;
			if([[self.channelInfo objectForKey:@"title"] isEqualToString:@"Arabic"] || [[self.channelInfo objectForKey:@"title"] isEqualToString:@"Quran"]){
				NSLog(@"\nkey: %@\nkeySpace: %@\ncommonKey: %@\nvalue: %@", [metadata.key description], metadata.keySpace, metadata.commonKey, metadata.stringValue);
				
				NSData *data = [title dataUsingEncoding:NSWindowsCP1252StringEncoding];
				NSString *dataString = [[NSString alloc] initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingWindowsArabic) ];
				NSData* newData = [dataString dataUsingEncoding:NSUTF16StringEncoding];
				NSString *titleString = [[NSString alloc] initWithData:newData encoding:NSUTF16StringEncoding];
				
				
				title = [titleString stringByReplacingOccurrencesOfString:@"_" withString:@" "];
				NSLog(@"%@", title);
			}
			[self updateTrackTitle:title animated:YES];
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
	//NSLog(@"An Error occurred: @%", error.description);
	NSLog(@"A connection error occurred!!!");
}


- (void)extractTrackTitle:(NSData *)data {
    //NSString *metadata = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

	NSString *myStr = [[NSString alloc] initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingWindowsArabic) ];
	myStr = [myStr stringByReplacingOccurrencesOfString:@"encoding=\"windows-1256\"" withString:@""];
	NSData* newData = [myStr dataUsingEncoding:NSUTF8StringEncoding];
	
	NSString *metadata = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
	
	NSLog(@"Data: %@", metadata);
	
	int index = ([metadata rangeOfString:@"<body>"].location + 1);
	if(index != NSNotFound){
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
							 }];
						 }
		 ];
	}
	
	
	
}



- (void) updateTrackTitle:(NSString *) newTitle animated:(BOOL)animated{
	
	if(![self.trackTitleLabel.text isEqualToString:newTitle]){
		[UIView animateWithDuration:0.5f animations:^{
			self.trackTitleLabel.alpha = 0.0f;
		} completion:^(BOOL finished) {
			self.trackTitleLabel.text = newTitle;
			[UIView animateWithDuration:0.75f animations:^{
				self.trackTitleLabel.alpha = 1.0f;
			}];
		}];
	}
	
}

//
// spinButton
//
// Shows the spin button when the audio is loading. This is largely irrelevant
// now that the audio is loaded from a local file.
//
- (void)spinButton
{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	CGRect frame = [self.button frame];
	self.button.layer.anchorPoint = CGPointMake(0.5, 0.5);
	self.button.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
	[CATransaction commit];
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
	[CATransaction setValue:[NSNumber numberWithFloat:2.0] forKey:kCATransactionAnimationDuration];
	
	CABasicAnimation *animation;
	animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.fromValue = [NSNumber numberWithFloat:0.0];
	animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
	animation.delegate = self;
	[self.button.layer addAnimation:animation forKey:@"rotationAnimation"];
	
	[CATransaction commit];
}




@end
