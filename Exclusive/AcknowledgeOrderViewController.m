//
//  AknowledgeOrderViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 2/27/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "AcknowledgeOrderViewController.h"
#import "AwaitingConfirmationCollectionViewCell.h"

@interface AcknowledgeOrderViewController ()

@property (strong, nonatomic) NSArray * awaitingConfirmation;

@property (strong, nonatomic) NSIndexPath * currentIndexPath;

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

- (IBAction)userAcknowledged:(id)sender {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Confirm"
                                  message:@"are you sure you want acknowledge?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Acknowledge"
                         style:UIAlertActionStyleDestructive
                         handler:^(UIAlertAction * action)
                         {
                             [self acknowledge];
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) acknowledge {
    
    [self.delegate didAcknowledgeShippingOrder:[_awaitingConfirmation objectAtIndex:_currentIndexPath.row]];
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
    [cell setColorAtIndex:(int)indexPath.row];
    
    _currentIndexPath = indexPath;
    
    return cell;
}

-(void) setAwaitingConfirmation:(NSArray *)awaitingConfirmation
{
    _awaitingConfirmation = awaitingConfirmation;
}

@end
