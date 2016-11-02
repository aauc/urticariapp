//
//  ModalViewController.h
//  urticariapp
//
//  Created by enrique on 28/9/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalViewController : UIViewController

@property (nonatomic) int type;
@property (nonatomic) NSString *titleModal;

@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;

- (IBAction)clickOnCloseButton:(id)sender;

@end
