//
//  HistoryViewController.m
//  urticariapp
//
//  Created by enrique on 23/9/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "HistoryViewController.h"

#import "INMonthViewController.h"

#import "INRegister+CoreDataClass.h"
#import "INCalendarConstants.h"

#import "INDataManager.h"

@interface HistoryViewController ()

@property (strong, nonatomic) IBOutlet UIView *containerCalendarView;
@property (nonatomic, strong) INMonthViewController *monthControllerView;

@property (strong, nonatomic) IBOutlet UIImageView *whelasImageView;
@property (strong, nonatomic) IBOutlet UIImageView *itchImageView;
@property (strong, nonatomic) IBOutlet UIImageView *angioImageView;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@property (strong, nonatomic) INRegister *selectedRegister;

@property (weak, nonatomic) id selectedDay;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:NSLocalizedString(@"Historial", nil)];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Exportar", nil) style:UIBarButtonItemStyleDone target:self action:@selector(exportAsCsv)];
    self.navigationItem.rightBarButtonItem = settingsButton;
    
    // Month Calendar.
    self.monthControllerView = [[INMonthViewController alloc] init];
    [self addChildViewController:self.monthControllerView];
    [self.containerCalendarView addSubview:self.monthControllerView.view];
    self.monthControllerView.view.frame = self.containerCalendarView.bounds;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(daySelectedNotification:) name:@"INDayViewSelectedNotification" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"INDayViewSelectedNotification" object:nil];
}

-(void)setSelectedRegister:(INRegister *)selectedRegister {
    
    if ([selectedRegister.note length]) {
        self.infoLabel.text = selectedRegister.note;
    } else {
        self.infoLabel.text = NSLocalizedString(@"No hay ninguna nota registrada para este día", nil);
    }
    
    self.itchImageView.image = [self imageFromLevel:selectedRegister.itch.integerValue];
    
    self.whelasImageView.image = [self imageFromLevel:selectedRegister.wheals.integerValue];
    
    NSInteger angioValue = 0;
    for (NSInteger i=0; i < 8; i++) {
        angioValue += ((selectedRegister.angioedema.integerValue & (NSInteger)pow(2, i)) == (NSInteger)pow(2, i)) ? 1 : 0;
    }
    
    NSString *angioName = [NSString stringWithFormat:@"angio%ld",(long)angioValue];
    
    self.angioImageView.image = [UIImage imageNamed:angioName];
    
    _selectedRegister = selectedRegister;
}

-(UIImage *)imageFromLevel:(NSInteger)level {
    NSString *imageName = [NSString stringWithFormat:@"uasLevel%ld",(long)level];
    return [UIImage imageNamed:imageName];
}

- (void)exportAsCsv {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *filePath = [documentsDir stringByAppendingPathComponent:@"urticaria.csv"];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    
    NSString *temp = @"";
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"INRegister" inManagedObjectContext:[INDataManager sharedManager].managedObjectContext]];
    [fetch setSortDescriptors: @[[NSSortDescriptor sortDescriptorWithKey:@"dateTimeInterval" ascending:NO]]];
    NSArray *result = [[INDataManager sharedManager].managedObjectContext executeFetchRequest:fetch error:nil];
    
    temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@, %@\n", NSLocalizedString(@"Fecha", nil), NSLocalizedString(@"Puntuación Ronchas", nil), NSLocalizedString(@"Puntuación Picor", nil), NSLocalizedString(@"UAS", nil), NSLocalizedString(@"Angioedema", nil), NSLocalizedString(@"Limitaciones", nil), NSLocalizedString(@"Notas", nil)]];
    
    for (INRegister *reg in result) {
        temp = [temp stringByAppendingString: [NSString stringWithFormat:@"%@/%@/%@,",reg.dateCompDay, reg.dateCompMonth, reg.dateCompYear]];
        temp = [temp stringByAppendingString: [NSString stringWithFormat:@"%@,", reg.wheals]];
        temp = [temp stringByAppendingString: [NSString stringWithFormat:@"%@,", reg.itch]];
        temp = [temp stringByAppendingString: [NSString stringWithFormat:@"%@,", [NSNumber numberWithFloat:([reg.wheals floatValue] + [reg.itch floatValue])]]];
        
        if (reg.angioedema.integerValue) {
            temp = [temp stringByAppendingString: @"\""];
            for (int i = 0; i < [INRegister angioOptions]; i++) {
                if ((reg.angioedema.integerValue & (long long)pow(2,i)) == (long long)pow(2, i)) {
                    temp = [temp stringByAppendingString: [NSString stringWithFormat:@"%@\n", [INRegister nameAngioOption:pow(2, i)]]];
                }
            }
            temp = [temp stringByAppendingString: @"\","];
        } else {
            temp = [temp stringByAppendingString: @","];
        }
        
        if (reg.limitations.integerValue) {
            temp = [temp stringByAppendingString: @"\""];
            for (int i = 0; i < [INRegister limitOptions]; i++) {
                if ((reg.limitations.integerValue & (long long)pow(2,i)) == (long long)pow(2, i)) {
                    temp = [temp stringByAppendingString: [NSString stringWithFormat:@"%@\n", [INRegister nameLimitationsOption:pow(2, i)]]];
                }
            }
            temp = [temp stringByAppendingString: @"\","];
        } else {
            temp = [temp stringByAppendingString: @","];
        }
        
        temp = [temp stringByAppendingString: [NSString stringWithFormat:@"%@\n", reg.note == nil ? @"" : reg.note]];
    }
    
    [temp writeToURL:fileUrl atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems: @[@"Urticaria", fileUrl] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}


#pragma mark - Notification

-(void)daySelectedNotification:(NSNotification *)not
{
    NSDictionary *infoDict = not.userInfo;
    if (self.selectedDay)
    {
        UIView *v = (UIView *)self.selectedDay;
        v.backgroundColor = COLOR_DAY_WITH_REGISTER;
    }
    
    self.selectedRegister = [infoDict valueForKey:@"register"];
    self.selectedDay = [infoDict valueForKey:@"day"];
}

@end
