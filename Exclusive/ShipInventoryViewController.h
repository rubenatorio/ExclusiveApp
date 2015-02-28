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

@property (weak, nonatomic) IBOutlet UILabel *shippedOrdersLabel;
@property (weak, nonatomic) IBOutlet UILabel *awatingConfirmationLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippableItemsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastOrderLabel;


@end
