//
//  InventoryMenuViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 2/10/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "InventoryMenuViewController.h"
#import "AppDelegate.h"
#import "MasterViewController.h"

@interface InventoryMenuViewController ()

@end

@implementation InventoryMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
   // self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    MasterViewController *master = (MasterViewController *) [segue destinationViewController];
    
    master.managedObjectContext = [appDelegate managedObjectContext];
}



@end
