//
//  GUCEditFilterTableViewController.m
//  GPUImageCafe
//
//  Created by masafumi yoshida on 2014/06/23.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "GUCEditFilterTableViewController.h"

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
@property (weak, nonatomic) IBOutlet UISlider *sharpen;


@property (weak, nonatomic) IBOutlet UISwitch *vignetteEnable;
@property (weak, nonatomic) IBOutlet UISlider *vignetteStart;
@property (weak, nonatomic) IBOutlet UISlider *vignetteEnd;


@property (weak, nonatomic) IBOutlet UISwitch *tiltShiftEnable;
@property (weak, nonatomic) IBOutlet UISlider *tiltShiftTopFocusLevel;
@property (weak, nonatomic) IBOutlet UISlider *tiltShiftBottomFocusLevel;
@property (weak, nonatomic) IBOutlet UISlider *tiltShiftFocusFallOffRate;
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
    if(self.filterParameter){
        [self loadFilterParameter];
    }
    
}

-(void)loadFilterParameter{
    self.navigationItem.title =[self.filterParameter objectForKey:@"name"];
    NSArray *configs = [self.filterParameter objectForKey:@"configs"];
    
    for(NSDictionary *config in configs ){
        if([[config objectForKey:@"class"] isEqualToString:@"Brightness"]){
            self.brightness.value = [[[config objectForKey:@"params"] objectForKey:@"brightness"] floatValue];
        }
        else if([[config objectForKey:@"class"] isEqualToString:@"Contrast"]){
            self.contrast.value = [[[config objectForKey:@"params"] objectForKey:@"contrast"] floatValue];
        }
        else if([[config objectForKey:@"class"] isEqualToString:@"RGB"]){
            self.red.value   = [[[config objectForKey:@"params"] objectForKey:@"red"] floatValue];
            self.green.value = [[[config objectForKey:@"params"] objectForKey:@"green"] floatValue];
            self.blue.value  = [[[config objectForKey:@"params"] objectForKey:@"blue"] floatValue];
       }
        else if([[config objectForKey:@"class"] isEqualToString:@"WhiteBalance"]){
            self.whiteBlaccance.value = [[[config objectForKey:@"params"] objectForKey:@"temperature"] floatValue];
        }
        else if([[config objectForKey:@"class"] isEqualToString:@"Saturation"]){
            self.saturation.value = [[[config objectForKey:@"params"] objectForKey:@"saturation"] floatValue];
        }
        else if([[config objectForKey:@"class"] isEqualToString:@"Hue"]){
            self.hue.value = [[[config objectForKey:@"params"] objectForKey:@"hue"] floatValue];
        }
        else if([[config objectForKey:@"Sharpen"] isEqualToString:@"Hue"]){
            self.sharpen.value = [[[config objectForKey:@"params"] objectForKey:@"sharpness"] floatValue];
        }
        else if([[config objectForKey:@"class"] isEqualToString:@"Vignette"]){
            self.vignetteEnable.on = YES;
            self.vignetteStart.value = [[[config objectForKey:@"params"] objectForKey:@"vignetteStart"] floatValue];
            self.vignetteEnd.value = [[[config objectForKey:@"params"] objectForKey:@"vignetteEnd"] floatValue];
        }
        else if([[config objectForKey:@"class"] isEqualToString:@"TiltShift"]){
            self.tiltShiftEnable.on =  YES;
            self.tiltShiftTopFocusLevel.value = [[[config objectForKey:@"params"] objectForKey:@"topFocusLevel"] floatValue];
            self.tiltShiftBottomFocusLevel.value = [[[config objectForKey:@"params"] objectForKey:@"bottomFocusLevel"] floatValue];
            self.tiltShiftFocusFallOffRate.value = [[[config objectForKey:@"params"] objectForKey:@"focusFallOffRate"] floatValue];
        }

        
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self filterImage:self];
}


-(NSArray*)createFilterParameter{
    
    NSMutableArray *params =  [NSMutableArray arrayWithArray:@[
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
                                                               @{@"class": @"Sharpen",@"params":@{@"sharpness":[NSNumber numberWithFloat:self.sharpen.value]}},
                                                               
                                                               
                                                               ]];
    
    if(self.vignetteEnable.on){
        [params addObject: @{@"class": @"Vignette",@"params":@{
                                     @"vignetteStart":[NSNumber numberWithFloat:self.vignetteStart.value],
                                     @"vignetteEnd":[NSNumber numberWithFloat:self.vignetteEnd.value],
                                     }}];
    }
    
    if(self.tiltShiftEnable.on){
        
        [params addObject:@{@"class": @"TiltShift",@"params":@{
                                    @"topFocusLevel":[NSNumber numberWithFloat:self.tiltShiftFocusFallOffRate.value],
                                    @"bottomFocusLevel":[NSNumber numberWithFloat:self.tiltShiftBottomFocusLevel.value],
                                    @"focusFallOffRate":[NSNumber numberWithFloat:self.tiltShiftFocusFallOffRate.value],
                                    }}];
    }
    return params;
}

-(IBAction)filterImage:(id)sender{
    NSArray *params = [self createFilterParameter];
    
    GUCEditFilterViewController *parent = (GUCEditFilterViewController *)self.parentViewController;
    [parent updateFilterParams:params];
       
    
    
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
