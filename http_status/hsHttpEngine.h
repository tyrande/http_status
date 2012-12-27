//
//  hsHttpEngine.h
//  http_status
//
//  Created by tyrande on 26/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

@interface hsHttpEngine : NSObject
@property (nonatomic, readwrite) NSString* siteName;
@property (nonatomic, readwrite, retain) NSDictionary* info;
@property (nonatomic, readwrite, retain) NSDictionary* routes;

+(hsHttpEngine *)sharedEngine;
+(void)loadSiteConfig:(void (^)(void))success;
+(NSMutableDictionary *)sites;
+(NSMutableDictionary *)site:(NSString *)siteName;

-(void)reloadSite:(NSString *)siteName;

-(void)ope:(NSString *)identify
parameters:(NSMutableDictionary *)params
   success:(void (^)(NSDictionary *))success
   failure:(void (^)(NSDictionary *))failure;
@end
