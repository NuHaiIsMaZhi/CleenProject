//
//  NetWorkTools.m
//  CleenProjectDemo
//
//  Created by saifing on 2018/2/26.
//  Copyright © 2018年 BKZ. All rights reserved.
//

#import "NetWorkTools.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "SVProgressHUD.h"

@implementation NetWorkTools

+(void)getDataShowHUD:(BOOL)show withUrl:(NSString *)urlString parameter:(NSDictionary *)parameterDictionary andResponse:(NetWorkToolsGetCompletionHandler)block{
    
    if (show)
    {
        [SVProgressHUD showWithStatus:@"请求中..."];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"请求的URL是------>🐤🐤🐤🐤🐤🐤🐤🐤🐤🐤🐤🐤🐤🐤🐤🐤🐤\n%@",urlString);
    
    NSLog(@"请求的参数是------>🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶\n%@",parameterDictionary);
    
    [manager GET:urlString parameters:parameterDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功------>💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰\n%@",data);
        if (show) {
            [SVProgressHUD dismiss];
        }
        
        if (data) {
            block(YES,data);
        }else
            block(NO,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        block(NO,nil);
    }];
}

@end
