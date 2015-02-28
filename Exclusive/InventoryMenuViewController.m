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

@end
