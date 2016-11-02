//
//  SettingsViewController.m
//  urticariapp
//
//  Created by enrique on 28/9/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "SettingsViewController.h"
#import "ModalViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController {
    NSArray *tableData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    tableData = [NSArray arrayWithObjects: NSLocalizedString(@"Sugerencias", nil), NSLocalizedString(@"Limitación de responsabilidad", nil), nil];
    
    [self.settingsTableView setDelegate:self];
    [self.settingsTableView setDataSource:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //  Open Modal
    ModalViewController *modalViewController = [[ModalViewController alloc] init];
    if (indexPath.row == 0) {
        modalViewController.type = 0;
        modalViewController.titleModal = [tableData objectAtIndex:indexPath.row];
    } else {
        modalViewController.type = 1;
        modalViewController.titleModal = [tableData objectAtIndex:indexPath.row];
    }
    [self presentViewController:modalViewController animated:YES completion:nil];
}

@end
