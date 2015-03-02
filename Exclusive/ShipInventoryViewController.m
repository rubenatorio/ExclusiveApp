//
//  ShipInventoryViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 2/23/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "ShipInventoryViewController.h"
#import "ViewAllOrdersViewController.h"
#import "AcknowledgeOrderViewController.h"
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

-(void) receive {
    
    AcknowledgeOrderViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AcknowledgeOrderViewController"];
    
    vc.delegate = self;
    
    [vc setAwaitingConfirmation:[_modelController fetchAwaitingConfirmation]];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(void) fetchData {
    
    if (_dataChanged)
    {
        _shippedOrders = [_modelController fetchShippedOrders];
        _awaitingConfirmation = [_modelController fetchAwaitingConfirmation];
        _shippableItems = [_modelController fetchShippableItems];
        
        _dataChanged = NO;
    }
}

-(void) viewDidLoad {
    
    [super viewDidLoad];
    
    //Obtain the batch FetchedResultsController from the model controller
    
    _modelController = [ModelController sharedController];
    
    _shippingOrderResultsController = [_modelController shippingOrderResultsController];
    
    _shippingOrderResultsController.delegate = self;
    
    _dataChanged = YES;
    
    [self fetchData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderWasShipped:)
                                                 name:@"ShippingOrderShipped"
                                               object:_modelController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderWasAcknowledged:)
                                                 name:@"ShippingOrderAcknowledged"
                                               object:_modelController];

}

-(void) updateLabels {
    
    [self fetchData];
    
    self.shippedOrdersLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[_shippedOrders count]];
    self.awatingConfirmationLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[_awaitingConfirmation count]];
    self.shippableItemsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[_shippableItems count]];
}

-(void) viewWillAppear:(BOOL)animated {
    
    [self updateLabels];
    [self acknowledgeOrder];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ViewAllShippingOrders"])
    {
        ViewAllOrdersViewController *vc = (ViewAllOrdersViewController *) [segue destinationViewController];
        
        vc.shippingOrdersFetchedController = _shippingOrderResultsController;
    }
}

-(IBAction)createShippingOrder:(id)sender {
    
    [self fetchData];
    
    if ([_shippableItems count] <= 0)
        [self alertError];
    
    else
    {
        ShippingOrder *shippingOrder = [_modelController createShippingOrder];
        
        CreateShippingOrderViewController *vc = (CreateShippingOrderViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CreateShippingOrderViewController"];
        
        vc.delegate = self;
        vc.shippingOrder = shippingOrder;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

-(void) alertError {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                    message:@"No items to ship!"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* error = [UIAlertAction
                            actionWithTitle:@"Ok"
                            style:UIAlertActionStyleDefault
                            handler:nil];
    
    [alert addAction:error];
    [self presentViewController:alert animated:YES completion:nil];
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
    
    [self acknowledgeOrder];
}

-(void) orderWasAcknowledged: (NSNotification *) notification {
    
    NSLog(@" ORDER WAS RECEIVED!!!!!!!!!!!");
    
    _dataChanged = YES;
    
    [self updateLabels];
    
}

-(void) acknowledgeOrder {
    
    [self fetchData];
    
    if ([_awaitingConfirmation count] > 0)
    {
        
        UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Receive(%lu)" , (unsigned long)[_awaitingConfirmation count]]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(receive)];
        [self.navigationItem setRightBarButtonItem:button];
    }
    else
        [self.navigationItem setRightBarButtonItem:nil];
}


#pragma mark AcknowledgeOrderViewControllerDelegate

-(void) didAcknowledgeShippingOrder:(ShippingOrder *)shippingOrder {
    
    [_modelController acknowledgeShippingOrder:shippingOrder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) userCancelled {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
