//
//  GUCEditFilterTableViewController.m
//  GPUImageCafe
//
//  Created by masafumi yoshida on 2014/06/23.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "GUCEditFilterTableViewController.h"
#import "GUCGPUImageFilterFactory.h"
#import "GUCEditFilterViewController.h"
#import <FrameAccessor.h>
@interface GUCEditFilterTableViewController ()
@property (weak, nonatomic) IBOutlet UISlider *brightness;
@property (weak, nonatomic) IBOutlet UISlider *contrast;
@property (weak, nonatomic) IBOutlet UISlider *red;
@property (weak, nonatomic) IBOutlet UISlider *green;
@property (weak, nonatomic) IBOutlet UISlider *blue;
@property (weak, nonatomic) IBOutlet UISlider *whiteBlaccance;
@property (weak, nonatomic) IBOutlet UISlider *saturation;
@property (weak, nonatomic) IBOutlet UISlider *hue;
@property (weak, nonatomic) IBOutlet UISlider *vignetteStart;
@property (weak, nonatomic) IBOutlet UISlider *vignetteEnd;
@end

@implementation GUCEditFilterTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
 
    [self filterImage:self];
}


-(IBAction)filterImage:(id)sender{
    NSArray *params =  @[
                         @{@"class": @"Brightness",@"params":@{@"brightness":[NSNumber numberWithFloat:self.brightness.value]}},
                         @{@"class": @"Contrast",@"params":@{@"contrast":[NSNumber numberWithFloat:self.contrast.value]}},
                         @{@"class": @"RGB",@"params":@{
                                   @"red":[NSNumber numberWithFloat:self.red.value],
                                   @"green":[NSNumber numberWithFloat:self.green.value],
                                   @"blue":[NSNumber numberWithFloat:self.blue.value],
                                   }
                           },
                         @{@"class": @"WhiteBalance",@"params":@{@"temperature":[NSNumber numberWithFloat:self.whiteBlaccance.value]}},
                         @{@"class": @"Saturation",@"params":@{@"saturation":[NSNumber numberWithFloat:self.saturation.value]}},
                         @{@"class": @"Hue",@"params":@{@"hue":[NSNumber numberWithFloat:self.hue.value]}},
                          @{@"class": @"Vignette",@"params":@{
                                    @"vignetteStart":[NSNumber numberWithFloat:self.vignetteStart.value],
                                    @"vignetteEnd":[NSNumber numberWithFloat:self.vignetteEnd.value],
                                    }},
                         
                         ];
    
    GUCEditFilterViewController *parent = (GUCEditFilterViewController *)self.parentViewController;
    
    GPUImageFilterGroup *filterGroup = [[[GUCGPUImageFilterFactory alloc] init] createFilterGroupWithArray:params];
    
    for(UIImageView *imageView in parent.imageViews){
        UIImage *image = [filterGroup imageByFilteringImage:[parent getPreviewImage:imageView.tag]];
        imageView.image = image;
    }
    
    
    if(!parent.filter){
        parent.filter = filterGroup;
        [parent setupSession];
    }
    else{
        filterGroup = parent.filter;
        for(int i = 0 ; i< filterGroup.filterCount ; i++){
            GPUImageFilter *filter = [filterGroup filterAtIndex:i];
            NSDictionary *config   = [params objectAtIndex:i];
            NSDictionary *paramters = [config objectForKey:@"params"];
            for(NSString *name in paramters.allKeys ){
                [filter setValue:[paramters objectForKey:name] forKey:name];
            }
        }
        
    }
    
   
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
