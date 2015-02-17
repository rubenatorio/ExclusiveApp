//
//  AddItemViewController.h
//  Exclusive
//
//  Created by Ruben Flores on 2/9/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "FormViewControllerPrototype.h"

/* 
 *  This protocol will allow us to dismiss the modal view controllers
 *   when the user is finished interacting with it.
 */
@protocol AddItemViewControllerDelegate <NSObject>

@required

/*
 *  The view controller will be required to notify its delegate 
 *  that it is done collecting data from the user. Sice the View
 *  controller does not know the implementation of the datamodel,
 *  it will pass the Item object to its delegate to commit the chnages 
 *  in the model.
 */
-(void) didCreateNewItem:(Item *) theItem;

@end


/*
 * The purpose of this view controller is to prompt the user for details about the specific 
 * item being created in the receipt.
 *
 * this class is NOT responsible for knowing anything about the data model, istead it is passed
 * an Item object to be populated with valid input.
 *
 * This class also has a delegate member which must comply with the <AddItemViewControllerDelegate> 
 * to message it that the Item object was succesfully populated and can be saved in the context.
 */
@interface AddItemViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                                                    UIPageViewControllerDataSource, FormViewControllerDelegate>


/* Used for momentarily displaying the image of the item being added */
@property (weak, nonatomic) IBOutlet UIImageView *itemPhoto;
/* Pointer to an Item record to pupulate the data with */
@property (weak, nonatomic) Item *item;
/* Delegate to inform when we are done collecting data and the Item object has been populated */
@property (nonatomic, retain) id <AddItemViewControllerDelegate> delegate;

@property(strong, nonatomic) IBOutlet UIPageViewController *pageViewController;

@property(strong, nonatomic) NSArray *viewControllers;


// TODO:
// these properties need to be modified to comply with the new UI specifications!!!!
@property (weak, nonatomic) IBOutlet UIScrollView * scroller;
@property (weak, nonatomic) IBOutlet UISwitch *isNewSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *categorySegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sizeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *locationSegmentedControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *costTextField;

@end
