//
//  GUCEditFilterViewController.h
//  GPUImageCafe
//
//  Created by masafumi yoshida on 2014/06/23.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>

@interface GUCEditFilterViewController : UIViewController
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@property (nonatomic,strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic,strong) GPUImageMovieWriter *videoWriter;
@property (nonatomic,strong) GPUImageFilter *filter;
@property (nonatomic,strong) IBOutlet GPUImageView *previewView;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,strong) NSArray *configs;
-(UIImage*)getPreviewImage:(int)tag;
-(void)setupSession;
@end
