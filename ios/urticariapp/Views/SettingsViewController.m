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
    
    tableData = [NSArray arrayWithObjects:@"Sugerencias", @"Limitación de responsabilidad", nil];
    
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
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //  Open Modal
    ModalViewController *modalViewController = [[ModalViewController alloc] init];
    if (indexPath.row == 0) {
        modalViewController.title = [tableData objectAtIndex:indexPath.row];
        modalViewController.text = @"¿Tienes alguna idea?\nEstaremos encantados de escucharla, manda un correo electrónico a hola@urticariacronica.org con tus sugerencias para mejorar la aplicación.\n¡Gracias!";
    } else {
        modalViewController.title = [tableData objectAtIndex:indexPath.row];
        modalViewController.text = @"Esta aplicación está creada para que los afectados de urticaria puedan registrar el progreso de la enfermedad para su uso personal. \nEl usuario es el único propietario y responsable de los datos guardados mediante esta aplicación. Los datos se guardan únicamente en la memoria de su teléfono móvil: no se transfieren a ningún servidor ni pueden ser leídos por otras aplicaciones a no ser que el mismo usuario decida exportarlos. \nLa AAUC no evalúa, aprueba o recomienda ninguna medicación, producto, equipo o tratamiento particular.";
    }
    [self presentViewController:modalViewController animated:YES completion:nil];
}

@end
