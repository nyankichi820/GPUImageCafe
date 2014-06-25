
//
//  FVViewer.m
//  five
//
//  Created by masafumi yoshida on 2014/06/20.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "GUCUserFilterStore.h"

@implementation GUCUserFilterStore
static GUCUserFilterStore *instance = nil;

+ (GUCUserFilterStore *) shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ GUCUserFilterStore alloc ] init ];
        instance.filters = @[];
        [instance restore];
    });
    return (instance);
}



-(void)save:(NSArray*)filters{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    
    NSData * encodedData = [NSKeyedArchiver archivedDataWithRootObject:self.filters];
    [ud setObject:encodedData forKey:@"filters"];
    [ud synchronize];
    self.filters = filters;
    
}

-(void)restore{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    
    NSData * encodedData = [ud dataForKey:@"filters"];
    
    if(encodedData){
        self.filters = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
    }
    
  
}

@end
