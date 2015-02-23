//
//  AddItemForm2ViewController.h
//  Exclusive
//
//  Created by Ruben Flores on 2/17/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormViewControllerPrototype.h"

@interface AddItemForm2ViewController : FormViewControllerPrototype <UIAlertViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *brandSegmentedControl;

@property (weak, nonatomic) IBOutlet UISegmentedControl *locationSegmentedControl;
@property (weak, nonatomic) IBOutlet UISwitch *isNewSwitch;

@end
