//
//  hsSiteDetailViewController.m
//  http_status
//
//  Created by tyrande on 27/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

#import "hsSiteDetailViewController.h"
#import "hsParamsViewController.h"

#import "NimbusModels.h"
#import "NimbusCore.h"

#import "hsHttpEngine.h"

@interface hsSiteDetailViewController ()
@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;
@end

@implementation hsSiteDetailViewController

@synthesize model = _modal;
@synthesize actions = _actions;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg.png"]];
    self.tableView.opaque = NO;

}

- (void)loadSite:(NSString *)siteName {
    [[hsHttpEngine sharedEngine] reloadSite:siteName];
    _actions = [[NITableViewActions alloc] initWithTarget:self];
    NSDictionary *routes = [hsHttpEngine sharedEngine].routes;
    NSArray *siteArray = [[routes allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray* tableContents = [NSMutableArray array];
    [tableContents addObject:[NISubtitleCellObject objectWithTitle:siteName subtitle:[[hsHttpEngine sharedEngine].info objectForKey:@"Domain"]]];
    [tableContents addObject:@"Routes"];
    for (NSInteger ix = 0; ix < [routes count]; ++ix) {
        NSString *indentifer = [siteArray objectAtIndex:ix];
        NSString *subtitle = [[routes objectForKey:indentifer] objectForKey:@"Method"];
        subtitle = [subtitle stringByAppendingString:[NSString stringWithFormat:@" %@", [[routes objectForKey:indentifer] objectForKey:@"Path"]]];
        [tableContents addObject:[_actions attachToObject:[NISubtitleCellObject objectWithTitle:indentifer subtitle:subtitle]
                                          navigationBlock:^(id object, UIViewController* controller) {
                                              hsParamsViewController* paramsController = [[hsParamsViewController alloc] init];
                                              [paramsController loadDefaultParams:[object title]];
                                              [controller.navigationController pushViewController:paramsController animated:YES];
                                              return NO;
                                          }]];
    }
    self.model = [[NITableViewModel alloc] initWithSectionedArray:tableContents delegate:(id)[NICellFactory class]];
    self.tableView.delegate = [self.actions forwardingTo:self];
    self.tableView.dataSource = self.model;
    [self.tableView reloadData];
    
}

@end
