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
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UITextView *valueTextView;
@end

@implementation hsHeaderDetailViewController

- (void)showDetail:(NSDictionary *)detail {
//    NIAttributedLabel* label = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
//    label.text = @"An explorer's tale";
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    self.titleLabel.text = [detail objectForKey:@"Title"];
    [self.view addSubview:self.titleLabel];
    
    self.valueTextView = [[UITextView  alloc] initWithFrame:CGRectMake(20, 80, 280, 500)];
    self.valueTextView.text = [detail objectForKey:@"SubTitle"];
    self.valueTextView.scrollEnabled = YES;
    self.valueTextView.editable = NO;
    [self.view addSubview: self.valueTextView];
}
@end
