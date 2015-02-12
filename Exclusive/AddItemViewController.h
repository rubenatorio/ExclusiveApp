//
//  AddItemViewController.h
//  Exclusive
//
//  Created by Ruben Flores on 2/9/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

/* 
 *  This protocol will allow us to dismiss the modal view controllers
 *   when the user is finished interacting with it.
 */
@protocol AddItemViewControllerDelegate <NSObject>

-(void) didCreateNewItem:(Item *) theItem;

@end

@interface AddItemViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *itemPhoto;

@property (weak, nonatomic) Item *item;

@property (nonatomic, retain) id <AddItemViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView * scroller;

@end
