//
//  ShipInventoryViewController.h
//  Exclusive
//
//  Created by Ruben Flores on 2/23/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateShippingOrderViewController.h"


@interface ShipInventoryViewController : UIViewController <NSFetchedResultsControllerDelegate, CreateShippingOrderDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *shippingOrdersFetchedController;

@property (weak, nonatomic) IBOutlet UILabel *beingShippedLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastOrderShippedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *awaitingConfirmationLabel;


@end
