//
//  hsSiteDetailViewController.m
//  http_status
//
//  Created by tyrande on 27/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

#import "hsSiteDetailViewController.h"
#import "hsResponseViewController.h"

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSite:(NSString *)siteName {
    [[hsHttpEngine sharedEngine] reloadSite:siteName];
    _actions = [[NITableViewActions alloc] initWithTarget:self];
    NSDictionary *routes = [hsHttpEngine sharedEngine].routes;
    NSLog(@"Routes: %@", routes);
    NSArray *siteArray = [[routes allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray* tableContents = [NSMutableArray array];
    for (NSInteger ix = 0; ix < [routes count]; ++ix) {
        NSString *indentifer = [siteArray objectAtIndex:ix];
        NSString *subtitle = [[routes objectForKey:indentifer] objectForKey:@"Method"];
        subtitle = [subtitle stringByAppendingString:[NSString stringWithFormat:@" %@", [[routes objectForKey:indentifer] objectForKey:@"Path"]]];
        [tableContents addObject:[_actions attachToObject:[NISubtitleCellObject objectWithTitle:indentifer subtitle:subtitle]
                                          navigationBlock:^(id object, UIViewController* controller) {
                                              hsResponseViewController* resController = [[hsResponseViewController alloc] init];
                                              [resController requestWithIdentifer:[object title]];
                                              [controller.navigationController pushViewController:resController animated:YES];
                                              return NO;
                                          }]];
    }
    self.model = [[NITableViewModel alloc] initWithListArray:tableContents delegate:(id)[NICellFactory class]];
    self.tableView.delegate = [self.actions forwardingTo:self];
    self.tableView.dataSource = self.model;
    [self.tableView reloadData];
    
}

@end
