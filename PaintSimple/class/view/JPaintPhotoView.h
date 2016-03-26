//
//  JPaintPhotoView.h
//  PaintSimple
//
//  Created by ZhangJie on 3/26/16.
//  Copyright © 2016 apple. All rights reserved.
//
#import <UIKit/UIKit.h>
@class JPaintPhotoView;

@protocol PaintPhotoViewDelegate <NSObject>

@optional
- (void)paintPhotoView:(JPaintPhotoView *)photoView didFinshImage:(UIImage *)image;

@end



@interface JPaintPhotoView : UIView

@property (nonatomic, weak) id<PaintPhotoViewDelegate> delegate;

+ (instancetype)photoViewWithImage:(UIImage *)image frame:(CGRect) frame;
@end
