

//
//  GUCEditFilterViewController.m
//  GPUImageCafe
//
//  Created by masafumi yoshida on 2014/06/23.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "GUCEditFilterViewController.h"
#import <FrameAccessor.h>
#import "MYGPUImageFilterFactory.h"
#import "GUCEditFilterTableViewController.h"
#import "GUCUserFilterStore.h"
#import <UIActionSheet+BlocksKit.h>
#import <MessageUI/MessageUI.h>
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
    if(self.filterParameter){
        self.saveButton.enabled = YES;
        self.filterNameTextFiled.text = [self.filterParameter objectForKey:@"name"];
    }
    

    // Do any additional setup after loading the view.
  
    
}

-(BOOL)isDeviceiPad{
    NSString *model = [UIDevice currentDevice].model;
    if ([model isEqualToString:@"iPad"]) {
        return YES;
    }
    return NO;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if([AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count == 0){
        [self.previewVideoContainer removeFromSuperview];
    }
}

-(void)setupSession{
    self.isVideoRunning = YES;
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    self.videoCamera.outputImageOrientation = [self isDeviceiPad] ? UIInterfaceOrientationLandscapeRight :  UIInterfaceOrientationPortrait ;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    self.videoCamera.horizontallyMirrorRearFacingCamera =NO;
    
    [self.videoCamera addTarget:self.filter];
    
    GPUImageView *filterView = self.previewView;
    
    [self.filter addTarget:filterView];
    
    
    [self.videoCamera startCameraCapture];
    
    
}

-(IBAction)selectCompose:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:@"設定を保存"];
    __weak typeof(self) weakSelf = self;
    
    [actionSheet bk_addButtonWithTitle:@"設定をローカルに保存" handler:^{
        [weakSelf saveFilter];
    }];
    

    
    if( [ MFMailComposeViewController canSendMail ] == YES )
    {
        [actionSheet bk_addButtonWithTitle:@"パラメーターをメールで送る" handler:^{
                MFMailComposeViewController * controller = [  [ MFMailComposeViewController alloc ] init ] ;
                [ controller setSubject:@"フィルターパラメーター"];
            
                [controller addAttachmentData:[[[MYGPUImageFilterFactory alloc] init] createFilterParameterJSONDataWithParameter:self.filterParameter]  mimeType:@"text/json" fileName:@"filter.json"];
                controller.mailComposeDelegate = self;
            
                [ self presentModalViewController:controller animated:YES ];

        }];
    }

    
    [actionSheet bk_setCancelButtonWithTitle:@"キャンセル" handler:^{
        
    }];
    
    [actionSheet showInView:self.view];
    
    
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)saveFilter{

    NSMutableArray * filters = [NSMutableArray array];
    [filters addObjectsFromArray:[GUCUserFilterStore shared].filters];
    [filters addObject:self.filterParameter];
    [[GUCUserFilterStore shared] save:filters];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)stopSession{
    
    [self.filter removeAllTargets];
    [self.videoCamera removeAllTargets];
    [self.videoCamera stopCameraCapture];
    self.isVideoRunning = NO;
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



-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    
    if ([textField.text length] > 10) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil                                                            message:@"Filter Nameは10文字以内にしてください"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];

        textField.text = [textField.text substringToIndex:10-1];
        return NO;
    }

    [textField resignFirstResponder];
    if(textField.text.length > 0){
        self.filterParameter = @{@"name":self.filterNameTextFiled.text , @"configs":[self.filterParameter objectForKey:@"configs"]};
        
        self.saveButton.enabled = YES;
    }
    else{
        self.saveButton.enabled = NO;
    }
    
    
    return YES;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   
    if ([textField.text length] > 10) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil                                                            message:@"Filter Nameは10文字以内にしてください"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
         [textField resignFirstResponder];
        textField.text = [textField.text substringToIndex:10-1];
        
        return NO;
    }
 
    return YES;
}




-(void)updateFilterParams:(NSArray*)params{
    
    self.filterParameter = @{@"name":self.filterNameTextFiled.text , @"configs":params};
    
    if(!self.filter){
        self.filter = [[[MYGPUImageFilterFactory alloc] init] createFilterGroupWithArray:params];
    }
    else if(self.filter.filterCount != params.count){
        if(self.isVideoRunning){
            [self stopSession];
        }
        self.filter = [[[MYGPUImageFilterFactory alloc] init] createFilterGroupWithArray:params];
    }
    else{
        for(int i = 0 ; i< self.filter.filterCount ; i++){
            GPUImageFilter *filter = ( GPUImageFilter *)[self.filter filterAtIndex:i];
            NSDictionary *config   = [params objectAtIndex:i];
            NSDictionary *paramters = [config objectForKey:@"params"];
            for(NSString *name in paramters.allKeys ){
                [filter setValue:[paramters objectForKey:name] forKey:name];
            }
        }
    }
    [self applyFilter];
    
}

-(void)applyFilter{
    if(!self.filter){
        return;
    }
    UIView *previewView = [[self.previewContainer subviews] lastObject];
    
  
    if([previewView isKindOfClass:[UIImageView class]]){
        UIImageView *imageView = (UIImageView*)previewView;
        UIImage *image = [self.filter imageByFilteringImage:[self getPreviewImage:imageView.tag]];
        imageView.image = image;
        
    }
    else{
        if(!self.isVideoRunning){
            [self setupSession];
        }
        
    }
}

-(UIImage*)getPreviewImage:(int)tag{
    return [UIImage imageNamed:[NSString stringWithFormat:@"sample_%d.jpg",tag]];
}

-(IBAction)togglePreview:(UITapGestureRecognizer*)gesture{
    UIView *view = gesture.view;
    if([view isKindOfClass:[GPUImageView class] ] &&  self.isVideoRunning){
        [self stopSession];
    }
    
    [UIView animateKeyframesWithDuration:0.4
                                   delay:0
                                 options:UIViewAnimationOptionTransitionCurlUp
                              animations:^{
        view.y = -( view.height + 10);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        view.frame =self.previewContainer.frame;
        view.y = 0;
        [self.previewContainer insertSubview:view atIndex:0];
        [self applyFilter];
        
    }];
 
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"EditFilterTableView"]){
        GUCEditFilterTableViewController *viewController = (GUCEditFilterTableViewController *)segue.destinationViewController;
        viewController.filterParameter = self.filterParameter;
    }
}


@end
