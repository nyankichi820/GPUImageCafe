//
//  FVViewer.h
//  five
//
//  Created by masafumi yoshida on 2014/06/20.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GUCUserFilterStore : NSObject
@property (nonatomic,strong) NSArray *filters;
+ (GUCUserFilterStore *) shared;
-(void)save:(NSArray*)filters;
@end
