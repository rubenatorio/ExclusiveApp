//
//  CreateShippingOrderViewController.h
//  Exclusive
//
//  Created by Ruben Flores on 2/23/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ModelController.h"

@protocol CreateShippingOrderDelegate <NSObject>

@required

-(void) userDidCancelShippingOrder:(ShippingOrder *) shippingOrder;
-(void) didCreateNewShippingOrder:(ShippingOrder *) shippingOrder;

@end

@interface CreateShippingOrderViewController : UIViewController <NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) id<CreateShippingOrderDelegate> delegate;

@property (weak, nonatomic) ShippingOrder *shippingOrder;

@property (weak, nonatomic) IBOutlet UILabel *itemsToShipLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderValueLabel;

@end
