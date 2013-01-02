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
#import "MBProgressHUD.h"

#import "hsHttpEngine.h"

@interface hsResponseViewController ()
@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;
@property (nonatomic, retain) UITextView *bodyTextView;
@property (nonatomic, readwrite, retain) NSDictionary* httpResponse;
@property (nonatomic, readwrite, retain) NSString* httpIdentifer;
@property (nonatomic, readwrite, retain) MBProgressHUD* HUD;
@end

@implementation hsResponseViewController

@synthesize model = _model;
@synthesize actions = _actions;
@synthesize httpResponse = _httpResponse;
@synthesize httpIdentifer = _httpIdentifer;
@synthesize HUD = _HUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Headers" style:UIBarButtonItemStyleBordered target:self action:@selector(showHeaders:)];
        self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg.png"]];
        
//        self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//        [self.navigationController.view addSubview:self.HUD];
//        self.HUD.labelText = @"Loading";
        
        self.bodyTextView = [[UITextView  alloc] initWithFrame:self.view.frame];
        self.bodyTextView.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor];
        self.bodyTextView.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
        self.bodyTextView.layer.shadowOpacity = 1.0f;
        self.bodyTextView.layer.shadowRadius = 0.0f;
        self.bodyTextView.textColor = [UIColor yellowColor];
        
        self.bodyTextView.scrollEnabled = YES;
        self.bodyTextView.editable = NO;
        self.bodyTextView.backgroundColor = [UIColor clearColor];
        [self.view addSubview: self.bodyTextView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setBody {
    self.bodyTextView.text = [NSString stringWithFormat:@"%@", [self.httpResponse objectForKey:@"Body"]];
//    [self.HUD hideUsingAnimation:YES];
}

- (void)requestWithIdentifer:(NSString *)identifer
                  parameters:(NSMutableDictionary *)params {
//    [self.HUD showUsingAnimation:YES];
    [[hsHttpEngine sharedEngine] ope:identifer
                               parameters:params
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
