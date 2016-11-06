//
//  RegisterActivityViewController.m
//  urticariapp
//
//  Created by enrique on 22/9/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "RegisterActivityViewController.h"

#import "INSelectAngLimiTVController.h"
#import "INTextViewViewController.h"

#import "INRegister+CoreDataClass.h"

#import "INDataManager.h"

#define COLOR_SELECT_CYAN  [UIColor colorWithRed:0.0/255.0 green:103.0/255.0 blue:159.0/255.0 alpha:0.3]

@interface RegisterActivityViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIDatePicker *datePicker;
    NSDateFormatter *formatter;
}

@property (strong, nonatomic) IBOutlet UIView *wheals0;
@property (strong, nonatomic) IBOutlet UIView *wheals1;
@property (strong, nonatomic) IBOutlet UIView *wheals2;
@property (strong, nonatomic) IBOutlet UIView *wheals3;

@property (assign, nonatomic) NSInteger whealsValue;

@property (strong, nonatomic) IBOutlet UIView *itch0;
@property (strong, nonatomic) IBOutlet UIView *itch1;
@property (strong, nonatomic) IBOutlet UIView *itch2;
@property (strong, nonatomic) IBOutlet UIView *itch3;

@property (assign, nonatomic) NSInteger itchValue;

@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) IBOutlet UITextView *dateTextView;
@property (strong, nonatomic) IBOutlet UIButton *dayMoreButton;

//View to add Actions.

@property (strong, nonatomic) IBOutlet UIView *noteView;
@property (strong, nonatomic) IBOutlet UIView *photoView;
@property (strong, nonatomic) IBOutlet UIView *angioView;
@property (strong, nonatomic) IBOutlet UIView *limitationsView;

@property (strong, nonatomic) INRegister *reg;

//Date
@property (nonatomic) NSInteger dateCompDay;
@property (nonatomic) NSInteger dateCompMonth;
@property (nonatomic) NSInteger dateCompYear;

@property (nonatomic, strong) NSDate *today;

@property (nonatomic, assign) BOOL hasChangedAndNeedSave;


@end

@implementation RegisterActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle: NSLocalizedString(@"Registrar Actividad", nil)];
    [self.chooseADateLabel setText: NSLocalizedString(@"Elija la fecha que deseas registrar", nil)];
    [self.howManyWhealsLabel setText: NSLocalizedString(@"¿Cuántas ronchas tienes?", nil)];
    [self.lebel0WhealLabel setText: NSLocalizedString(@"ninguna", nil)];
    [self.itchLevelLabel setText: NSLocalizedString(@"¿Cómo consideras el picor?", nil)];
    [self.level0ItchLabel setText: NSLocalizedString(@"no pica", nil)];
    [self.level1ItchLabel setText: NSLocalizedString(@"leve", nil)];
    [self.level2ItchLabel setText: NSLocalizedString(@"moderado", nil)];
    [self.level3ItchLabel setText: NSLocalizedString(@"severo", nil)];
    [self.noteLabel setText: NSLocalizedString(@"Añadir nota", nil)];
    [self.photoLabel setText: NSLocalizedString(@"Foto", nil)];
    [self.angioLabel setText: NSLocalizedString(@"Angioedema", nil)];
    [self.limitationsLabel setText: NSLocalizedString(@"Limitaciones", nil)];
    
    for (NSInteger i=0; i<4; i++) {
        UIView *whealsView = [self valueForKey:[NSString stringWithFormat:@"wheals%ld",(long)i]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectWheals:)];
        whealsView.tag = i;
        [whealsView addGestureRecognizer:tap];
        
        UIView *itchView = [self valueForKey:[NSString stringWithFormat:@"itch%ld",(long)i]];
        UITapGestureRecognizer *tapItch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectItch:)];
        itchView.tag = i;
        [itchView addGestureRecognizer:tapItch];
    }
    
    self.wheals0.backgroundColor = COLOR_SELECT_CYAN;
    self.itch0.backgroundColor = COLOR_SELECT_CYAN;
    self.whealsValue = 0;
    self.itchValue = 0;
    
    UITapGestureRecognizer *tapNote = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNoteAction)];
    [self.noteView addGestureRecognizer:tapNote];
    
    UITapGestureRecognizer *tapPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhotoAction)];
    [self.photoView addGestureRecognizer:tapPhoto];

    
    UITapGestureRecognizer *tapAngio = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAngio)];
    [self.angioView addGestureRecognizer:tapAngio];
    
    UITapGestureRecognizer *tapLimit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLimitations)];
    [self.limitationsView addGestureRecognizer:tapLimit];
    
    
    // Start Today.
    [self.dayMoreButton setEnabled:NO];
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    self.today = [NSDate date];

    NSInteger day,month,year;
    
    [self componentsDay:&day month:&month andYear:&year fromDate:_today];
    
    self.dateCompDay = day;
    self.dateCompMonth = month;
    self.dateCompYear = year;
    
    NSString *text = [NSString stringWithFormat:@"%2ld/%2ld/%4ld",(long)self.dateCompDay, (long)self.dateCompMonth, (long)self.dateCompYear];
    [self.dateTextView setText:text];
    
    self.hasChangedAndNeedSave = NO;
    //We look for register this day.
    [self updateRegisterToSelectDate];

    //  UIDatePicker
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];
    [self.dateTextField setInputView:datePicker];
    
    CGFloat width = self.view.bounds.size.width;
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    [toolbar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"OK", nil) style:UIBarButtonItemStyleDone target:self action:@selector(selectADate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbar setItems:[NSArray arrayWithObjects:space, doneButton, nil]];
    [self.dateTextField setInputAccessoryView:toolbar];
    [self.dateTextField setTintColor:[UIColor clearColor]];
    
}


- (void)updateRegisterToSelectDate {
    [self checkToSave];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"INRegister" inManagedObjectContext:[INDataManager sharedManager].managedObjectContext]];
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"dateCompYear = %ld AND dateCompMonth = %ld AND dateCompDay = %ld",self.dateCompYear, self.dateCompMonth, self.dateCompDay]];
    NSArray *result = [[INDataManager sharedManager].managedObjectContext executeFetchRequest:fetch error:nil];
    if ([result count]) {
        self.reg = [result firstObject];
        // Update Values.
        self.whealsValue = self.reg.wheals.integerValue;
        self.itchValue = self.reg.itch.integerValue;
        self.hasChangedAndNeedSave = YES;
    } else {
        //We created a new one
        self.reg = [NSEntityDescription insertNewObjectForEntityForName:@"INRegister" inManagedObjectContext:[INDataManager sharedManager].managedObjectContext];
        self.reg.dateCompYear = @(self.dateCompYear);
        self.reg.dateCompMonth = @(self.dateCompMonth);
        self.reg.dateCompDay = @(self.dateCompDay);
        self.reg.dateTimeInterval = @([self dateFromComponetsLikeDay:self.dateCompDay month:self.dateCompMonth andYear:self.dateCompYear].timeIntervalSince1970);
        self.whealsValue = 0;
        self.itchValue = 0;
    }
    
    for (NSInteger i=0; i<4; i++) {
        UIView *whealsView = [self valueForKey:[NSString stringWithFormat:@"wheals%ld",(long)i]];
        if ([result count]) {
            whealsView.backgroundColor = (i == self.whealsValue) ? COLOR_SELECT_CYAN : [UIColor clearColor];
        } else {
            whealsView.backgroundColor = (i == 0) ? COLOR_SELECT_CYAN : [UIColor clearColor];
        }
        UIView *itchView = [self valueForKey:[NSString stringWithFormat:@"itch%ld",(long)i]];
        if ([result count]) {
            itchView.backgroundColor = (i == self.itchValue) ? COLOR_SELECT_CYAN : [UIColor clearColor];
        } else {
            itchView.backgroundColor = (i == 0) ? COLOR_SELECT_CYAN : [UIColor clearColor];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)checkToSave {
    if (self.hasChangedAndNeedSave || self.reg.limitations.integerValue || self.reg.angioedema.integerValue) {
        [[INDataManager sharedManager].managedObjectContext save:nil];
        self.hasChangedAndNeedSave = NO;
    } else {
        if (self.reg)  [[INDataManager sharedManager].managedObjectContext deleteObject:self.reg];
    }
}


#pragma mark - Selectors

- (void)selectADate {
    NSDate *dateMore = [datePicker.date dateByAddingTimeInterval:1*24*60*60];
    
    [self.dayMoreButton setEnabled:!(dateMore.timeIntervalSince1970 >= self.today.timeIntervalSince1970)];
    
    NSInteger day,month,year;
    
    [self componentsDay:&day month:&month andYear:&year fromDate:datePicker.date];
    
    self.dateCompDay = day;
    self.dateCompMonth = month;
    self.dateCompYear = year;
    
    [self updateRegisterToSelectDate];
    
    NSString *text = [NSString stringWithFormat:@"%02ld/%02ld/%4ld",(long)self.dateCompDay, (long)self.dateCompMonth, (long)self.dateCompYear];
    [self.dateTextView setText:text];
    
    [self.dateTextField resignFirstResponder];
}

- (void)selectWheals:(UIGestureRecognizer *)gestt {
    if (self.whealsValue == gestt.view.tag) {
        return;
    }
   
    //Deselect.
    UIView *selctView = [self valueForKey:[NSString stringWithFormat:@"wheals%ld",(long)self.whealsValue]];
    selctView.backgroundColor = [UIColor clearColor];
    
    self.whealsValue = gestt.view.tag;
    gestt.view.backgroundColor = COLOR_SELECT_CYAN;
    self.reg.wheals = @(self.whealsValue);
    
    self.hasChangedAndNeedSave = YES;
}

- (void)selectItch:(UIGestureRecognizer *)gestt {
    if (self.itchValue == gestt.view.tag) {
        return;
    }
    
    //Deselect.
    UIView *selctView = [self valueForKey:[NSString stringWithFormat:@"itch%ld",(long)self.itchValue]];
    selctView.backgroundColor = [UIColor clearColor];
    
    self.itchValue = gestt.view.tag;
    gestt.view.backgroundColor = COLOR_SELECT_CYAN;
    self.reg.itch = @(self.itchValue);
    
    self.hasChangedAndNeedSave = YES;
}


#pragma mark - Buttons Actions

- (void)addNoteAction {
    INTextViewViewController *vController = [[INTextViewViewController alloc] init];
    vController.reg = self.reg;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vController];
    navController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *pc = [navController popoverPresentationController];
    pc.sourceView = self.view;
    
    [self presentViewController:navController animated:YES completion:nil];
}


- (void)takePhotoAction {
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Elige fuente", @"") preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *library = [UIAlertAction actionWithTitle:NSLocalizedString(@"Librería", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickController = [self imagePicker];
        imagePickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:imagePickController animated:YES completion:nil];
        });
        
 
    }];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cámara", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickController = [self imagePicker];
        imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:imagePickController animated:YES completion:nil];
        });
   
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancelar", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
      
    }];
    
    [actionSheetController addAction:library];
    [actionSheetController addAction:camera];
    [actionSheetController addAction:cancel];
    
    [self presentViewController:actionSheetController animated:YES completion:nil];
}

- (void)selectAngio {
    INSelectAngLimiTVController *vController = [[INSelectAngLimiTVController alloc] init];
    vController.isAngio = YES;
    vController.reg = self.reg;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vController];
    navController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *pc = [navController popoverPresentationController];
    pc.sourceView = self.view;
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)selectLimitations {
    INSelectAngLimiTVController *vController = [[INSelectAngLimiTVController alloc] init];
    vController.reg = self.reg;
    vController.isAngio = NO;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vController];
    navController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *pc = [navController popoverPresentationController];
    pc.sourceView = self.view;
    
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark UIImagePicker

- (UIImagePickerController *)imagePicker {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    
    return imagePickerController;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    self.reg.picture = UIImageJPEGRepresentation(originalImage, 0.7);
    self.hasChangedAndNeedSave = YES;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Date Buttons.

- (IBAction)dayLess:(id)sender {
    NSDate *date = [self dateFromComponetsLikeDay:self.dateCompDay month:self.dateCompMonth andYear:self.dateCompYear];
    NSDate *dateLess = [date dateByAddingTimeInterval:-1*24*60*60];
    
    [self.dayMoreButton setEnabled:YES];
    
    NSInteger day,month,year;
    
    [self componentsDay:&day month:&month andYear:&year fromDate:dateLess];
    
    self.dateCompDay = day;
    self.dateCompMonth = month;
    self.dateCompYear = year;

    [self updateRegisterToSelectDate];
    
    NSString *text = [NSString stringWithFormat:@"%02ld/%02ld/%4ld",(long)self.dateCompDay, (long)self.dateCompMonth, (long)self.dateCompYear];
    [self.dateTextView setText:text];
    [self.dateTextField resignFirstResponder];
}

- (IBAction)dayMore:(id)sender {
    NSDate *date = [self dateFromComponetsLikeDay:self.dateCompDay month:self.dateCompMonth andYear:self.dateCompYear];
    NSDate *dateMore = [date dateByAddingTimeInterval:1*24*60*60];
    NSDate *dateTwoMore = [date dateByAddingTimeInterval:2*24*60*60];
    
    if (dateTwoMore.timeIntervalSince1970 >= self.today.timeIntervalSince1970) {
        [self.dayMoreButton setEnabled:NO];
    }
    
    NSInteger day,month,year;
    
    [self componentsDay:&day month:&month andYear:&year fromDate:dateMore];
    
    self.dateCompDay = day;
    self.dateCompMonth = month;
    self.dateCompYear = year;
    
    [self updateRegisterToSelectDate];
    
    NSString *text = [NSString stringWithFormat:@"%02ld/%02ld/%4ld",(long)self.dateCompDay, (long)self.dateCompMonth, (long)self.dateCompYear];
    [self.dateTextView setText:text];
    [self.dateTextField resignFirstResponder];
}


#pragma mark - Date Calculations.

-(void)componentsDay:(NSInteger *)day month:(NSInteger *)month andYear:(NSInteger *)year fromDate:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    *day = (comp.day);
    *month= comp.month;
    *year = comp.year;
}

-(NSDate *)dateFromComponetsLikeDay:(NSInteger)day month:(NSInteger)month andYear:(NSInteger)year {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = day;
    components.month = month;
    components.year = year;
    components.hour = 12;
    
    return [cal dateFromComponents:components];
}


@end
