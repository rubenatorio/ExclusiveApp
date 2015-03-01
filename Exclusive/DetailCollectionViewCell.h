//
//  DetailCollectionViewCell.h
//  Exclusive
//
//  Created by Ruben Flores on 2/16/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelController.h"

@interface DetailCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

-(void) configureSelfWithItem:(Item *) item;

@end
