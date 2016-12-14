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

#import <UIKit/UIKit.h>

@interface HWSortView : UIView

@property (strong, nonatomic) NSMutableArray * titlesArray; //按钮显示文字数组

@property (assign, nonatomic) NSInteger columnCount; // 按钮列数

@property (assign, nonatomic) CGFloat columnMargin; // 按钮列间隔

@property (strong, nonatomic) UIColor * titlesColor; // 按钮文字颜色

+ (instancetype)sortView;
+ (instancetype)sortViewWithTitlesArray:(NSMutableArray *)titlesArray;

@end
