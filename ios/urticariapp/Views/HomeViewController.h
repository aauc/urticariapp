//
//  HomeViewController.h
//  urticariapp
//
//  Created by enrique on 23/9/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *logoAAUCImageView;
@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (strong, nonatomic) IBOutlet UIView *historyView;
@property (strong, nonatomic) IBOutlet UIView *urticariaInfoView;
@property (strong, nonatomic) IBOutlet UIView *joinUsView;

@property (strong, nonatomic) IBOutlet UILabel *registerLabel;
@property (strong, nonatomic) IBOutlet UILabel *historyLabel;
@property (strong, nonatomic) IBOutlet UILabel *urticariaInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *joinUsLabel;



@end
