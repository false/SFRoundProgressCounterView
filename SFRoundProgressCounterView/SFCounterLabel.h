//
//  SFRoundProgressCounterView.h
//  SFRoundProgressCounter
//
//  Initially created by Ross Gibson on 10/10/2013.
//  Copyright (c) 2013 Triggertrap. All rights reserved.
//
//  Adapted by Thomas Winkler on 22/01/14.
//  Copyright (c) 2014 Simpliflow. All rights reserved.
//

#import <TTTAttributedLabel/TTTAttributedLabel.h>

typedef NS_ENUM(NSInteger, kCountDirection){
    kCountDirectionUp = 0,
    kCountDirectionDown
};

typedef NS_ENUM(NSInteger, kFormatTimestring){
    kFormatTimestringNormal = 0,
    kFormatTimestringColons
};
#pragma mark - SFCounterLabelDelegate
@class SFCounterLabel;

@protocol SFCounterLabelDelegate <NSObject>
@optional
- (void)countdownDidEnd;
- (void)counter:(SFCounterLabel *)counter didReachValue:(unsigned long long)value;
@end

#pragma mark - SFCounterLabel

@interface SFCounterLabel : TTTAttributedLabel

@property (weak) id <SFCounterLabelDelegate> countdownDelegate;
@property (nonatomic, assign) unsigned long long currentValue;
@property (nonatomic, assign) unsigned long long startValue;
@property (nonatomic, assign) NSInteger countDirection;
@property (nonatomic, assign) NSInteger formatTimestring;
@property (strong, nonatomic) UIFont *boldFont;
@property (strong, nonatomic) UIFont *regularFont;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, assign) BOOL hideFraction;

#pragma mark - Public Methods

- (void)start;
- (void)stop;
- (void)reset;
- (void)updateApperance;

@end
