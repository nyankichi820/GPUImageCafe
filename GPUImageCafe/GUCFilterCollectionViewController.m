//
//  GUCFilterCollectionViewController.m
//  GPUImageCafe
//
//  Created by masafumi yoshida on 2014/06/23.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "GUCFilterCollectionViewController.h"
#import "GUCAPIClient.h"
#import "GUCFilterCollectionViewCell.h"
#import "MYGPUImageFilterFactory.h"
#import <GPUImage/GPUImage.h>
#import "GUCEditFilterViewController.h"
#import "GUCUserFilterStore.h"

@interface GUCFilterCollectionViewController ()
@property(nonatomic,strong) GUCAPIClient  *client;
@property(nonatomic,strong) NSArray  *filters;
@end

@implementation GUCFilterCollectionViewController

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
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadFilter];
}

-(void)loadFilter{
    self.client = [[GUCAPIClient alloc] init];
    
    
    __weak typeof(self) weakSelf = self;
    [self.client filter:^(id result, NSError *error) {
        if(!error){
            NSMutableArray * filters = [NSMutableArray array];
            [filters addObjectsFromArray:result];
            [filters addObjectsFromArray:[GUCUserFilterStore shared].filters];
            weakSelf.filters =  filters;
            [weakSelf.collectionView reloadData];
        }
        else{
            NSLog(@"fetch error %@",error.description);
        }
        
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GUCFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCell" forIndexPath:indexPath];
    
    NSDictionary *config = [self.filters objectAtIndex:indexPath.row];
    
    cell.filterNameLabel.text = [config objectForKey:@"name"];
    
    GPUImageFilterGroup *filterGroup = [[[MYGPUImageFilterFactory alloc] init] createFilterGroupWithArray:[config objectForKey:@"configs"]];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(){
        UIImage *image = [filterGroup imageByFilteringImage:[UIImage imageNamed:@"sample_1.jpg"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = image;
        });
    });
    
        
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filters.count ;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"CopyFilter"]){
        GUCEditFilterViewController *viewController = (GUCEditFilterViewController *)segue.destinationViewController;
        
        
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
        NSDictionary *filterParameter =  [self.filters objectAtIndex:indexPath.row];
        viewController.filterParameter =filterParameter;
    }
    
}


@end
