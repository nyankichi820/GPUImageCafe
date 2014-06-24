//
//  GUCGPUImageFilterFactory.h
//  GPUImageCafe
//
//  Created by masafumi yoshida on 2014/06/23.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage.h>
@interface GUCGPUImageFilterFactory : NSObject
-(GPUImageFilterGroup*)createFilterGroupWithArray:(NSArray*)array;
-(GPUImageFilter*)createFilterWithDictionary:(NSDictionary*)dictionary;
@end
