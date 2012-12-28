//
//  hsHeadersViewController.m
//  http_status
//
//  Created by tyrande on 25/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

#import "hsHeadersViewController.h"

#import "hsHeaderDetailViewController.h"
#import "hsCookieDetailViewController.h"

#import "NimbusModels.h"
#import "NimbusCore.h"

@interface hsHeadersViewController ()
@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;
@end

@implementation hsHeadersViewController

@synthesize model = _model;
@synthesize actions = _actions;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = _model;
}

- (void)setHeaders:(NSDictionary *)httpResponse {
    NSDictionary *requestHeader = [httpResponse objectForKey:@"Request"];
    NSDictionary *responseHeader = [httpResponse objectForKey:@"Response"];
    NSArray *cookies = [httpResponse objectForKey:@"Cookies"];
    NSArray *requestHeaderTitles = [[requestHeader allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSArray *responseHeaderTitles = [[responseHeader allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    _actions = [[NITableViewActions alloc] initWithTarget:self];
    NSMutableArray* tableContents = [NSMutableArray array];
    [tableContents addObject:@"Cookies"];
    for (NSHTTPCookie *cookie in cookies) {
        [tableContents addObject:[_actions attachToObject:[NISubtitleCellObject objectWithTitle:cookie.name subtitle:cookie.value]
                                          navigationBlock:^(id object, UIViewController* controller) {
                                              hsCookieDetailViewController* cookieDetailController = [[hsCookieDetailViewController alloc] init];
                                              [cookieDetailController showCookie:cookie];
                                              [controller.navigationController pushViewController:cookieDetailController animated:YES];
                                              return NO;
                                          }]];
    }
    [tableContents addObject:@"Request Header"];
    for (NSInteger ix = 0; ix < [requestHeaderTitles count]; ++ix) {
        NSString *requestHeaderTitle = [requestHeaderTitles objectAtIndex:ix];
        [tableContents addObject:[_actions attachToObject:[NISubtitleCellObject objectWithTitle:requestHeaderTitle subtitle:[requestHeader objectForKey:requestHeaderTitle]]
                                  navigationBlock:^(id object, UIViewController* controller) {
                                      hsHeaderDetailViewController* headerDetailController = [[hsHeaderDetailViewController alloc] init];
                                      [headerDetailController showDetail:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                          [object title], @"Title",
                                                                          [object subtitle], @"SubTitle", nil]];
                                      [controller.navigationController pushViewController:headerDetailController animated:YES];
                                      return NO;
                                  }]];
    }
    [tableContents addObject:@"Response Header"];
    for (NSInteger ix = 0; ix < [responseHeaderTitles count]; ++ix) {
        NSString *responseHeaderTitle = [responseHeaderTitles objectAtIndex:ix];
        [tableContents addObject:[_actions attachToObject:[NISubtitleCellObject objectWithTitle:responseHeaderTitle subtitle:[responseHeader objectForKey:responseHeaderTitle]]
                                          navigationBlock:^(id object, UIViewController* controller) {
                                              hsHeaderDetailViewController* headerDetailController = [[hsHeaderDetailViewController alloc] init];
                                              [headerDetailController showDetail:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                  [object title], @"Title",
                                                                                  [object subtitle], @"SubTitle", nil]];
                                              [controller.navigationController pushViewController:headerDetailController animated:YES];
                                              return NO;
                                          }]];
    
    }
    self.model = [[NITableViewModel alloc] initWithSectionedArray:tableContents delegate:(id)[NICellFactory class]];
    self.tableView.delegate = [self.actions forwardingTo:self];
    [self.tableView reloadData];
}
@end
