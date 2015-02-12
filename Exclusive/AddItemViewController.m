//
//  AddItemViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 2/9/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "AddItemViewController.h"
#import "AppDelegate.h"

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
 *  Collect the data from the form and create an Item object and send it
 *  back to the delegate.
 *  When the user is finished interacting with this conroller, inform the
 *  delegate so that appropriate action can be taken
 */
- (IBAction)dismissViewController:(id)sender
{
    [self.delegate didCreateNewItem:self.item];
}

#pragma mark UIImagePickerControllerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   self.itemPhoto.image = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    }];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}

@end
