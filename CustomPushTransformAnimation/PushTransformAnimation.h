//
//  PushTransformAnimation.h
//  CustomPushTransformAnimation
//
//  Created by changcai on 17/6/27.
//  Copyright © 2017年 changcai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TransformAnimationType)
{
    TransformAnimationTypePush,
    TransformAnimationTypePop
};

@interface PushTransformAnimation : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWithTransitionType:(TransformAnimationType)type;

@end

