//
//  PaintView.h
//  PaintSimple
//
//  Created by ZhangJie on 3/19/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaintView : UIView

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIImage *image;

// 清除
- (void)clear;

// 回退
- (void)backSpace;

// 橡皮擦
- (void)eraser;
@end
