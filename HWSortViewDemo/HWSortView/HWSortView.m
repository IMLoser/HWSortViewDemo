//
//  Copyright © 2016年 曹航玮. All rights reserved.
/*
 * ......................我佛慈悲......................
 *                       _oo0oo_
 *                      o8888888o
 *                      88" . "88
 *                      (| -_- |)
 *                      0\  =  /0
 *                    ___/`---'\___
 *                  .' \\|     |// '.
 *                 / \\|||  :  |||// \
 *                / _||||| -卍-|||||- \
 *               |   | \\\  -  /// |   |
 *               | \_|  ''\---/''  |_/ |
 *               \  .-\__  '-'  ___/-. /
 *             ___'. .'  /--.--\  `. .'___
 *          ."" '<  `.___\_<|>_/___.' >' "".
 *         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
 *         \  \ `_.   \_ __\ /__ _/   .-` /  /
 *     =====`-.____`.___ \_____/___.-`___.-'=====
 *                       `=---='
 *
 * ..................佛祖开光,永无BUG...................
 */

#import "HWSortView.h"
#define SELF_SIZE self.frame.size
#define DEFAULT_COLUMN_MARGIN 10
#define DEFAULT_COLUMN_COUNT 3
#define RGB_COLOR [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:0.8]

@interface HWSortView ()

@property (strong, nonatomic) NSMutableArray * buttons;

@property (assign, nonatomic) CGPoint startP;
@property (assign, nonatomic) CGPoint buttonP;


@end

@implementation HWSortView

- (NSMutableArray *)buttons {
    
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

+ (instancetype)sortView
{
    HWSortView * sortView = [[HWSortView alloc] init];
    sortView.backgroundColor = [UIColor clearColor];
    return sortView;
}

+ (instancetype)sortViewWithTitlesArray:(NSMutableArray *)titlesArray
{
    HWSortView * sortView = [HWSortView sortView];
    sortView.titlesArray = titlesArray;
    [sortView initailButtons];
    return sortView;
}

- (void)initailButtons
{
    if (!_titlesArray.count) return;
    for (NSInteger i = 0; i < _titlesArray.count; i++) {
        UIButton * movedBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [movedBtn setBackgroundColor:RGB_COLOR];
        movedBtn.layer.cornerRadius = 5;
        [movedBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [movedBtn setTitle:_titlesArray[i] forState:(UIControlStateNormal)];
        [self.buttons addObject:movedBtn];
        movedBtn.tag = i;
        [self addSubview:movedBtn];
        
        // 添加长按手势
        UILongPressGestureRecognizer * longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
        [movedBtn addGestureRecognizer:longGes];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self settingButtonFrame];
    });
}

// 布局九宫格
- (void)settingButtonFrame
{
    if (0 == _columnMargin) { _columnMargin = DEFAULT_COLUMN_MARGIN; }
    if (0 == _columnCount) { _columnCount = DEFAULT_COLUMN_COUNT; }
    
    CGFloat buttonH = 30;
    CGFloat buttonW = (SELF_SIZE.width - _columnMargin * (_columnCount + 1)) / _columnCount * 1.0;
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    // 设置按钮初始位置
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        NSInteger column = i % _columnCount;
        NSInteger row = i / _columnCount;
        buttonX = _columnMargin + column * (buttonW + _columnMargin);
        buttonY = _columnMargin + row * (buttonH + _columnMargin);
        UIButton * btn = self.buttons[i];
        btn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
}

// 设置按钮文字颜色
- (void)setTitlesColor:(UIColor *)titlesColor {
    
    _titlesColor = titlesColor;
    for (UIButton * movedBtn in _buttons) {
        [movedBtn setTitleColor:_titlesColor forState:(UIControlStateNormal)];
    }
    
}

#pragma MARK - < Button_Gesture >

- (void)longPressClick:(UIGestureRecognizer *)longGes
{
    UIButton * currentBtn = (UIButton *)longGes.view;
    
    if (UIGestureRecognizerStateBegan == longGes.state) {
        [UIView animateWithDuration:0.2 animations:^{
            currentBtn.transform = CGAffineTransformScale(currentBtn.transform, 1.2, 1.2);
            currentBtn.alpha = 0.7f;
            _startP = [longGes locationInView:currentBtn];
            _buttonP = currentBtn.center;
        }];
    }
    
    if (UIGestureRecognizerStateChanged == longGes.state) {
        CGPoint newP = [longGes locationInView:currentBtn];
        CGFloat movedX = newP.x - _startP.x;
        CGFloat movedY = newP.y - _startP.y;
        currentBtn.center = CGPointMake(currentBtn.center.x + movedX, currentBtn.center.y + movedY);
        
        // 获取当前按钮的索引
        NSInteger fromIndex = currentBtn.tag;
        // 获取目标移动索引
        NSInteger toIndex = [self getMovedIndexByCurrentButton:currentBtn];
        
        if (toIndex < 0) {
            return;
        } else {
            
            currentBtn.tag = toIndex;
            // 按钮向后移动
            if (fromIndex < toIndex) {
                
                for (NSInteger i = fromIndex; i < toIndex; i++) {
                    // 拿到下一个按钮
                    UIButton * nextBtn = self.buttons[i + 1];
                    CGPoint tempP = nextBtn.center;
                    [UIView animateWithDuration:0.5 animations:^{
                        nextBtn.center = _buttonP;
                    }];
                    _buttonP = tempP;
                    nextBtn.tag = i;
                }
                [self sortArray];
            } else if(fromIndex > toIndex) { // 按钮向前移动
                
                for (NSInteger i = fromIndex; i > toIndex; i--) {
                    UIButton * previousBtn = self.buttons[i - 1];
                    CGPoint tempP = previousBtn.center;
                    [UIView animateWithDuration:0.5 animations:^{
                        previousBtn.center = _buttonP;
                    }];
                    _buttonP = tempP;
                    previousBtn.tag = i;
                }
                [self sortArray];
            }
        }
    }
    
    // 手指松开之后 进行的处理
    if (UIGestureRecognizerStateEnded == longGes.state) {
        [UIView animateWithDuration:0.2 animations:^{
            currentBtn.transform = CGAffineTransformIdentity;
            currentBtn.alpha = 1.0f;
            currentBtn.center = _buttonP;
        }];
    }
}

- (void)sortArray
{
    // 对已改变按钮的数组进行排序
    [_buttons sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        UIButton *temp1 = (UIButton *)obj1;
        UIButton *temp2 = (UIButton *)obj2;
        return temp1.tag > temp2.tag;    //将tag值大的按钮向后移
    }];
    
}

// 获取按钮移动目标索引
- (NSInteger)getMovedIndexByCurrentButton:(UIButton *)currentButton
{
    for (NSInteger i = 0; i<self.buttons.count ; i++) {
        UIButton * button = self.buttons[i];
        if (!currentButton || button != currentButton) {
            if (CGRectContainsPoint(button.frame, currentButton.center)) {
                return i;
            }
        }
    }
    return -1;
}

@end
