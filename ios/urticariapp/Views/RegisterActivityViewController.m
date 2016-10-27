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

#define COLOR_SELECT_CYAN  [UIColor cyanColor]

@interface RegisterActivityViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *dayButton;


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

@property (strong, nonatomic) IBOutlet UIButton *dateButton;

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
    
    [self setTitle:@"Registrar Actividad"];
    
    
    for (NSInteger i=0; i<4; i++)
    {
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
    self.today = [NSDate date];

    NSInteger day,month,year;
    
    [self componentsDay:&day month:&month andYear:&year fromDate:_today];
    
    self.dateCompDay = day;
    self.dateCompMonth = month;
    self.dateCompYear = year;
    
    NSString *title = [NSString stringWithFormat:@"%2ld/%2ld/%4ld",(long)self.dateCompDay, (long)self.dateCompMonth, (long)self.dateCompYear];
    
    [self.dayButton setTitle:title forState:UIControlStateNormal];
    
    self.hasChangedAndNeedSave = NO;
    //We look for register this day.
    [self updateRegisterToSelectDate];

    
}


-(void)updateRegisterToSelectDate
{
    [self checkToSave];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"INRegister" inManagedObjectContext:[INDataManager sharedManager].managedObjectContext]];
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"dateCompYear = %ld AND dateCompMonth = %ld AND dateCompDay = %ld",self.dateCompYear, self.dateCompMonth, self.dateCompDay]];
    NSArray *result = [[INDataManager sharedManager].managedObjectContext executeFetchRequest:fetch error:nil];
    if ([result count])
    {
        self.reg = [result firstObject];
        // Update Values.
        self.whealsValue = self.reg.wheals.integerValue;
        self.itchValue = self.reg.itch.integerValue;
        
    }
    else
    {
        //We created a new one
        self.reg = [NSEntityDescription insertNewObjectForEntityForName:@"INRegister" inManagedObjectContext:[INDataManager sharedManager].managedObjectContext];
        self.reg.dateCompYear = @(self.dateCompYear);
        self.reg.dateCompMonth = @(self.dateCompMonth);
        self.reg.dateCompDay = @(self.dateCompDay);
        self.reg.dateTimeInterval = @([self dateFromComponetsLikeDay:self.dateCompDay month:self.dateCompMonth andYear:self.dateCompYear].timeIntervalSince1970);
        
    }
    
    for (NSInteger i=0; i<4; i++)
    {
        UIView *whealsView = [self valueForKey:[NSString stringWithFormat:@"wheals%ld",(long)i]];
        if (i == self.whealsValue) {
            whealsView.backgroundColor = COLOR_SELECT_CYAN;
        } else {
            whealsView.backgroundColor = [UIColor clearColor];
        }
        UIView *itchView = [self valueForKey:[NSString stringWithFormat:@"itch%ld",(long)i]];
        if (i == self.itchValue) {
            itchView.backgroundColor = COLOR_SELECT_CYAN;
        } else {
            itchView.backgroundColor = [UIColor clearColor];
        }
        
    }

    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}
-(void)checkToSave
{
    if (self.hasChangedAndNeedSave || self.reg.limitations.integerValue || self.reg.angioedema.integerValue)
    {
        [[INDataManager sharedManager].managedObjectContext save:nil];
        self.hasChangedAndNeedSave = NO;
    }
    else
    {
        if (self.reg)  [[INDataManager sharedManager].managedObjectContext deleteObject:self.reg];
    }
}



#pragma mark - Selectors
-(void)selectWheals:(UIGestureRecognizer *)gestt
{
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

-(void)selectItch:(UIGestureRecognizer *)gestt
{
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

-(void)addNoteAction
{
    INTextViewViewController *vController = [[INTextViewViewController alloc] init];
    vController.reg = self.reg;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vController];
    navController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *pc = [navController popoverPresentationController];
    pc.sourceView = self.view;
    
    [self presentViewController:navController animated:YES completion:nil];
}


-(void)takePhotoAction
{
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Choose source", @"") preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *library = [UIAlertAction actionWithTitle:NSLocalizedString(@"Library", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickController = [self imagePicker];
        imagePickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:imagePickController animated:YES completion:nil];
        });
        
 
    }];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:NSLocalizedString(@"Camera", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickController = [self imagePicker];
        imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:imagePickController animated:YES completion:nil];
        });
   
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
      
    }];
    
    [actionSheetController addAction:library];
    [actionSheetController addAction:camera];
    [actionSheetController addAction:cancel];
    
    [self presentViewController:actionSheetController animated:YES completion:nil];
}

-(void)selectAngio
{
    INSelectAngLimiTVController *vController = [[INSelectAngLimiTVController alloc] init];
    vController.isAngio = YES;
    vController.reg = self.reg;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vController];
    navController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *pc = [navController popoverPresentationController];
    pc.sourceView = self.view;
    
    [self presentViewController:navController animated:YES completion:nil];
}
-(void)selectLimitations
{
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

- (UIImagePickerController *)imagePicker
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    
    return imagePickerController;
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    self.reg.picture = UIImageJPEGRepresentation(originalImage, 0.7);
    self.hasChangedAndNeedSave = YES;

   [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Date Buttons.

- (IBAction)dayLess:(id)sender
{
    NSDate *date = [self dateFromComponetsLikeDay:self.dateCompDay month:self.dateCompMonth andYear:self.dateCompYear];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *dateLess = [cal dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:date options:NSCalendarWrapComponents];
    
    NSInteger day,month,year;
    
    [self componentsDay:&day month:&month andYear:&year fromDate:dateLess];
    
    self.dateCompDay = day;
    self.dateCompMonth = month;
    self.dateCompYear = year;

    [self updateRegisterToSelectDate];
    
    NSString *title = [NSString stringWithFormat:@"%2ld/%2ld/%4ld",(long)self.dateCompDay, (long)self.dateCompMonth, (long)self.dateCompYear];
    
    [self.dayButton setTitle:title forState:UIControlStateNormal];
}
- (IBAction)selectDate:(id)sender
{
}

- (IBAction)dayMore:(id)sender
{
    NSDate *date = [self dateFromComponetsLikeDay:self.dateCompDay month:self.dateCompMonth andYear:self.dateCompYear];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *dateMore = [cal dateByAddingUnit:NSCalendarUnitDay value:+1 toDate:date options:NSCalendarWrapComponents];
    
    if (dateMore.timeIntervalSince1970 > self.today.timeIntervalSince1970) {
        return;
    }
    
    NSInteger day,month,year;
    
    [self componentsDay:&day month:&month andYear:&year fromDate:dateMore];
    
    self.dateCompDay = day;
    self.dateCompMonth = month;
    self.dateCompYear = year;
    
    [self updateRegisterToSelectDate];
    
    NSString *title = [NSString stringWithFormat:@"%2ld/%2ld/%4ld",(long)self.dateCompDay, (long)self.dateCompMonth, (long)self.dateCompYear];
    
    [self.dayButton setTitle:title forState:UIControlStateNormal];

}

#pragma mark - Date Calculations.
-(void)componentsDay:(NSInteger *)day month:(NSInteger *)month andYear:(NSInteger *)year fromDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    *day = (comp.day);
    *month= comp.month;
    *year = comp.year;
}

-(NSDate *)dateFromComponetsLikeDay:(NSInteger)day month:(NSInteger)month andYear:(NSInteger)year
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = day;
    components.month = month;
    components.year = year;
    components.hour = 12;
    
    return [cal dateFromComponents:components];
}


@end
