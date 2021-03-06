//
//  JerryAnimation.m
//  Growup
//
//  Created by Jerry on 2017/3/17.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "JerryAnimation.h"

@implementation JerryAnimation

+ (void)shakeToShow:(UIView *) view{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint x = CGPointMake(position.x + 4, position.y);
    CGPoint y = CGPointMake(position.x - 4, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:.06];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}

@end

