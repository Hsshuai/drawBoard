//
//  DVISettingView.m
//  练习画板
//
//  Created by apple on 13-8-16.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "DVISettingView.h"
#import "DVIDataManager.h"
#import "DVIDrawBoardView.h"
@interface DVISettingView()
{
    UISlider *_slider;
    
    id _target;
    SEL _action;
}
@end
@implementation DVISettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGSize size = self.frame.size;
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, size.height - 50, size.width, 50)];
        toolBar.barStyle = UIBarStyleDefault;
        toolBar.backgroundColor = [UIColor redColor];
        toolBar.items = [self addBarButtonItem];
        [self addSubview:toolBar];
        [toolBar release];
        
        [self addSliderView];
        
        [self addPreserveButton];
        
        [self openContentButton];
    }
    return self;
}

#pragma mark- 封装item
- (NSMutableArray *)addBarButtonItem
{
    NSMutableArray *array = [[[NSMutableArray alloc] init]autorelease];
    for (int i = 0; i < 7; i++) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[self addButton:i]];
//        CGFloat perWidth = self.frame.size.width / 7;
//        item.width =  perWidth * i;
        [array addObject:item];
    }
    return array;
}

- (UIButton *)addButton:(NSInteger)index
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = [self setButtonFrame:index];
    [btn setBackgroundImage:[self setImage:index] forState:UIControlStateNormal];
    btn.tag = 1000 + index;
    [btn addTarget:self action:@selector(didClickedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (CGRect)setButtonFrame:(NSInteger)index1
{
    CGFloat perWidth = self.frame.size.width / 7;
    CGFloat perHeight = self.frame.size.height - 45;
    
    return CGRectMake(index1 * perWidth, perHeight, perWidth, 45);
}

- (UIImage *)setImage:(NSInteger)index2
{
    switch (index2) {
        case 0:
            return [UIImage imageNamed:@"paint.png"];
        case 1:
            return [UIImage imageNamed:@"erase.png"];
        case 2:
            return [UIImage imageNamed:@"color.png.png"];
        case 3:
            return [UIImage imageNamed:@"bgimage.png"];
        case 4:
            return [UIImage imageNamed:@"undo.png"];
        case 5:
            return [UIImage imageNamed:@"save.png"];
        case 6:
            return [UIImage imageNamed:@"new.png"];
        default:
            break;
    }
    return nil;
}

- (void)didClickedButton:(UIButton *)render
{
    NSInteger buttonTag = render.tag;
    switch (buttonTag) {
        case 1000:
            return;
        case 1001:
            [self btn1Action];
            return;
        case 1002:
            return;
        case 1003:
            return;
        case 1004:
            return;
        case 1005:
            return [self setAndOpenDataLine];
        case 1006:
            return;
        default:
            break;
    }
}
#pragma mark- item方法
- (void)btn1Action
{
    _eraserFlog = YES;
}

- (void)setAndOpenDataLine
{
    UIView *view = [self viewWithTag:2000];
    UIView *viewTwo = [self viewWithTag:2001];
    view.hidden = NO;
    viewTwo.hidden = NO;
}
#pragma mark- slider
- (void)addSliderView
{
    _slider = [[UISlider alloc]initWithFrame:CGRectMake(20, 10, 250, 40)];
    _slider.maximumValueImage = [UIImage imageNamed:@"slider_ball.png"];
    _slider.minimumValue = 1;
    _slider.maximumValue = 40;
    _slider.value = 1;
//    [_slider addTarget:self action:@selector(sliderAction) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_slider];
    [_slider release];
}

- (CGFloat)returnSliderValue
{
    return _slider.value;
}

- (void)addPreserveButton
{
    UIButton *preserveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    preserveButton.tag = 2000;
    preserveButton.frame = CGRectMake(self.frame.size.width - 150, 0 , 45, 45);
    [preserveButton setTitle:@"保存" forState:UIControlStateNormal];
    [preserveButton setBackgroundColor:[UIColor redColor]];
    [preserveButton addTarget:self action:@selector(preserveAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:preserveButton];
    [preserveButton setHidden:YES];
}

- (void)preserveAction
{
    DVIDataManager *dataManager = [DVIDataManager dafaultManager];
//    for (DVIDataClass *dataClass in dataManager.dataClassArray) {
//        [dataManager preserveArray:dataClass];
//    }
    [dataManager preserveArray];
    
    
}

- (void)openContentButton
{
    UIButton *openContentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    openContentButton.tag = 2001;
    openContentButton.frame = CGRectMake(self.frame.size.width - 200, 0 , 45, 45);
    [openContentButton setTitle:@"打开" forState:UIControlStateNormal];
    [openContentButton setBackgroundColor:[UIColor greenColor]];
    [openContentButton addTarget:self action:@selector(openContentAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:openContentButton];
    [openContentButton setHidden:YES];
}

- (void)openContentAction
{
    DVIDataManager *dataManager = [DVIDataManager dafaultManager];
//    DVIDataClass *dataClass = [[DVIDataClass alloc] init];
//    _numOfArray = [dataClass checkData:_numOfArray];
//    //[_numOfArray addObject:dataClass];
//    [self setNeedsDisplay];
    [dataManager checkData];
    
    if (_target && _action) {
        [_target performSelector:_action];
    }
}

- (void)addTarget:(id)target forAction:(SEL)action
{
    _target = target;
    _action = action;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
