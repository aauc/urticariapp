//
//  JoinUsViewController.h
//  urticariapp
//
//  Created by enrique on 28/9/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinUsViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *joinUsWebView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *joinUsActivityIndicator;

@end
