

//
//  GUCGPUImageFilterFactory.m
//  GPUImageCafe
//
//  Created by masafumi yoshida on 2014/06/23.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "GUCGPUImageFilterFactory.h"
#import <GPUImage/GPUImage.h>
@implementation GUCGPUImageFilterFactory


-(GPUImageFilterGroup*)createFilterGroupWithArray:(NSArray*)array
{
    GPUImageFilterGroup *filterGroup                 = [[GPUImageFilterGroup alloc ] init];
    GPUImageFilter *currentFilter =(GPUImageFilter *) filterGroup;
    
  
    for(NSDictionary *config in array){
        GPUImageFilter *filter = [self createFilterWithDictionary:config];
        [currentFilter addTarget:filter];
        [filterGroup addFilter:filter];
        if([array.firstObject isEqual:config]){
            [filterGroup setInitialFilters:@[filter]];
        }
        else if([array.lastObject isEqual:config]){
            [filterGroup setTerminalFilter:filter];
        }
        currentFilter = filter;
    
    }
    return filterGroup;
}



-(GPUImageFilter*)createFilterWithDictionary:(NSDictionary*)dictionary
{
    GPUImageFilter *filter = [[NSClassFromString([NSString stringWithFormat:@"GPUImage%@Filter",[dictionary objectForKey:@"class"] ]) alloc] init];
    NSDictionary *paramters = [dictionary objectForKey:@"params"];
    for(NSString *name in paramters.allKeys ){
        [filter setValue:[paramters objectForKey:name] forKey:name];
    }
    return filter;
}



@end
