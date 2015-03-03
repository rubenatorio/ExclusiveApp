//
//  InventoryMenuViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 2/10/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "InventoryMenuViewController.h"
#import "AppDelegate.h"
#import "MasterViewController.h"
#import "ShipInventoryViewController.h"
#import "ModelController.h"
@interface InventoryMenuViewController ()

@end

@implementation InventoryMenuViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"AddInventory"])
    {
        
    }
    
    else if ([[segue identifier] isEqualToString:@"ShipInventory"])
    {
        ShipInventoryViewController *shipping = (ShipInventoryViewController *) [segue destinationViewController];
        
        shipping.title = @"Shipping";
    }
}
- (IBAction)testFetch:(id)sender {
    
    NSArray * batches = [[ModelController sharedController] registeredObjects];
    
    for (Batch *batch in batches)
    {
        NSLog(@"RBATCH: %@ ", batch.parse_id);
        for (Item *theItem in batch.items.allObjects)
        {
            NSLog(@"ITEM DATA: %@", theItem.parse_id);
        }
    }
}

@end
