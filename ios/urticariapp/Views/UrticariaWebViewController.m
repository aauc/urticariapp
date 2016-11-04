//
//  UrticariaWebViewController.m
//  urticariapp
//
//  Created by enrique on 23/9/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "UrticariaWebViewController.h"
#import "UrticariaAppConfiguration.h"

@interface UrticariaWebViewController ()

@end

@implementation UrticariaWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle: NSLocalizedString(@"La Urticaria", nil)];
    
    [self.urticariaWebView setDelegate:self];
    [self.urticariaWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[UrticariaAppConfiguration getUrticariaUrl]]]];
    
    [self.urticariaWebActivityIndicator startAnimating];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.urticariaWebActivityIndicator stopAnimating];
    [self.urticariaWebActivityIndicator setHidden:YES];
}


@end
