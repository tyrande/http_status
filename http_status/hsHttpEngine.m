//
//  hsHttpEngine.m
//  http_status
//
//  Created by tyrande on 26/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

#import "hsHttpEngine.h"

#import "AFNetworking.h"

@interface hsHttpEngine()
@property (nonatomic, readwrite, retain) NSURL *baseURL;
@property (nonatomic, assign) NSStringEncoding stringEncoding;
@property (readwrite, nonatomic) NSMutableDictionary *defaultHeaders;
@property (nonatomic, assign) AFHTTPClientParameterEncoding parameterEncoding;
@end

@implementation hsHttpEngine

@synthesize siteName = _siteName;
@synthesize info = _info;
@synthesize routes = _routes;
@synthesize stringEncoding = _stringEncoding;
@synthesize defaultHeaders = _defaultHeaders;
@synthesize parameterEncoding = _parameterEncoding;

+(hsHttpEngine *)sharedEngine {
    static hsHttpEngine *sharedEngine;
    @synchronized(self) {
        if (!sharedEngine) {
            sharedEngine = [[hsHttpEngine alloc] init];
        }
        return sharedEngine;
    }
}

+(void)loadSiteConfig:(void (^)(void))success {
    NSURLRequest *request = [NSURLRequest requestWithURL : [NSURL URLWithString:@"http://192.168.101.99:1001/plist/site.xml"]];
    AFURLConnectionOperation *operation = [[AFURLConnectionOperation alloc] initWithRequest:request];
    operation.completionBlock =^{
        NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSString *plistPath = [hsHttpEngine plistPath:@"sites"];
        [data writeToFile:plistPath atomically:YES];
        NSDictionary *siteDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        for (NSString *siteName in [siteDictionary allKeys]) {
            NSURLRequest *request = [NSURLRequest requestWithURL : [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.101.99:1001/plist/%@.xml", siteName]]];
            AFURLConnectionOperation *operation = [[AFURLConnectionOperation alloc] initWithRequest:request];
            operation.completionBlock =^{
                NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                NSString *plistPath = [hsHttpEngine plistPath:siteName];
                [data writeToFile:plistPath atomically:YES];
            };
            [operation start];
        }
        success();
    };
    [operation start];
}

+(NSString *)plistPath:(NSString *)filename {
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@.plist", documentsDirectory, filename];
    return filePath;
}

+(NSMutableDictionary *)sites {
    NSMutableDictionary *siteDictionary = [hsHttpEngine getPlist:@"sites"];
    return siteDictionary;
}

+(NSMutableDictionary *)site:(NSString *)siteName {
    NSMutableDictionary *siteDictionary = [hsHttpEngine getPlist:siteName];
    return siteDictionary;
}

+(NSMutableDictionary *)getPlist:(NSString *)siteName {
    NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc] init];
    NSString *plistPath = [hsHttpEngine plistPath:siteName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
    return plistDictionary;
}

-(hsHttpEngine *)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.defaultHeaders = [NSMutableDictionary dictionary];
    [self setDefaultHeader:@"User-Agent" value:[NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey], (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f)]];
    return self;
}

-(void)reloadSite:(NSString *)siteName {
    self.siteName = siteName;
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:siteName ofType:@"plist"];
//    NSDictionary *siteConfig = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *siteConfig = [hsHttpEngine site:siteName];
    self.info = [siteConfig objectForKey:@"Info"];
    self.routes = [siteConfig objectForKey:@"Routes"];
    self.baseURL = [NSURL URLWithString:[self.info objectForKey:@"Domain"]];
    self.stringEncoding = NSUTF8StringEncoding;
    self.parameterEncoding = AFFormURLParameterEncoding;
}

- (void)setDefaultHeader:(NSString *)header value:(NSString *)value {
	[self.defaultHeaders setValue:value forKey:header];
}

-(void)ope:(NSString *)identify
parameters:(NSMutableDictionary *)params
   success:(void (^)(NSDictionary *))success
   failure:(void (^)(NSDictionary *))failure {
    NSMutableDictionary *route = [self.routes objectForKey:identify];
    NSString *path = [route objectForKey:@"Path"];
    NSString *routeId = [params objectForKey:@"id"];
    if (routeId) {
        [params removeObjectForKey:routeId];
        [path stringByAppendingString:[NSString stringWithFormat:@"/%@", routeId]];
    }
    NSLog(@"Ope: %@", path);
    NSMutableURLRequest *request = [self requestWithMethod:[route objectForKey:@"Method"] path:path parameters:params];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([self operationToDictionary:operation]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure([self operationToDictionary:operation]);
    }];
    [operation start];
}

- (NSDictionary *)operationToDictionary:(AFHTTPRequestOperation *)operation {
    NSDictionary *operationDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [[operation response] allHeaderFields], @"Response",
                                         [[operation request] allHTTPHeaderFields], @"Request",
                                         [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies], @"Cookies",
                                         operation.responseString, @"Body", nil];
    return operationDictionary;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
    if (!path) {
        path = @"";
    }
    
    NSURL *url = [NSURL URLWithString:path relativeToURL:self.baseURL];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:method];
    [request setAllHTTPHeaderFields:self.defaultHeaders];
	
    if (parameters) {
        if ([method isEqualToString:@"GET"] || [method isEqualToString:@"HEAD"] || [method isEqualToString:@"DELETE"]) {
            url = [NSURL URLWithString:[[url absoluteString] stringByAppendingFormat:[path rangeOfString:@"?"].location == NSNotFound ? @"?%@" : @"&%@", AFQueryStringFromParametersWithEncoding(parameters, self.stringEncoding)]];
            [request setURL:url];
        } else {
            NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
            NSError *error = nil;
            
            switch (self.parameterEncoding) {
                case AFFormURLParameterEncoding:;
                    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                    [request setHTTPBody:[AFQueryStringFromParametersWithEncoding(parameters, self.stringEncoding) dataUsingEncoding:self.stringEncoding]];
                    break;
                case AFJSONParameterEncoding:;
                    [request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error]];
                    break;
                case AFPropertyListParameterEncoding:;
                    [request setValue:[NSString stringWithFormat:@"application/x-plist; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                    [request setHTTPBody:[NSPropertyListSerialization dataWithPropertyList:parameters format:NSPropertyListXMLFormat_v1_0 options:0 error:&error]];
                    break;
            }
            
            if (error) {
                NSLog(@"%@ %@: %@", [self class], NSStringFromSelector(_cmd), error);
            }
        }
    }
    
	return request;
}

@end
