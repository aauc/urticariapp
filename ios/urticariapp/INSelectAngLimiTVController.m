//
//  INSelectAngLimiTVController.m
//  urticariapp
//
//  Created on 25/10/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "INSelectAngLimiTVController.h"

#import "INRegister+CoreDataClass.h"

@interface INSelectAngLimiTVController ()

@end

@implementation INSelectAngLimiTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isAngio) {
        self.title = NSLocalizedString(@"Angioedema", nil);
    }
    else
    {
        self.title = NSLocalizedString(@"Limitaciones", nil);
    }
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Hecho", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closePopover)];
    self.navigationItem.leftBarButtonItem = closeButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isAngio) {
        return [INRegister angioOptions];
    } else
    return [INRegister limitOptions];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.isAngio)
    {
        cell.textLabel.text = [INRegister nameAngioOption:pow(2, indexPath.row)];
        if ((self.reg.angioedema.integerValue & (long long)pow(2,indexPath.row)) == (long long)pow(2, indexPath.row))
        {
            //is Check
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"17-check.png"]];
        }
        else
        {
            //Is unCheck
            cell.accessoryView = nil;
            
        }
    }
    
    else
    {
        cell.textLabel.text = [INRegister nameLimitationsOption:pow(2, indexPath.row)];
        if ((self.reg.limitations.integerValue & (long long)pow(2,indexPath.row)) == (long long)pow(2, indexPath.row))
        {
            //is Check
              cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"17-check.png"]];
        }
        else
        {
            //Is unCheck
             cell.accessoryView = nil;
        }
    }
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isAngio)
    {
        if ((self.reg.angioedema.integerValue & (long long)pow(2,indexPath.row)) == (long long)pow(2, indexPath.row))
        {
            //is Check, action -> unCheck.
            self.reg.angioedema = @(self.reg.angioedema.integerValue & (~(long long)pow(2,indexPath.row)));
        }
        else
        {
            //Is unCheck, action ->check.
            self.reg.angioedema = @((self.reg.angioedema.integerValue | (long long)pow(2,indexPath.row)));
        }
        
    }
    else
    {
        if ((self.reg.limitations.integerValue & (long long)pow(2,indexPath.row)) == (long long)pow(2, indexPath.row))
        {
            //is Check, action -> unCheck.
            self.reg.limitations = @(self.reg.limitations.integerValue & (~(long long)pow(2,indexPath.row)));
        }
        else
        {
            //Is unCheck, action ->check.
            self.reg.limitations = @(self.reg.limitations.integerValue | (long long)pow(2,indexPath.row));
        }
    }
    [self.tableView reloadData];
}

-(void)closePopover
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
