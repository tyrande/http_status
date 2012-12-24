//
//  IBoolooHttpClient.m
//  http_status
//
//  Created by tyrande on 21/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

#import "IBoolooHttpClient.h"

@interface IBoolooHttpClient()

@property (readwrite, nonatomic, strong)NSMutableDictionary *routes;

-(void)logResponse:(NSHTTPURLResponse *)response;

@end

@implementation IBoolooHttpClient

+(IBoolooHttpClient *)sharedClient
{
    static IBoolooHttpClient *sharedClient;
    @synchronized(self)
    {
        if (!sharedClient)
            sharedClient = [[IBoolooHttpClient alloc] init];
        
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
   success:(void (^)(NSString *))success
   failure:(void (^)(NSString *))failure
{
    NSMutableDictionary *route = [self.routes objectForKey:identify];
    [params addEntriesFromDictionary: [route objectForKey:@"Params"]];
    NSMutableURLRequest *request = [self requestWithMethod:[route objectForKey:@"Method"] path:[route objectForKey:@"Path"] parameters:params];
    NSLog(@"Req Header: %@", [request allHTTPHeaderFields]);
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                          [self logResponse:[operation response]];
                                                                          if (success) {
                                                                              success(operation.responseString);
                                                                          }
                                                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                          [self logResponse:[operation response]];
                                                                          if (failure) {
                                                                              failure(operation.responseString);
                                                                          }
                                                                      }];
    [operation start];
}

//-(void)login:(NSDictionary *)params
//     success:(void (^)(NSString *))success
//     failure:(void (^)(NSString *))failure
//{
//    [self postPath:@""
//       parameters:params
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              [self logResponse:[operation response]];
//              if (success) {
//                  success(operation.responseString);
//              }
//          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              [self logResponse:[operation response]];
//              if (failure) {
//                  failure(operation.responseString);
//              }
//          }];
//}
//
//-(void)noticeWithSuccess:(void (^)(NSString *))success
//                 failure:(void (^)(NSString *))failure
//{
//    [self getPath:@"/users/notice"
//       parameters:[NSMutableDictionary dictionary]
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              NSLog(@"ID: %@", responseObject);
//              [self logResponse:[operation response]];
//              if (success) {
//                  success(operation.responseString);
//              }
//          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              [self logResponse:[operation response]];
//              if (failure) {
//                  failure(operation.responseString);
//              }
//          }];
//}

-(void)logResponse:(NSHTTPURLResponse *)response
{
    NSDictionary *fields = [response allHeaderFields];
    NSLog(@"Response Headers: %@", fields);
//    NSLog(@"Cookies: %@", [fields objectForKey:@"Set-Cookie"]);
}

//- (void)login:(NSString *)name
//      success:(void (^)(NSString *))success
//      failure:(void (^)(NSString *))failure
//{
//    NSLog(@"Req Header: %@", [self defaultValueForHeader:@"Accept"]);
//    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"" parameters:[NSMutableDictionary dictionary]];
//    NSLog(@"Req Header: %@", [request allHTTPHeaderFields]);
//    [self getPath:@""
//        parameters:[NSMutableDictionary dictionary]
//           success:^(AFHTTPRequestOperation *operation, id responseObject) {
//               NSDictionary *fields = [[operation response] allHeaderFields];
//               NSLog(@"Success: %@", fields);
//               NSLog(@"Cookies: %@", [fields objectForKey:@"Set-Cookie"]);
//               if (success) {
//                   success(operation.responseString);
//               }
//           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//               NSLog(@"Failure: %@", [[operation response] allHeaderFields]);
//               if (failure) {
//                   failure(operation.responseString);
//               }
//           }];
//
//}
@end
