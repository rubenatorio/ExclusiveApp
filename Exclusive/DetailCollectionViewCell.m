//
//  DetailCollectionViewCell.m
//  Exclusive
//
//  Created by Ruben Flores on 2/16/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "DetailCollectionViewCell.h"

@implementation DetailCollectionViewCell

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        [UIView animateWithDuration:0.8
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             [self setBackgroundColor:[UIColor lightGrayColor]];
                         }
                         completion:nil];
        
    }
    else
    {
        [UIView animateWithDuration:0.8
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             [self setBackgroundColor:[UIColor clearColor]];
                         }
                         completion:nil];
    }
}

@end
