//
//  hsHeaderDetailViewController.m
//  http_status
//
//  Created by tyrande on 25/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

#import "hsHeaderDetailViewController.h"

//#import "NimbusAttributedLabel.h"

@interface hsHeaderDetailViewController ()

@end

@implementation hsHeaderDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showDetail:(NSDictionary *)detail {
//    NIAttributedLabel* label = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
//    label.text = @"An explorer's tale";
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 280, 80)];
    labelTitle.text = [detail objectForKey:@"Title"];
    [self.view addSubview:labelTitle];
}
@end
