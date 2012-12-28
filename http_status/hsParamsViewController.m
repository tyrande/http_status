//
//  hsParamsViewController.m
//  http_status
//
//  Created by tyrande on 27/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

#import "hsParamsViewController.h"

#import "hsResponseViewController.h"

#import "NimbusModels.h"
#import "NimbusCore.h"

#import "hsHttpEngine.h"

@interface hsParamsViewController ()
@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NSString* route;
@end

@implementation hsParamsViewController

@synthesize model = _modal;
@synthesize route = _route;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStyleBordered target:self action:@selector(requestRoute:)];
}

- (void)loadDefaultParams:(NSString *)route {
    self.route = route;
    NSMutableDictionary *routeDictionary = [[hsHttpEngine sharedEngine].routes objectForKey:route];
    NSMutableDictionary *paramsDictionary = [routeDictionary objectForKey:@"Params"];
    
    NSArray *paramsArray = [[paramsDictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray* tableContents = [NSMutableArray array];
    [tableContents addObject:route];
    [tableContents addObject:[NISubtitleCellObject objectWithTitle:[routeDictionary objectForKey:@"Path"] subtitle:[routeDictionary objectForKey:@"Method"]]];
    [tableContents addObject:@"Params"];
    for (NSString *param in paramsArray) {
        [tableContents addObject:param];
        [tableContents addObject:[NITextInputFormElement textInputElementWithID:0 placeholderText:@"Placeholder" value:[paramsDictionary objectForKey:param]]];
    }
    self.model = [[NITableViewModel alloc] initWithSectionedArray:tableContents delegate:(id)[NICellFactory class]];
    self.tableView.dataSource = self.model;
    [self.tableView reloadData];
}

- (void)requestRoute:(id)sender {
    hsResponseViewController* responseController = [[hsResponseViewController alloc] init];
    [responseController requestWithIdentifer:self.route];
    [self.navigationController pushViewController:responseController animated:YES];
}
@end
