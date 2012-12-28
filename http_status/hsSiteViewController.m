//
//  hsSiteViewController.m
//  http_status
//
//  Created by tyrande on 26/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

#import "hsSiteViewController.h"
#import "hsSiteDetailViewController.h"

#import "NimbusModels.h"
#import "NimbusCore.h"

#import "hsHttpEngine.h"

@interface hsSiteViewController ()
@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;
@property (nonatomic, readwrite, retain) MBProgressHUD* HUD;
@end

@implementation hsSiteViewController

@synthesize model = _modal;
@synthesize actions = _actions;
@synthesize HUD = _HUD;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadSite:)];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUD];
    self.HUD.labelText = @"Loading";
    
    [self setSiteData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadSite:(NSString *)identifer {
    [self.HUD showUsingAnimation:YES];
//    [self.blockAlertView show];
    [hsHttpEngine loadSiteConfig:^() {
        [self setSiteData];
        [self.tableView reloadData];
        [self.HUD hideUsingAnimation:YES];
//        [self.blockAlertView dismissWithClickedButtonIndex:0 animated:YES];
    }];
}

- (void)setSiteData {
    NSMutableDictionary *siteDictionary = [hsHttpEngine sites];
    _actions = [[NITableViewActions alloc] initWithTarget:self];
    NSArray *siteArray = [[siteDictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray* tableContents = [NSMutableArray array];
    for (NSInteger ix = 0; ix < [siteDictionary count]; ++ix) {
        NSString *indentifer = [siteArray objectAtIndex:ix];
        NSString *subtitle = [[siteDictionary objectForKey:indentifer] objectForKey:@"Domain"];
        [tableContents addObject:[_actions attachToObject:[NISubtitleCellObject objectWithTitle:indentifer subtitle:subtitle]
                                          navigationBlock:^(id object, UIViewController* controller) {
                                                  hsSiteDetailViewController* siteDetailController = [[hsSiteDetailViewController alloc] init];
                                                  [siteDetailController loadSite:[object title]];
                                                  [controller.navigationController pushViewController:siteDetailController animated:YES];
                                              return NO;
                                          }]];
    }
    self.model = [[NITableViewModel alloc] initWithListArray:tableContents delegate:(id)[NICellFactory class]];
    self.tableView.delegate = [self.actions forwardingTo:self];
    self.tableView.dataSource = self.model;
}

@end
