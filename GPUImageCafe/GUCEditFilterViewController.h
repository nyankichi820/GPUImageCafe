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
@property (nonatomic,strong) GPUImageFilterGroup *filter;
@property (nonatomic,weak) IBOutlet UITextField *filterNameTextFiled;
@property (nonatomic,strong) IBOutlet UIView *previewContainer;
@property (nonatomic,strong) IBOutlet UIView *previewVideoContainer;
@property (nonatomic,weak) IBOutlet GPUImageView *previewView;
@property (nonatomic,weak) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,strong) NSArray *configs;
@property (nonatomic) BOOL isVideoRunning;
@property (strong, nonatomic) NSDictionary *filterParameter;
-(void)updateFilterParams:(NSArray*)params;
-(UIImage*)getPreviewImage:(int)tag;
-(void)setupSession;
@end
