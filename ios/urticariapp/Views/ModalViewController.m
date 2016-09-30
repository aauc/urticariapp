//
//  ModalViewController.m
//  urticariapp
//
//  Created by enrique on 28/9/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "ModalViewController.h"
#import "UrticariaAppConfiguration.h"

@interface ModalViewController ()

@end

@implementation ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    
    // Do any additional setup after loading the view from its nib.
    [self.textLabel setText:self.text];
    [self.textLabel sizeToFit];
    [self.titleLabel setText:self.title];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickOnCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
