

//
//  GUCGPUImageFilterFactory.m
//  GPUImageCafe
//
//  Created by masafumi yoshida on 2014/06/23.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "MYGPUImageFilterFactory.h"
#import <GPUImage/GPUImage.h>
@implementation MYGPUImageFilterFactory


-(NSString*)createFilterParameterJSONWithParameter:(NSDictionary *)configSet{
    NSData *data = [self createFilterParameterJSONDataWithParameter:configSet];
    if(!data){
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(NSData*)createFilterParameterJSONDataWithParameter:(NSDictionary *)configSet{
    NSError *error;
    NSData *data =  [NSJSONSerialization dataWithJSONObject:configSet options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        NSLog(error.description);
        return nil;
    }
    return data;
}


-(GPUImageFilterGroup*)createFilterGroupWithArray:(NSArray*)filterParameters
{
    GPUImageFilterGroup *filterGroup                 = [[GPUImageFilterGroup alloc ] init];
    GPUImageFilter *currentFilter =(GPUImageFilter *) filterGroup;
    
  
    for(NSDictionary *config in filterParameters){
        GPUImageFilter *filter = [self createFilterWithDictionary:config];
        [currentFilter addTarget:filter];
        [filterGroup addFilter:filter];
        if([filterParameters.firstObject isEqual:config]){
            [filterGroup setInitialFilters:@[filter]];
        }
        else if([filterParameters.lastObject isEqual:config]){
            [filterGroup setTerminalFilter:filter];
        }
        currentFilter = filter;
    
    }
    return filterGroup;
}




-(GPUImageFilter*)createFilterWithDictionary:(NSDictionary*)config
{
    GPUImageFilter *filter = [[NSClassFromString([NSString stringWithFormat:@"GPUImage%@Filter",[config objectForKey:@"class"] ]) alloc] init];
    NSDictionary *paramters = [config objectForKey:@"params"];
    for(NSString *name in paramters.allKeys ){
        [filter setValue:[paramters objectForKey:name] forKey:name];
    }
    return filter;
}



@end
