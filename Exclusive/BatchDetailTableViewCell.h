//
//  BatchDetailTableViewCell.h
//  Exclusive
//
//  Created by Ruben Flores on 2/28/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Batch.h"

@interface BatchDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *openLabel;


-(void) configureSelfWithBatch:(Batch*) theBatch;

@end
