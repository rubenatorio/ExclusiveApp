//
//  ShipInventoryViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 2/23/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "ShipInventoryViewController.h"
#import "ViewAllOrdersViewController.h"
#import "AppDelegate.h"
#import "ModelController.h"

@interface ShipInventoryViewController ()

@property (nonatomic, strong) NSFetchedResultsController *shippingOrderResultsController;

@property (nonatomic, strong) ModelController * modelController;

@property (strong, nonatomic) NSArray * shippedOrders;
@property (strong, nonatomic) NSArray * awaitingConfirmation;
@property (strong, nonatomic) NSArray * shippableItems;
@property (assign, nonatomic) BOOL dataChanged;

@end

@implementation ShipInventoryViewController

-(void)fetchData {
    
    _shippedOrders = [_modelController fetchShippedOrders];
    _awaitingConfirmation = [_modelController fetchAwaitingConfirmation];
    _shippableItems = [_modelController fetchShippableItems];
    
    _dataChanged = NO;
}

-(void) viewDidLoad {
    [super viewDidLoad];
    
    //Obtain the batch FetchedResultsController from the model controller
    
    _modelController = [ModelController sharedController];
    
    _shippingOrderResultsController = [_modelController shippingOrderResultsController];
    
    _shippingOrderResultsController.delegate = self;
    
    [self fetchData];
}

-(void) updateLabels {
    
    if (_dataChanged)
        [self fetchData];
    
    self.shippedOrdersLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[_shippedOrders count]];
    self.awatingConfirmationLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[_awaitingConfirmation count]];
    self.shippableItemsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[_shippableItems count]];
}

-(void) viewWillAppear:(BOOL)animated {
    
    [self updateLabels];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderWasShipped:)
                                                 name:@"ShippingOrderShipped"
                                               object:_modelController];
    
    if ([_awaitingConfirmation count] > 0)
        [self receive];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"CreateShippingOrder"])
    {
        
        ShippingOrder *shippingOrder = [_modelController createShippingOrder];
        
        CreateShippingOrderViewController *vc = (CreateShippingOrderViewController*)[segue destinationViewController];
        
        vc.delegate = self;
        vc.shippingOrder = shippingOrder;
    }
    
    if ([[segue identifier] isEqualToString:@"ViewAllShippingOrders"])
    {
        ViewAllOrdersViewController *vc = (ViewAllOrdersViewController *) [segue destinationViewController];
        
        vc.shippingOrdersFetchedController = _shippingOrderResultsController;
    }
}

#pragma mark CreateShippingOrderDelegate

-(void) userDidCancelShippingOrder:(ShippingOrder *) shippingOrder {

    [_modelController deleteShippingOrder:shippingOrder];
    
    NSError *error = nil;
    if (![_shippingOrderResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) didCreateNewShippingOrder:(ShippingOrder *)shippingOrder {
    
    [_modelController saveLocalContext];
    
    NSError *error = nil;
    
    if (![_shippingOrderResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSLog(@"Succesfully created shipping order with %lu items", (unsigned long)[shippingOrder.items count]);
    
    [_modelController shippedOrder:shippingOrder];
    
    _dataChanged = YES;
    
    [self updateLabels];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Handle NSNotifications

-(void) orderWasShipped: (NSNotification *) notification {
    
    NSLog(@"NOTIFICATION RECEIVED");
    
    [self aknowledgeOrder];
}

-(void) aknowledgeOrder {
    
    UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithTitle:@"Receive"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(receive)];
    [self.navigationItem setRightBarButtonItem:button];
}

-(void) receive {
    
}

@end
