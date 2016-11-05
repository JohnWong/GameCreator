//
//  UIAlertView+WL.m
//  GameCreator
//
//  Created by John Wong on 11/5/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "UIAlertView+WL.h"
#import <objc/runtime.h>

@implementation UIAlertView (WL)

+ (void)load
{
    Method m1 = class_getClassMethod(self, @selector(showAlertWithTitle:message:));
    Method m2 = class_getClassMethod(self, @selector(wl_showAlertWithTitle:message:));
    method_exchangeImplementations(m1, m2);
}

+ (void)wl_showAlertWithTitle:(id)title message:(id)message
{
    if ([UIApplication sharedApplication].keyWindow.windowLevel == UIWindowLevelAlert) {
        return;
    }
    if ([@"请前往「隐私」-「定位服务」-「系统服务」，开启「指南针校准」，然后再开始录制视频。" isEqualToString:message]) {
        return;
    }
    [self wl_showAlertWithTitle:title message:message];
}

@end
