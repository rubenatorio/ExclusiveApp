//
//  AddItemFormViewController.h
//  Exclusive
//
//  Created by Ruben Flores on 2/17/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormViewControllerPrototype.h"

@interface AddItemFormViewController : FormViewControllerPrototype <UIAlertViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *sizeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@end
