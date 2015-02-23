//
//  AddItemFormViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 2/17/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "AddItemFormViewController.h"

@interface AddItemFormViewController ()

@end

@implementation AddItemFormViewController

-(void) viewWillAppear:(BOOL)animated
{
    /*
     *  Since the location of the text field is in an area where the keyboard will
     *  appear, we must set ourselves as the text field's delegate to get notified
     *  of when it will be displayed so that we can handle the text input som other way
     */
    self.priceTextField.delegate = self;
}


/*
 *  Notify the delegate that we have finished collecting data from the user and that it may
 *  be added to the item
 */
- (IBAction)continue:(id)sender
{
    // TODO Input validation
    
    [self.delegate didObtainDataFromFormViewControllerWithIndex:self.index];
}

/*
 *  To avoid having to re-arrange all the textfield views, we will instead
 *  capture the text input through an alert view.
 */
-(void) getPrice
{
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Price:"
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles: nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *amountTextField = [alert textFieldAtIndex:0];
    
    amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    [alert addButtonWithTitle:@"Done"];
    [alert show];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self getPrice];
    return NO;  // Hide both keyboard and blinking cursor.
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        UITextField *amountTextField = [alertView textFieldAtIndex:0];
        self.priceTextField.text = amountTextField.text;
}

/* Allow the user to see the continue button so that they may move on to the next form */
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.continueButton setHidden:NO];
}
@end
