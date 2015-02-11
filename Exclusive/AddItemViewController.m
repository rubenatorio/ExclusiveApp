//
//  AddItemViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 2/9/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "AddItemViewController.h"

@interface AddItemViewController ()

@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 *  This function will load the device camera for taking a picture of the
 *  target item and allow us to index it into our model
 */
- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

/*
 *  When the user is finished interacting with this conroller, inform the
 *  delegate so that appropriate action can be taken
 */
- (IBAction)dismissViewController:(id)sender
{
    [self.delegate dismissViewController];
    NSLog(@"Dismissing Modal view controller");
}

@end
