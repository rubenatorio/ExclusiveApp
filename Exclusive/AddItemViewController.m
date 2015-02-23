//
//  AddItemViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 2/9/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "AddItemViewController.h"
#import "AppDelegate.h"
#import "AddItemFormViewController.h"
#import "AddItemForm2ViewController.h"

@interface AddItemViewController ()

@property (nonatomic, assign) BOOL locked;

@end

@implementation AddItemViewController

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
 *  When the embedded controller gets loaded, populate it with the form view controllers
 *  set ourselves as the delegate so that we can get notified when the forms have been
 *  completed and that the data can be added into the item
 */
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"embed"])
    {
        AddItemFormViewController *vc1 = [[AddItemFormViewController alloc] initWithNibName:@"AddItemFormViewController"
                                                                                     bundle:nil];
        vc1.index = 0;
        vc1.delegate = self;
        
        AddItemForm2ViewController *vc2 = [[AddItemForm2ViewController alloc] initWithNibName:@"AddItemForm2ViewController"
                                                                                       bundle:nil];
        vc2.index = 1;
        vc2.delegate = self;
        
        self.viewControllers = [NSArray arrayWithObjects: vc1,vc2, nil];
        
        self.embeddedNavigationController = (UINavigationController*) [segue destinationViewController];
        
        [self.embeddedNavigationController pushViewController:[self.viewControllers objectAtIndex:0] animated:YES];
    }
}

- (BOOL)prefersStatusBarHidden {return YES;}

#pragma mark UIImagePickerControllerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   // Obtain the image from the controller and get a handle for it so that it can be saved
                                   self.itemPhoto.image = [info valueForKey:@"UIImagePickerControllerEditedImage"];
                               }];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark FormViewControllerDelegate methods

/*
 *  This delegate method notifies us when one of the form view controllers
 *  finished obtaining and verifying data from the user to add to the item
 *  There are 2 forms responsible for different tasks.
 */

-(void) didObtainDataFromFormViewControllerWithIndex:(int)index
{
    switch (index)
    {
        case 0: //Responsible for price, category and size
        {
            AddItemFormViewController *vc1 = (AddItemFormViewController *)[self.viewControllers objectAtIndex:index];
            
            NSString *gender = [vc1.genderSegmentedControl titleForSegmentAtIndex:vc1.genderSegmentedControl.selectedSegmentIndex];
            NSString *size = [vc1.sizeSegmentedControl titleForSegmentAtIndex:vc1.sizeSegmentedControl.selectedSegmentIndex];
            
            NSString *pricePaid = [vc1.priceTextField text];
            
            self.item.size = size;
            self.item.price_paid = [NSNumber numberWithDouble:[pricePaid doubleValue]];
            self.item.category = gender;
            
            [self.embeddedNavigationController pushViewController:[self.viewControllers objectAtIndex:index + 1] animated:YES];
        }
            break;
            
        case 1:
        {
            AddItemForm2ViewController *vc2 = (AddItemForm2ViewController *)[self.viewControllers objectAtIndex:index];
            
            NSString *brand = [vc2.brandSegmentedControl titleForSegmentAtIndex:vc2.brandSegmentedControl.selectedSegmentIndex];
            NSString *location = [vc2.locationSegmentedControl titleForSegmentAtIndex:vc2.locationSegmentedControl.selectedSegmentIndex];
            BOOL isNew = vc2.isNewSwitch.on;
            
            self.item.brand = brand;
            self.item.location = location;
            self.item.is_new = [NSNumber numberWithBool:isNew];
            self.item.image = UIImagePNGRepresentation(self.itemPhoto.image);
            
            [self.delegate didCreateNewItem:self.item];
            
        }
            break;
            
        default:
            break;
    }
}

@end
