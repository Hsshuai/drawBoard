//
//  DVISettingView.h
//  练习画板
//
//  Created by apple on 13-8-16.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVISettingView : UIView

@property(nonatomic,assign)BOOL eraserFlog;

- (CGFloat)returnSliderValue;
- (void)addTarget:(id)target forAction:(SEL)action;
@end
