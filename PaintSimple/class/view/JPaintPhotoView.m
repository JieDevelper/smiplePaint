//
//  JPaintPhotoView.m
//  PaintSimple
//
//  Created by ZhangJie on 3/26/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "JPaintPhotoView.h"
@interface JPaintPhotoView()<UIGestureRecognizerDelegate>


@end

@implementation JPaintPhotoView

- (instancetype)initWithImage:(UIImage *)image frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSLog(@"frame:%@", NSStringFromCGRect(frame));
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = self.bounds;
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.multipleTouchEnabled = YES; //支持多点触摸
        
        // add gesture
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [imageView addGestureRecognizer:pan];
        
        UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationGesture:)];
        rotation.delegate = self;
        [imageView addGestureRecognizer:rotation];
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
        pinch.delegate = self;
        [imageView addGestureRecognizer:pinch];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        [imageView addGestureRecognizer:longPress];
        
    }
    
    return self;
}

- (void)panGesture:(UIPanGestureRecognizer *) gesture {
    CGPoint p = [gesture translationInView:gesture.view];
    gesture.view.transform = CGAffineTransformTranslate(gesture.view.transform, p.x, p.y);
    
    //清零
    [gesture setTranslation:CGPointZero inView:gesture.view];
}

- (void)rotationGesture:(UIRotationGestureRecognizer *)gesture {
    gesture.view.transform = CGAffineTransformRotate(gesture.view.transform, gesture.rotation);
    gesture.rotation = 0;
}

- (void)pinchGesture:(UIPinchGestureRecognizer *)gesture {
    gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
    gesture.scale = 1.0;
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        //让图片闪一下
        [UIView animateWithDuration:0.5 animations:^{
            gesture.view.alpha = 0.4;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                gesture.view.alpha = 1.0f;
            } completion:^(BOOL finished) {
                // 创建（开启）图片上下文
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                // 获取当前view的图形内容
                [self.layer renderInContext:ctx];
                // 从下上文中获取图片
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                // 结束上下文
                UIGraphicsEndImageContext();
                
                //图片传给代理
                if ([self.delegate respondsToSelector:@selector(paintPhotoView:didFinshImage:)]) {
                    [self.delegate paintPhotoView:self didFinshImage:image];
                }
            }];
        }];
    }
}

// gestrue delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

+ (instancetype)photoViewWithImage:(UIImage *)image frame:(CGRect)frame {
    return [[self alloc] initWithImage:image frame:frame];
}
@end
