//
//  ViewController.m
//  TestSFRoundProgressTimerView
//
//  Created by Thomas Winkler on 22/01/14.
//  Copyright (c) 2014 Simpliflow. All rights reserved.
//

#import "ViewController.h"
#import "SFRoundProgressCounterView.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SFRoundProgressCounterView *progressCounterView;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;

@property (strong, nonatomic) AVAudioPlayer *warningAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *finishAudioPlayer;

@property (atomic) BOOL playBeep;

@end

#define DEFAULT_BEEP_INTERVAL 10000

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup progress timer view
    self.progressCounterView.delegate = self;
    NSNumber* interval = [NSNumber numberWithLong:3000.0];
    self.progressCounterView.intervals = @[interval];

    self.progressCounterView.backgroundColor = [UIColor clearColor];
    
    // set thickness and distance parameters
    self.progressCounterView.outerCircleThickness = [NSNumber numberWithFloat:3.0];
    self.progressCounterView.innerCircleThickness = [NSNumber numberWithFloat:1.0];
    self.progressCounterView.circleDistance = [NSNumber numberWithFloat:6.0];
    self.progressCounterView.hideFraction = YES;
    
    // set track colors
//    self.progressCounterView.innerTrackColor = [UIColor redColor];
//    self.progressCounterView.outerTrackColor = [UIColor blackColor];
}

#pragma mark = SFRoundProgressTimerViewDelegate
- (void)countdownDidEnd:(SFRoundProgressCounterView*)progressTimerView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.startStopButton setTitle:@"START" forState:UIControlStateNormal];
//        [self.progressCounterView reset];
    });
}

- (void)intervalDidEnd:(SFRoundProgressCounterView *)progressTimerView WithIntervalPosition:(int)position
{
    [self.warningAudioPlayer play];
}

#pragma mark - audio
- (AVAudioPlayer*) warningAudioPlayer {
    if (!_warningAudioPlayer) {
        NSURL *audioUrl = [NSURL fileURLWithPath:([[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"])];
        _warningAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
    }
    
    return _warningAudioPlayer;
}

- (AVAudioPlayer*) finishAudioPlayer {
    if (!_finishAudioPlayer) {
        NSURL *audioUrl = [NSURL fileURLWithPath:([[NSBundle mainBundle] pathForResource:@"doublebeep" ofType:@"mp3"])];
        _finishAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
    }
    
    return _finishAudioPlayer;
}

#pragma mark - actions
- (IBAction)actionStartStop:(id)sender {
    
    UIButton *button = (UIButton *)sender;

    dispatch_async(dispatch_get_main_queue(), ^{
        // start
        if ([button.currentTitle isEqualToString:@"START"]) {
            
            [self.progressCounterView start];
            [self.startStopButton setTitle:@"STOP" forState:UIControlStateNormal];
            // stop
        } else if ([button.currentTitle isEqualToString:@"STOP"]) {
            
            [self.progressCounterView stop];
            [self.startStopButton setTitle:@"RESUME" forState:UIControlStateNormal];
            // resume
        } else {
            
            [self.progressCounterView resume];
            [self.startStopButton setTitle:@"STOP" forState:UIControlStateNormal];
        }
    });
}

- (IBAction)actionRestart:(id)sender {
    [self.startStopButton setTitle:@"STOP" forState:UIControlStateNormal];
    [self.progressCounterView start];
}

#pragma mark - color
- (void)setColor:(UIColor *)color
{
    if (color) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressCounterView.innerProgressColor = color;
            self.progressCounterView.outerProgressColor = color;
            self.progressCounterView.labelColor = color;
            
            self.startStopButton.tintColor = color;
        });
    }
}

- (void)setBgColor:(UIColor *)bgColor
{
    if (bgColor) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressCounterView.backgroundColor = bgColor;
        });
    }
}

- (void)setIntervals:(NSArray *)intervals
{
    if (intervals) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.startStopButton setTitle:@"START" forState:UIControlStateNormal];
            [self.progressCounterView stop];
            _intervals = intervals;
            self.progressCounterView.intervals = intervals;
        });
    }
}

@end
