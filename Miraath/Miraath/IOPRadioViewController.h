//
//  IOPRadioViewController.h
//  Miraath
//
//  Created by Jonathan Flintham on 18/04/2013.
//  Copyright (c) 2013 Jonathan Flintham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface IOPRadioViewController : UIViewController <AVAudioSessionDelegate, NSURLConnectionDelegate>


@property (nonatomic, strong) UIImageView  *defaultBackgroundImageView;
@property (nonatomic, strong) NSDictionary *channelInfo;

@end
