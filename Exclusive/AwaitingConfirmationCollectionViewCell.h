//
//  AwaitingConfirmationCollectionViewCell.h
//  Exclusive
//
//  Created by Ruben Flores on 2/28/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShippingOrder.h"

@interface AwaitingConfirmationCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateShippedLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *topItemsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomItemsLabel;
@property (weak, nonatomic) IBOutlet UILabel *shoesLabel;
@property (weak, nonatomic) IBOutlet UILabel *accesoryItemsLabel;

@property (weak, nonatomic) IBOutlet UILabel *topPercentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomPercentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *shoesPercentageLabel;

-(void) configureSelfWithShippingOrder:(ShippingOrder *) shippingOrder;

-(void) setColorAtIndex:(int) index;

@end
