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
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    if ([[segue identifier] isEqualToString:@"AddInventory"])
    {
        MasterViewController *master = (MasterViewController *) [segue destinationViewController];
        
        master.managedObjectContext = [appDelegate managedObjectContext];
    }
    
    else if ([[segue identifier] isEqualToString:@"ShipInventory"])
    {
        ShipInventoryViewController *shipping = (ShipInventoryViewController *) [segue destinationViewController];
        
        shipping.managedObjectContext = [appDelegate managedObjectContext];
        
        shipping.title = @"Shipping";
    }
}

@end
