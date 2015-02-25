//
//  ViewAllOrdersViewController.h
//  Exclusive
//
//  Created by Ruben Flores on 2/23/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewAllOrdersViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *shippingOrdersFetchedController;

@end
