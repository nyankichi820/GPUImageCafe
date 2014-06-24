

//
//  GUCEditFilterViewController.m
//  GPUImageCafe
//
//  Created by masafumi yoshida on 2014/06/23.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "GUCEditFilterViewController.h"
#import <FrameAccessor.h>
@interface GUCEditFilterViewController ()

@end

@implementation GUCEditFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    
}

-(void)setupSession{
    NSString *quality;
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationLandscapeRight;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    self.videoCamera.horizontallyMirrorRearFacingCamera =NO;
    
    [self.videoCamera addTarget:self.filter];
    
    GPUImageView *filterView = self.previewView;
    
    [self.filter addTarget:filterView];
    
    
    [_videoCamera startCameraCapture];
    
    
}


- (void)setupedCapture:(AVCaptureSession*)captureSession{
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    
    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]){
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil                                                            message:@"マイクへのアクセス権限がありません。プライバシー設定でアクセスを有効にしてください"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }
    
    NSLog(@"setup init session");
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.previewLayer.backgroundColor = [[UIColor blackColor] CGColor];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        CALayer *rootLayer = [self.previewView layer];
        [rootLayer setMasksToBounds:YES];
        [self.previewLayer setFrame:[rootLayer bounds]];
        [rootLayer addSublayer:self.previewLayer];
        
        
 
    });
    
    
    
}

-(UIImage*)getPreviewImage:(int)tag{
    return [UIImage imageNamed:[NSString stringWithFormat:@"sample_%d.jpg",tag]];
}

-(IBAction)togglePreview:(UITapGestureRecognizer*)gesture{
    UIView *view = gesture.view;
    [UIView animateKeyframesWithDuration:0.4 delay:0 options:0 animations:^{
        view.y = -200;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
         view.y = 92;
        [self.view insertSubview:view atIndex:0];
    }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
