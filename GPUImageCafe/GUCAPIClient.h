//
//  SWAPIClient.h
//  Surfwave
//
//  Created by masafumi yoshida on 2014/06/18.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^GUCAPIClientProgressBlocks)(double percent);
typedef void (^GUCAPIClientCompleteBlocks)(id result,NSError *error);

@interface GUCAPIClient : NSObject


-(void)filter:(GUCAPIClientCompleteBlocks)complete;



@end
