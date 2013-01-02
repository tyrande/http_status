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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg.png"]];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
        self.titleLabel.textColor = [UIColor yellowColor];
        self.titleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        self.titleLabel.shadowOffset = CGSizeMake(0, -1);
        self.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.titleLabel];
        
        self.valueTextView = [[UITextView  alloc] initWithFrame:CGRectMake(20, 80, 280, 500)];
        
        self.valueTextView.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor];
        self.valueTextView.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
        self.valueTextView.layer.shadowOpacity = 1.0f;
        self.valueTextView.layer.shadowRadius = 0.0f;
        
        self.valueTextView.textColor = [UIColor yellowColor];
//        self.valueTextView. = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//        self.valueTextView.shadowOffset = CGSizeMake(0, -1);
        self.valueTextView.scrollEnabled = YES;
        self.valueTextView.editable = NO;
        self.valueTextView.backgroundColor = [UIColor clearColor];
        [self.view addSubview: self.valueTextView];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)showDetail:(NSDictionary *)detail {
    self.titleLabel.text = [detail objectForKey:@"Title"];
    self.valueTextView.text = [detail objectForKey:@"SubTitle"];
//    [self.titleLabel setText:[detail objectForKey:@"Title"]];
//    [self.valueTextView setText:[detail objectForKey:@"SubTitle"]];
}
@end
