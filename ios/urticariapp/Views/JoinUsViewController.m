//
//  JoinUsViewController.m
//  urticariapp
//
//  Created by enrique on 28/9/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "JoinUsViewController.h"
#import "UrticariaAppConfiguration.h"

@interface JoinUsViewController ()

@end

@implementation JoinUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"Hazte socio/a"];
    
    [self.joinUsWebView setDelegate:self];
    [self.joinUsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[UrticariaAppConfiguration getMemberUrl]]]];
    
    [self.joinUsActivityIndicator startAnimating];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.joinUsActivityIndicator stopAnimating];
    [self.joinUsActivityIndicator setHidden:YES];
}


@end
