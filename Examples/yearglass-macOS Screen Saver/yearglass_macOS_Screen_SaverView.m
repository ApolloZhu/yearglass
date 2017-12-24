//
//  yearglass_macOS_Screen_SaverView.m
//  yearglass-macOS Screen Saver
//
//  Created by Apollo Zhu on 12/24/17.
//  Copyright © 2017 yearglass. All rights reserved.
//

#import "yearglass_macOS_Screen_SaverView.h"

@implementation yearglass_macOS_Screen_SaverView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
