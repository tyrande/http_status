//
//  IBoolooHttpClient.h
//  http_status
//
//  Created by tyrande on 21/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

#import "AFHTTPClient.h"

#import "AFNetworking.h"

#define IBODOMAIN   @"http://192.168.101.99:1003"

@interface IBoolooHttpClient : AFHTTPClient

+(IBoolooHttpClient *)sharedClient;

-(void)ope:(NSString *)identify
parameters:params
   success:(void (^)(NSString *))success
   failure:(void (^)(NSString *))failure;

@end
