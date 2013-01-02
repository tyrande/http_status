//
//  hsResponseViewController.h
//  http_status
//
//  Created by tyrande on 25/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hsResponseViewController : UIViewController
- (void)requestWithIdentifer:(NSString *)identifer
                  parameters:(NSMutableDictionary *)params;
@end
