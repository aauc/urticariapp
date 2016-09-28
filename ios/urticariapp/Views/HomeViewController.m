//
//  HomeViewController.m
//  urticariapp
//
//  Created by enrique on 23/9/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "HomeViewController.h"
#import "RegisterActivityViewController.h"
#import "HistoryViewController.h"
#import "UrticariaWebViewController.h"
#import "JoinUsViewController.h"
#import "UrticariaAppConfiguration.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"UrticariaApp"];
    
    UITapGestureRecognizer *tapOnLogoView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnAView:)];
    UITapGestureRecognizer *tapOnRegisterView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnAView:)];
    UITapGestureRecognizer *tapOnHistoryView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnAView:)];
    UITapGestureRecognizer *tapOnUrticariaInfoView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnAView:)];
    UITapGestureRecognizer *tapOnJoinUsView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnAView:)];
    
    self.logoAAUCImageView.tag = 0;
    [self.logoAAUCImageView setUserInteractionEnabled:YES];
    [self.logoAAUCImageView addGestureRecognizer:tapOnLogoView];
    self.registerView.tag = 1;
    [self.registerView addGestureRecognizer:tapOnRegisterView];
    self.historyView.tag = 2;
    [self.historyView addGestureRecognizer:tapOnHistoryView];
    self.urticariaInfoView.tag = 3;
    [self.urticariaInfoView addGestureRecognizer:tapOnUrticariaInfoView];
    self.joinUsView.tag = 4;
    [self.joinUsView addGestureRecognizer:tapOnJoinUsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickOnAView:(UITapGestureRecognizer *)recognizer {
    if (recognizer.view.tag == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UrticariaAppConfiguration getAAUCUrl]]];
    } else if (recognizer.view.tag == 1) {
        [self.navigationController pushViewController:[[RegisterActivityViewController alloc] init] animated:YES];
    } else if (recognizer.view.tag == 2) {
        [self.navigationController pushViewController:[[HistoryViewController alloc] init] animated:YES];
    } else if (recognizer.view.tag == 3) {
        [self.navigationController pushViewController:[[UrticariaWebViewController alloc] init] animated:YES];
    } else {
        [self.navigationController pushViewController:[[JoinUsViewController alloc] init] animated:YES];
    }
    
}


@end
