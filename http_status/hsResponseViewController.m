//
//  hsResponseViewController.m
//  http_status
//
//  Created by tyrande on 25/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

#import "hsResponseViewController.h"

#import "hsHeadersViewController.h"

#import "NimbusModels.h"
#import "NimbusCore.h"

#import "IBoolooHttpClient.h"

@interface hsResponseViewController ()
@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;
@property (nonatomic, readwrite, retain) NITitleCellObject* bodyCell;
@property (nonatomic, readwrite, retain) NSDictionary* httpResponse;
@end

@implementation hsResponseViewController

@synthesize model = _model;
@synthesize actions = _actions;
@synthesize bodyCell = _bodyCell;
@synthesize httpResponse = _httpResponse;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Headers" style:UIBarButtonItemStyleBordered target:self action:@selector(showHeaders:)];
        _actions = [[NITableViewActions alloc] initWithTarget:self];
        self.bodyCell = [NITitleCellObject objectWithTitle:@"aaa"];
        NSArray* tableContents =
        [NSArray arrayWithObjects:
         @"Body",
         self.bodyCell,
         
         @"",
         [_actions attachToObject:[NITitleCellObject objectWithTitle:@"Headers"]
                  navigationBlock:^(id object, UIViewController* controller) {
                      hsHeadersViewController* headerController = [[hsHeadersViewController alloc] init];
                      [headerController setHeaders:self.httpResponse];
                      [controller.navigationController pushViewController:headerController animated:YES];
                      return NO;
                  }],
         nil];
        self.model = [[NITableViewModel alloc] initWithSectionedArray:tableContents delegate:(id)[NICellFactory class]];
        self.tableView.delegate = [self.actions forwardingTo:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = _model;
}

- (void)setBody {
    [self.bodyCell setTitle:[NSString stringWithFormat:@"%@", [self.httpResponse objectForKey:@"Body"]]];
    [self.tableView reloadData];
}

- (void)requestWithIdentifer:(NSString *)identifer {
    [[IBoolooHttpClient sharedClient] ope:identifer
                               parameters:[NSMutableDictionary dictionary]
                                  success:^(NSDictionary *httpResponse) {
                                      self.httpResponse = httpResponse;
                                      [self setBody];
                                  } failure:^(NSDictionary *httpResponse) {
                                      self.httpResponse = httpResponse;
                                      [self setBody];
                                  }];
    
}

- (void)showHeaders:(id)sender {
    hsHeadersViewController* headerController = [[hsHeadersViewController alloc] init];
    [headerController setHeaders:self.httpResponse];
    [self.navigationController pushViewController:headerController animated:YES];
}

@end
