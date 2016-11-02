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
    [self.titleLabel setText:self.titleModal];
    if (self.type == 0) {
        [self.textLabel setText: NSLocalizedString(@"¿Tienes alguna idea?\nEstaremos encantados de escucharla, manda un correo electrónico a hola@urticariacronica.org con tus sugerencias para mejorar la aplicación.\n¡Gracias!", nil)];
    } else {
        [self.textLabel setText: NSLocalizedString(@"Esta aplicación está creada para que los afectados de urticaria puedan registrar el progreso de la enfermedad para su uso personal. \nEl usuario es el único propietario y responsable de los datos guardados mediante esta aplicación. Los datos se guardan únicamente en la memoria de su teléfono móvil: no se transfieren a ningún servidor ni pueden ser leídos por otras aplicaciones a no ser que el mismo usuario decida exportarlos. \nLa AAUC no evalúa, aprueba o recomienda ninguna medicación, producto, equipo o tratamiento particular.", nil)];
    }
    [self.textLabel sizeToFit];
    [self.closeButton setTitle:NSLocalizedString(@"Cerrar", nil) forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickOnCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
