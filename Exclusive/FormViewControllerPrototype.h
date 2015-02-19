//
//  FormViewControllerPrototype.h
//  Exclusive
//
//  Created by Ruben Flores on 2/17/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FormViewControllerDelegate <NSObject>

@required
-(void) didObtainDataFromFormViewControllerWithIndex:(int) index;

@end


/*
 *  This class is intended to be subclassed by view contorllers displayed
 *   on the embedded view controller on AddItemViewController.
 *  The purpose of this is to present the user with a horizontal scrolling
 *  form to fill out information about the specific item we are trying to
 *  add to the batch.
 */
@interface FormViewControllerPrototype : UIViewController

/* Used to keep track of which form comes first (decided by the delegate) */
@property (nonatomic, assign) int index;

@property (nonatomic, strong) id<FormViewControllerDelegate> delegate;

@end
