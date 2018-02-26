//
//  NetWorkTools.h
//  CleenProjectDemo
//
//  Created by saifing on 2018/2/26.
//  Copyright © 2018年 BKZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkTools : NSObject

typedef void(^NetWorkToolsGetCompletionHandler)(BOOL sucess, id contentData);

+(void)getDataShowHUD:(BOOL)show withUrl:(NSString *)urlString parameter:(NSDictionary *)parameterDictionary andResponse:(NetWorkToolsGetCompletionHandler)block;

@end
