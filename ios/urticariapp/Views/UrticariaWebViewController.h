//
//  UrticariaWebViewController.h
//  urticariapp
//
//  Created by enrique on 23/9/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UrticariaWebViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *urticariaWebView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *urticariaWebActivityIndicator;

@end
