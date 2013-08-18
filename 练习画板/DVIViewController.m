//
//  DVIViewController.m
//  练习画板
//
//  Created by apple on 13-8-15.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "DVIViewController.h"
#import "DVIDrawBoardView.h"
#import "DVIDataClass.h"
#import "DVISettingView.h"

@interface DVIViewController ()
{
    DVIDrawBoardView *_drawBoardView;
    DVISettingView *_settingView;
}
@end

@implementation DVIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _drawBoardView = [[DVIDrawBoardView alloc] initWithFrame:self.view.frame];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [_drawBoardView addGestureRecognizer:panGestureRecognizer];
    [panGestureRecognizer release];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_drawBoardView addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
    [self.view addSubview:_drawBoardView];
    [_drawBoardView release];
    
    [self addSettingButton];

    _settingView = [[DVISettingView alloc] initWithFrame:CGRectMake(0, 310, self.view.frame.size.width, 150)];
    //    NSLog(@"%@",NSStringFromCGRect(CGRectMake(0, 300, self.view.frame.size.width, 150)));
    NSLog(@"%@",NSStringFromCGSize(self.view.frame.size));
    _settingView.backgroundColor = [UIColor colorWithRed:241 green:241 blue:241 alpha:0.5];
    _settingView.alpha = 0;
    [self.view addSubview:_settingView];
    [_settingView release];
    
    [_settingView addTarget:_drawBoardView forAction:@selector(setNeedsDisplay)];
    
    NSDate *date = [NSDate date];
    NSLog(@"%@",date);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)panAction:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint point = [panGestureRecognizer locationInView:_drawBoardView];
//    NSLog(@"%@",NSStringFromCGPoint(point));

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [_drawBoardView setLineIndex:[_settingView returnSliderValue] andBoolEraser:_settingView.eraserFlog];
        [_drawBoardView addNewArray];
    }
    
//    _drawBoardView.sliderValue = [_settingView returnSliderValue];
    NSString *stringFromPoint = NSStringFromCGPoint(point);
    [_drawBoardView receivePoint:stringFromPoint];
    [_drawBoardView setNeedsDisplay];
   
}

- (void)tapAction:(UIGestureRecognizer *)gestureRecognizer
{
    if (_settingView.alpha == 1) {
        _settingView.alpha = 0;
//        _drawBoardView.userInteractionEnabled = YES;
    }
}
- (void)addSettingButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.frame.size.width - 50, self.view.frame.size.height - 140, 45, 45);
    [button setBackgroundImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)settingAction
{
//    static BOOL frontFlog = NO;
    if (_settingView.alpha == 0) {
        _settingView.alpha = 1;
//        _drawBoardView.userInteractionEnabled = NO;
//        frontFlog = YES;
    }
//    else
//    {
//        _settingView.alpha = 0;
//        _drawBoardView.userInteractionEnabled = YES;
//        frontFlog = NO;
//    }
}
#pragma mark- 响应目标动作中方法
//- (void)reloadDataBase:(DVIDataClass *)dataClass
//{
//    [_drawBoardView preserveDatabase:dataClass];
//    NSLog(@"%p",_drawBoardView);
//}

@end
