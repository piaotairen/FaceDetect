//
//  ViewController.m
//  FaceDetect
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 Cobb. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *dtectSegmentControl;
@property (weak, nonatomic) IBOutlet UIImageView *inputImageView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *outputImageView;


@property (assign,nonatomic) CGFloat rateX;//图像大小与视图大小比(x轴)
@property (assign,nonatomic) CGFloat rateY;//图像大小与视图大小比(y轴)

@end

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"人物笑脸"];
    _inputImageView.image = image;
    
    self.rateX = _inputImageView.frame.size.width/image.size.width;
    self.rateY = _inputImageView.frame.size.height/image.size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    ;
}

- (IBAction)detect:(id)sender {

    if (self.dtectSegmentControl.selectedSegmentIndex == 0){
        //人脸识别
        CIContext *context = [CIContext contextWithOptions:nil];
        
        UIImage *imageInput = [_inputImageView image];
        CIImage *image = [CIImage imageWithCGImage:imageInput.CGImage];
        
        //设置识别参数
        NSDictionary *param = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh
                                                          forKey:CIDetectorAccuracy];
        //声明一个CIDetector，并设定识别类型
        CIDetector* faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                      context:context options:param];
        
        //取得识别结果
        NSArray *detectResult = [faceDetector featuresInImage:image];
        
        UIView *resultView = [[UIView alloc] initWithFrame:_inputImageView.frame];
        
        [self.view addSubview:resultView];
        
        for(CIFaceFeature* faceFeature in detectResult) {
            
            //脸部
            UIView* faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
            NSLog(@"faceFeature.bounds is %@",NSStringFromCGRect(faceFeature.bounds));
            faceView.layer.borderWidth = 1;
            faceView.layer.borderColor = [UIColor orangeColor].CGColor;
            faceView.layer.cornerRadius = faceFeature.bounds.size.width/3;
            [resultView addSubview:faceView];
            
            //左眼
            if (faceFeature.hasLeftEyePosition) {
                UIView* leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
                [leftEyeView setCenter:faceFeature.leftEyePosition];
                leftEyeView.layer.borderWidth = 1;
                leftEyeView.layer.borderColor = [UIColor redColor].CGColor;
                leftEyeView.layer.cornerRadius = 2.5f;
                [resultView addSubview:leftEyeView];
            }
            
            //右眼
            if (faceFeature.hasRightEyePosition) {
                UIView* rightEyeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
                [rightEyeView setCenter:faceFeature.rightEyePosition];
                rightEyeView.layer.borderWidth = 1;
                rightEyeView.layer.borderColor = [UIColor redColor].CGColor;
                rightEyeView.layer.cornerRadius = 2.5f;
                [resultView addSubview:rightEyeView];
            }
            
            //嘴巴
            if (faceFeature.hasMouthPosition) {
                UIView* mouthView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
                [mouthView setCenter:faceFeature.mouthPosition];
                mouthView.layer.borderWidth = 1;
                mouthView.layer.borderColor = [UIColor redColor].CGColor;
                mouthView.layer.cornerRadius = 2.5f;
                [resultView addSubview:mouthView];
            }
            
        }
        
        [resultView setTransform:CGAffineTransformMakeScale(1, -1)];
        
        if ([detectResult count] > 0)
        {
            CIImage *faceImage = [image imageByCroppingToRect:[[detectResult objectAtIndex:0] bounds]];
            
            UIImage *face = [UIImage imageWithCGImage:[context createCGImage:faceImage fromRect:faceImage.extent]];
            self.outputImageView.image = face;
            
            [self.button setTitle:[NSString stringWithFormat:@"识别 人脸数 %lu",
                                   (unsigned long)[detectResult count]] forState:UIControlStateNormal];
        }
    }else if (self.dtectSegmentControl.selectedSegmentIndex == 1){
        //笑脸识别
        CIContext *context = [CIContext contextWithOptions:nil];
        UIImage *imageInput = [_inputImageView image];
        CIImage *image = [CIImage imageWithCGImage:imageInput.CGImage];
        
        //设置识别参数
        NSDictionary *param = [NSDictionary dictionaryWithObject:@(YES)
                                                          forKey:CIDetectorSmile];
        CIDetector *smileDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:param];
        
        //取得识别结果
        NSArray *detectResult = [smileDetector featuresInImage:image];
        NSLog(@"detectResult is %@",detectResult);
        
    }
}

@end
