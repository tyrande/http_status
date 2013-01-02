//
//  hsIboolooViewController.m
//  http_status
//
//  Created by tyrande on 25/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

#import "hsIboolooViewController.h"

#import "hsResponseViewController.h"

#import "NimbusModels.h"
#import "NimbusCore.h"

#import "IBoolooHttpClient.h"

@interface hsIboolooViewController ()
@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;
@end

@implementation hsIboolooViewController

@synthesize model = _model;
@synthesize actions = _actions;

- (void)viewDidLoad {
    [super viewDidLoad];
    _actions = [[NITableViewActions alloc] initWithTarget:self];
    NSDictionary *rtsDic = [IBoolooHttpClient sharedClient].routes;
    NSArray *rts = [[rtsDic allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray* tableContents = [NSMutableArray array];
    for (NSInteger ix = 0; ix < [rts count]; ++ix) {
        NSString *indentifer = [rts objectAtIndex:ix];
        NSString *subtitle = [[rtsDic objectForKey:indentifer] objectForKey:@"Method"];
        subtitle = [subtitle stringByAppendingString:[NSString stringWithFormat:@" %@", [[rtsDic objectForKey:indentifer] objectForKey:@"Path"]]];
        [tableContents addObject:[_actions attachToObject:[NISubtitleCellObject objectWithTitle:indentifer subtitle:subtitle]
                                          navigationBlock:^(id object, UIViewController* controller) {
                                              hsResponseViewController* resController = [[hsResponseViewController alloc] init];
//                                              [resController requestWithIdentifer:[object title]];
                                              [controller.navigationController pushViewController:resController animated:YES];
                                              return NO;
                                          }]];
    }
    _model = [[NITableViewModel alloc] initWithListArray:tableContents delegate:(id)[NICellFactory class]];
    self.tableView.dataSource = self.model;
    self.tableView.delegate = [self.actions forwardingTo:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NIIsSupportedOrientation(toInterfaceOrientation);
}

@end
