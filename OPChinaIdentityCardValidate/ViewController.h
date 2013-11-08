//
//  ViewController.h
//  OPChinaIdentityCardValidate
//
//  Created by Sean on 11/7/13.
//  Copyright (c) 2013 opomelo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "BButton.h"
#import "SVProgressHUD.h"

@class JVFloatLabeledTextField;

@interface ViewController : UIViewController {
    NSArray *factor;
    NSArray *remainder;
    NSArray *province;
    
    JVFloatLabeledTextField *titleField;
}

@property (retain, nonatomic) NSArray *factor;
@property (retain, nonatomic) NSArray *remainder;
@property (retain, nonatomic) NSArray *province;

@end
