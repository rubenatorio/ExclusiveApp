//
//  AddItemForm2ViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 2/17/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "AddItemForm2ViewController.h"

@interface AddItemForm2ViewController ()

@end

@implementation AddItemForm2ViewController

- (IBAction)done:(id)sender
{
    [self.delegate didObtainDataFromFormViewControllerWithIndex:self.index];
}

@end
