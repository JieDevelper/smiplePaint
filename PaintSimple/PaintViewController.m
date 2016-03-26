//
//  ViewController.m
//  PaintSimple
//
//  Created by ZhangJie on 3/19/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "PaintViewController.h"
#import "PaintView.h"
#import "JPaintPhotoView.h"

@interface PaintViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, PaintPhotoViewDelegate>
@property (weak, nonatomic) IBOutlet PaintView *paintView;

@end

@implementation PaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.paintView.lineWidth = 15;
    self.paintView.lineColor = [UIColor blackColor];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changValue:(id)sender {
    UISlider *slider = sender;
    self.paintView.lineWidth = slider.value;
}

- (IBAction)clearPaintView:(id)sender {
    [self.paintView clear];
}

- (IBAction)backSpace:(id)sender {
    [self.paintView backSpace];
}

- (IBAction)eraser:(id)sender {
    [self.paintView eraser];
}

- (IBAction)photo:(id)sender {
    UIImagePickerController *imageVc = [[UIImagePickerController alloc] init];
    imageVc.delegate = self;
    
    // 修改打开相册的类型(按照拍照的时间来选择照片)
    imageVc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //相册
    
    [self presentViewController:imageVc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *iamge = info[UIImagePickerControllerOriginalImage];
    JPaintPhotoView *photoView = [JPaintPhotoView photoViewWithImage:iamge frame:self.paintView.frame];
    [self.view addSubview:photoView];
    //NSLog(@"%@",info);
    photoView.delegate = self;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)paintPhotoView:(JPaintPhotoView *)photoView didFinshImage:(UIImage *)image {
    self.paintView.image = image;
    [photoView removeFromSuperview];
}

- (IBAction)save:(id)sender {
    // 1. 开启一个Bitmap的图形上下文,获取当前上下文
    UIGraphicsBeginImageContextWithOptions(self.paintView.bounds.size, NO, 0.0);
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    
    // 2. 将paintView中的layer渲染到Bitmap的图形上下文中
    [self.paintView.layer renderInContext:cxt];
    
    // 3. 将图片从上下文中取出
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4. 关闭上下文
    UIGraphicsEndImageContext();
    
    // 5. 保存图片到相册
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action =  [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)updateLineColor:(id)sender{
    UIButton *btn = sender;
    self.paintView.lineColor = btn.backgroundColor;
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}
@end
