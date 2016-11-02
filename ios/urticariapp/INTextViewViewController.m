//
//  INTextViewViewController.m
//  urticariapp
//
//  Created on 25/10/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "INTextViewViewController.h"

#import "INRegister+CoreDataClass.h"

@interface INTextViewViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation INTextViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Nota", nil);
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectInset(self.view.bounds, 20, 20)];
    self.textView.delegate = self;
  
    [self.view addSubview:self.textView];
    
    if ([self.reg.note length]) {
        self.textView.text = self.reg.note;
    }
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Hecho", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closePopover)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self.textView action:@selector(resignFirstResponder)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length) {
        self.reg.note = self.textView.text;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![self.reg.note length]) {
        [self.textView becomeFirstResponder];
    }
}



-(void)closePopover
{
    if (self.textView.text.length) {
        self.reg.note = self.textView.text;
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
