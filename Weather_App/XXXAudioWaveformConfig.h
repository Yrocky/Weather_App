//
//  XXXAudioWaveformConfig.h
//  Weather_App
//
//  Created by skynet on 2019/12/31.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXXAudioWaveformConfig : NSObject
/**
 The color that will be used for every bands that are after
 the progressTime.
 */
@property (strong, nonatomic) UIColor *normalColor;

/**
 The color that will be used for every bands that are before
 the progressTime.
 */
@property (strong, nonatomic) UIColor *progressColor;

/**
 The progress time. Each bands that are before this time will be
 displayed using the progressColor.
 */
@property (assign, nonatomic) CMTime progressTime;

/**
 The precision ratio. This defines the number of pixels
 used per band. Using a value of 0.5 means that 2 pixels
 will be used per band.
 1s显示多少个单元
 Default is 1.
 */
@property (assign, nonatomic) CGFloat precision;

/**
 A ratio applied on the width of each waveform band.
 Default is 1.
 */
@property (assign, nonatomic) CGFloat lineWidthRatio;

/**
 The padding in point between each channels.
 Default is 0.
 */
@property (assign, nonatomic) CGFloat channelsPadding;

/**
 The timeRange to use for rendering the waveform.
 If you want to render a portion of the waveform, you can
 reduce the duration.
 
 Default is kCMTimeZero, kCMTimePositiveInfinity
 */
@property (assign, nonatomic) CMTimeRange timeRange;

/**
 The first audio channel index to render.
 Default is 0
 */
@property (assign, nonatomic) NSUInteger channelStartIndex;

/**
 The last audio channel index to render. You can set that to 1
 to render a stereo waveform.
 Default is 0.
 */
@property (assign, nonatomic) NSUInteger channelEndIndex;

/**
 The underyling waveform size for rendering the complete waveform.
 */
@property (readonly, nonatomic) CGSize waveformSize;

/**
 The asset duration based on what was actually read from the asset.
 */
@property (readonly, nonatomic) CMTime actualAssetDuration;
@end

NS_ASSUME_NONNULL_END
