//
//  PaintView.m
//  PaintSimple
//
//  Created by ZhangJie on 3/19/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "PaintView.h"
#import "PaintViewPath.h"

@interface PaintView ()

//@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) NSMutableArray *pathsArray;
@end

@implementation PaintView

- (NSMutableArray *)pathsArray {
    if (_pathsArray == nil) {
        _pathsArray = [NSMutableArray array];
    }
    return _pathsArray;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    PaintViewPath *path = [[PaintViewPath alloc] init];
    path.image = image;
    
    [self.pathsArray addObject:path];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (self.pathsArray.count == 0) return;
    
    for (PaintViewPath *path in self.pathsArray) {
        if (path.image != nil) {
            [path.image drawAtPoint:CGPointZero];
        }else{
            [path.lineColor set];
            
            path.lineCapStyle = kCGLineCapRound;
            path.lineJoinStyle = kCGLineJoinRound;
            //绘制
            [path stroke];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:touch.view];
    
    PaintViewPath *path = [[PaintViewPath alloc] init];
    path.lineColor = self.lineColor;
    [path moveToPoint:p];
    [path setLineWidth:self.lineWidth];
    [self.pathsArray addObject:path];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:touch.view];
    
    [[self.pathsArray lastObject] addLineToPoint:p];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)clear {
    [self.pathsArray removeAllObjects];
    [self setNeedsDisplay];
}

- (void)eraser {
    self.lineColor = self.backgroundColor;
}

- (void)backSpace {
    [self.pathsArray removeLastObject];
    [self setNeedsDisplay];
}

- (void)save {

}

@end
