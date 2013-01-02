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
@property (nonatomic, readwrite, retain) NSMutableDictionary* params;
@end

@implementation hsParamsViewController

@synthesize model = _modal;
@synthesize route = _route;
@synthesize params = _params;

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
    self.params = [[NSMutableDictionary alloc] init];
    [tableContents addObject:route];
    [tableContents addObject:[NISubtitleCellObject objectWithTitle:[routeDictionary objectForKey:@"Path"] subtitle:[routeDictionary objectForKey:@"Method"]]];
    [tableContents addObject:@"Params"];
    for (NSString *param in paramsArray) {
        [tableContents addObject:param];
        NSDictionary *paramDictionary = [paramsDictionary objectForKey:param];
        NSString *paramType = [paramDictionary objectForKey:@"Type"];
        if ([paramType isEqualToString:@"Text"]) {
            NITextInputFormElement *textInputElement = [NITextInputFormElement textInputElementWithID:0 placeholderText:param value:[paramDictionary objectForKey:@"DefaultValue"]];
            [tableContents addObject:textInputElement];
            [self.params setObject:textInputElement forKey:param];
        } else if ([paramType isEqualToString:@"Password"]) {
            NITextInputFormElement *passwordInputElement = [NITextInputFormElement passwordInputElementWithID:0 placeholderText:param value:[paramDictionary objectForKey:@"DefaultValue"]];
            [tableContents addObject:passwordInputElement];
            [self.params setObject:passwordInputElement forKey:param];
        } else {
            NITextInputFormElement *textInputElement = [NITextInputFormElement textInputElementWithID:0 placeholderText:param value:[paramDictionary objectForKey:@"DefaultValue"]];
            [tableContents addObject:textInputElement];
            [self.params setObject:textInputElement forKey:param];
        }
    }
    self.model = [[NITableViewModel alloc] initWithSectionedArray:tableContents delegate:(id)[NICellFactory class]];
    self.tableView.dataSource = self.model;
    [self.tableView reloadData];
}

- (void)requestRoute:(id)sender {
    NSArray *paramsArray = [self.params allKeys];
    NSMutableDictionary *inputParams = [[NSMutableDictionary alloc] init];
    for (NSString *paramKey in paramsArray) {
        [inputParams setObject:((NITextInputFormElement*)[self.params objectForKey:paramKey]).value forKey:paramKey];
    }
    hsResponseViewController* responseController = [[hsResponseViewController alloc] init];
    [responseController requestWithIdentifer:self.route parameters:inputParams];
    [self.navigationController pushViewController:responseController animated:YES];
}
@end
