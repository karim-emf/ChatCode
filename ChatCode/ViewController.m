//
//  ViewController.m
//  ChatCode
//
//  Created by Karim Mourra on 10/31/14.
//  Copyright (c) 2014 Karim. All rights reserved.
//
#import <Parse/Parse.h>
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
<<<<<<< HEAD

=======
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create our Installation query
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"deviceType" equalTo:@"ios"];
    
    // Send push notification to query
    [PFPush sendPushMessageToQueryInBackground:pushQuery
                                   withMessage:@"Pee party at 5 in the men's bathroom"];
    PFQuery* query = [PFQuery queryWithClassName:@"NSString"];
    NSLog(@"%@", query);
>>>>>>> 0b25f3f4b32b0b46e6f51bdbbad74369a24f8a5b
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
