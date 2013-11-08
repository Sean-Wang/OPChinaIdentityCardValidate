//
//  ViewController.m
//  OPChinaIdentityCardValidate
//
//  Created by Sean on 11/7/13.
//  Copyright (c) 2013 opomelo. All rights reserved.
//

#import "ViewController.h"

const static CGFloat IdentityCardFieldHeight = 60.0f;
const static CGFloat IdentityCardFieldHMargin = 10.0f;
const static CGFloat IdentityCardFieldFontSize = 26.0f;
const static CGFloat IdentityCardFieldFloatingLabelFontSize = 11.0f;

#define kIdentityCardType_1 15
#define kIdentityCardType_2 18

@interface ViewController ()

@end

@implementation ViewController

@synthesize factor;
@synthesize remainder;
@synthesize province;

- (instancetype)init {
    if ((self = [super init])) {
        factor = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
        remainder = [NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil];
        province = [NSArray arrayWithObjects:@"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91", nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIColor *floatingLabelColor = [UIColor grayColor];
    
    titleField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                           CGRectMake(IdentityCardFieldHMargin, 60.0f, self.view.frame.size.width - 2 * IdentityCardFieldHMargin, IdentityCardFieldHeight)];
    titleField.placeholder = NSLocalizedString(@"请输入身份证号码", @"");
    titleField.font = [UIFont systemFontOfSize:IdentityCardFieldFontSize];
    titleField.floatingLabel.font = [UIFont boldSystemFontOfSize:IdentityCardFieldFloatingLabelFontSize];
    titleField.floatingLabelTextColor = floatingLabelColor;
    titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    titleField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [titleField becomeFirstResponder];
    
    BButton *commitButton = [[BButton alloc] initWithFrame:CGRectMake(IdentityCardFieldHMargin * 5, titleField.frame.origin.y + IdentityCardFieldHeight + IdentityCardFieldHMargin * 5, self.view.frame.size.width - IdentityCardFieldHMargin * 10, 50.0f) type:BButtonTypeTwitter style:BButtonStyleBootstrapV3];
    [commitButton setTitle:NSLocalizedString(@"提交", <#comment#>) forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(validateIdentityCard) forControlEvents:UIControlEventTouchUpInside];
    commitButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
    
    [self.view addSubview:titleField];
    [self.view addSubview:commitButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)validateIdentityCard {
    if (titleField.text.length == kIdentityCardType_1 || titleField.text.length == kIdentityCardType_2) {
        switch (titleField.text.length) {
            case kIdentityCardType_1: {
                NSInteger year = [[NSString stringWithFormat:@"%@%@", @"19", [titleField.text substringWithRange:NSMakeRange(6, 2)]] integerValue];
                NSInteger month = [[titleField.text substringWithRange:NSMakeRange(8, 2)] integerValue];
                NSInteger day = [[titleField.text substringWithRange:NSMakeRange(10, 2)] integerValue];
                
                NSString *code = [titleField.text substringWithRange:NSMakeRange(0, 2)];
                
                if ([province containsObject:code] && [self checkDateOfBirth:year month:month day:day]) {
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"身份证号码正确", <#comment#>)];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"身份证号码无效", <#comment#>)];
                }
            }
                break;
            
            case kIdentityCardType_2: {
                NSInteger year = [[titleField.text substringWithRange:NSMakeRange(6, 4)] integerValue];
                NSInteger month = [[titleField.text substringWithRange:NSMakeRange(10, 2)] integerValue];
                NSInteger day = [[titleField.text substringWithRange:NSMakeRange(12, 2)] integerValue];
                
                NSString *code = [titleField.text substringWithRange:NSMakeRange(0, 2)];
                
                NSMutableArray *pendingArray = [[NSMutableArray alloc] init];
                for (int i = 0; i < factor.count; i++) {
                    [pendingArray addObject:[titleField.text substringWithRange:NSMakeRange(i, 1)]];
                }
                
                if ([province containsObject:code] && [self checkDateOfBirth:year month:month day:day] && [self checkEndCode:pendingArray lastCheckCode:[titleField.text substringWithRange:NSMakeRange(17, 1)]]) {
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"身份证号码正确", <#comment#>)];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"身份证号码无效", <#comment#>)];
                }
            }
                break;
                
            default:
                break;
        }
    }
    else
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"输入身份证格式有误", <#comment#>)];
}

- (BOOL)checkDateOfBirth:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDate *now = [NSDate date];
    
    // NSLog(@"%i %i %i", year, month, day);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger nowYear = [dateComponent year];
    
    [dateComponent setYear:year];
    [dateComponent setMonth:month];
    
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit
                                   inUnit:NSMonthCalendarUnit
                                  forDate:[calendar dateFromComponents:dateComponent]];
    // NSLog(@"rang %i", range.length);
    
    if (year > 1900 && year <= nowYear && month >= 1 && month <= 12 && day >= 1 && day <= range.length) {
        return YES;
    }
    else
        return NO;
}

- (BOOL)checkEndCode:(NSMutableArray *)array lastCheckCode:(NSString *)lastStr{
    int sum = 0;
    for (int i = 0; i < factor.count; i++) {
        sum += [[array objectAtIndex:i] integerValue] * [[factor objectAtIndex:i] integerValue];
    }
    int calculateRemainder = fmod(sum, 11);
    
    if ([[remainder objectAtIndex:calculateRemainder] isEqualToString:lastStr])
        return YES;
    else
        return NO;
}

@end
