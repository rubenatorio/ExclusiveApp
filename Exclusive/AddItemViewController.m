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
#import "AddItemForm3ViewController.h"

@interface AddItemViewController ()

@end

@implementation AddItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) createPageViewController
{
    
    AddItemFormViewController *vc1 = [[AddItemFormViewController alloc] initWithNibName:@"AddItemFormViewController"
                                                                                 bundle:nil];
    AddItemForm2ViewController *vc2 = [[AddItemForm2ViewController alloc] initWithNibName:@"AddItemForm2ViewController"
                                                                                   bundle:nil];
    AddItemForm3ViewController *vc3 = [[AddItemForm3ViewController alloc] initWithNibName:@"AddItemForm3ViewController"
                                                                                   bundle:nil];
    
    vc1.index = 0;
    vc2.index = 1;
    vc3.index = 2;
    
    vc1.delegate = self;
    vc2.delegate = self;
    vc3.delegate = self;

    
    self.viewControllers = [NSArray arrayWithObjects:vc1,vc2,vc3,nil];
    
    NSLog(@"%@", [self.viewControllers description]);

    
    [self.pageViewController setViewControllers:@[vc1]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion: nil];
    
    self.pageViewController.dataSource = self;
    
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
    // Validate User Input
    NSString *category = [self.categorySegmentedControl titleForSegmentAtIndex:self.categorySegmentedControl.selectedSegmentIndex];
    NSString *size = [self.sizeSegmentedControl titleForSegmentAtIndex:self.sizeSegmentedControl.selectedSegmentIndex];
    NSString *location = [self.locationSegmentedControl titleForSegmentAtIndex:self.locationSegmentedControl.selectedSegmentIndex];
    BOOL isNew = [self.isNewSwitch isOn];
    NSDate *datePurchased = [self.datePicker date];
    NSString *pricePaid = [self.costTextField text];
    NSData *imageData = UIImagePNGRepresentation(self.itemPhoto.image);
    
    if (self.costTextField.text.length != 0)
    {
        self.item.is_new = [NSNumber numberWithBool: isNew];
        self.item.size = size;
        self.item.location = location;
        self.item.price_paid = [NSNumber numberWithDouble:[pricePaid doubleValue]];
        self.item.date_purchased = datePurchased;
        self.item.category = category;
        self.item.image = imageData;
        self.item.brand = @"American Eagle";
        
        [self.delegate didCreateNewItem:self.item];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"embed"])
    {
        self.pageViewController = (UIPageViewController*) [segue destinationViewController];
        
        [self createPageViewController];
    }
}

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
    
}

#pragma mark UIPageViewControllerDataSource methods

-(UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    FormViewControllerPrototype *vc = (FormViewControllerPrototype *) viewController;
    
    switch (vc.index)
    {
        case 0:
            return [self.viewControllers objectAtIndex:1];
            break;
        case 1:
            return [self.viewControllers objectAtIndex:2];
            break;
        default:
            return nil;
            break;
    }
}

-(UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    FormViewControllerPrototype *vc = (FormViewControllerPrototype *) viewController;
    
    switch (vc.index)
    {
        case 2:
            return [self.viewControllers objectAtIndex:1];
            break;
        case 1:
            return [self.viewControllers objectAtIndex:0];
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark FormViewControllerDelegate methods

-(void) didObtainDataFromUser:(NSDictionary *)dictionary
{
    //TODO will replace dismissViewController method
}

@end
