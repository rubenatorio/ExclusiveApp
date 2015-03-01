//
//  AknowledgeOrderViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 2/27/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "AcknowledgeOrderViewController.h"
#import "ModelController.h"
#import "AwaitingConfirmationCollectionViewCell.h"

@interface AcknowledgeOrderViewController ()

@property (weak, nonatomic) NSArray * awaitingConfirmation;

@end

@implementation AcknowledgeOrderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userCancelled:(id)sender {
    
    [self.delegate userCancelled];
}


-(BOOL) prefersStatusBarHidden {
    
    return YES;
}

#pragma mark UICollectionViewDataSource

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_awaitingConfirmation count];
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // The main storyboard contains a prototype cell class (See DetailCell class)
    
    AwaitingConfirmationCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AwaitingConfirmation"
                                                                                              forIndexPath:indexPath];
    
    ShippingOrder *shippingOrder = [_awaitingConfirmation objectAtIndex:indexPath.row];
    
    [cell configureSelfWithShippingOrder:shippingOrder];
    
    return cell;
}

#pragma mark UICollectionViewDelegate

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

-(void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

}

-(BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

-(void) setAwaitingConfirmation:(NSArray *)awaitingConfirmation
{
    _awaitingConfirmation = awaitingConfirmation;
}

@end
