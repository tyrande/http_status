//
//  IBoolooHttpClient.m
//  http_status
//
//  Created by tyrande on 21/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

#import "IBoolooHttpClient.h"

@interface IBoolooHttpClient()

-(void)logResponse:(NSHTTPURLResponse *)response;

@end

@implementation IBoolooHttpClient

+(IBoolooHttpClient *)sharedClient
{
    static IBoolooHttpClient *sharedClient;
    @synchronized(self)
    {
        if (!sharedClient)
        {
            sharedClient = [[IBoolooHttpClient alloc] init];
            [sharedClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        }
        return sharedClient;
    }
}

- (id)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:IBODOMAIN]];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"routes" ofType:@"plist"];
    self.routes = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//    NSLog(@"Routes %@", self.routes);
    return self;
}

-(void)ope:(NSString *)identify
parameters:params
   success:(void (^)(NSDictionary *))success
   failure:(void (^)(NSDictionary *))failure
{
    NSMutableDictionary *route = [self.routes objectForKey:identify];
    [params addEntriesFromDictionary: [route objectForKey:@"Params"]];
    NSMutableURLRequest *request = [self requestWithMethod:[route objectForKey:@"Method"] path:[route objectForKey:@"Path"] parameters:params];
//    NSLog(@"Req Header: %@", [request allHTTPHeaderFields]);
//    NSURL *cookieURL = [NSURL URLWithString:IBODOMAIN];
//    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:cookieURL];
//    NSLog(@"Cookies: %@", cookies);
//    NSLog(@"Cookies: %@",[[NSHTTPCookieStorage sharedHTTPCookieStorage]cookies]);
    AFHTTPRequestOperation *operation =
        [self HTTPRequestOperationWithRequest:request
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                  [self logResponse:[operation response]];
                  if (success) {
                      NSError* error;
                      NSDictionary *bodyJson =
                      [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                      options:NSJSONReadingMutableLeaves
                                                        error:&error];
//                      NSLog(@"%@", bodyJson);
                      success([NSDictionary dictionaryWithObjectsAndKeys:
                               [[operation response] allHeaderFields], @"Response",
                               [[operation request] allHTTPHeaderFields], @"Request",
                               bodyJson, @"Body", nil]);
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                  [self logResponse:[operation response]];
                  if (failure) {
                      NSError* error;
                      NSDictionary *resjson =
                      [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                      options:NSJSONReadingMutableLeaves
                                                        error:&error];
//                      NSLog(@"%@", resjson);
                    failure(resjson);
                  }
              }];
    [operation start];
}

-(void)logResponse:(NSHTTPURLResponse *)response
{
    NSDictionary *fields = [response allHeaderFields];
    NSLog(@"Response Headers: %@", fields);
//    NSLog(@"Cookies: %@", [fields objectForKey:@"Set-Cookie"]);
}

@end
