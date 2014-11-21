//
//  ViewController.m
//  ChatCodev2
//
//  Created by DANNY WU on 11/12/14.
//  Copyright (c) 2014 DANNY WU. All rights reserved.
//

#import "KJDChatRoomViewController.h"
#import <Firebase/Firebase.h>

@interface KJDChatRoomViewController ()

@property (strong, nonatomic) UITextField *inputTextField;
@property (strong, nonatomic) UITableView *tableView;
@property(strong,nonatomic)UILabel *label;

@property (strong, nonatomic) UIButton *sendButton;
@property(strong,nonatomic)Firebase *firebase;
@property(nonatomic)CGRect keyBoardFrame;

@end

@implementation KJDChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputTextField.delegate=self;
    self.firebase = [[Firebase alloc] initWithUrl:@"https://boiling-torch-9946.firebaseio.com"];
//        [self.firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//            NSDictionary *obj = [snapshot valueInExportFormat];
//            NSLog(@"Class: %@, Content: %@", [obj class], obj[@"message"]);
//        }];
    [self setupViewsAndConstraints];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    _keyBoardFrame = [keyboardFrameBegin CGRectValue];
    if (self.view.frame.origin.y >= 0){
        [self setViewMovedUp:YES];
    }else if (self.view.frame.origin.y < 0){
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide:(NSNotification *)notification{
    if (self.view.frame.origin.y >= 0){
        [self setViewMovedUp:YES];
    }else if (self.view.frame.origin.y < 0){
        [self setViewMovedUp:NO];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    CGRect rect = self.view.frame;
    if (movedUp){
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= self.keyBoardFrame.size.height;
//        rect.size.height += self.keyBoardFrame.size.height;
    }else{
        // revert back to the normal state.
        rect.origin.y += self.keyBoardFrame.size.height;
//        rect.size.height -= self.keyBoardFrame.size.height;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViewsAndConstraints {
    [self setupTableView];
    [self setupTextField];
    [self setupSendButton];
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *tableViewTop = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:0.0];
    
    NSLayoutConstraint *tableViewBottom = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:-40.0];
    
    NSLayoutConstraint *tableViewWidth = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:1.0
                                                                       constant:0.0];
    
    [self.view addConstraints:@[tableViewTop, tableViewBottom, tableViewWidth]];
}

- (void)sendButtonTapped
{
    NSLog(@"Button Tapped");
    self.inputTextField.text = @"";
    [self.inputTextField resignFirstResponder];
}

- (void)setupSendButton
{
    self.sendButton = [[UIButton alloc] init];
    [self.view addSubview:self.sendButton];
    self.sendButton.backgroundColor = [UIColor blueColor];
    [self.sendButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Send" attributes:nil] forState:UIControlStateNormal];
    
    [self.sendButton addTarget:self action:@selector(sendButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.sendButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *sendButtonTop = [NSLayoutConstraint constraintWithItem:self.sendButton
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.tableView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:0.0];
    
    NSLayoutConstraint *sendButtonBottom = [NSLayoutConstraint constraintWithItem:self.sendButton
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:0.0];
    
    NSLayoutConstraint *sendButtonLeft = [NSLayoutConstraint constraintWithItem:self.sendButton
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.inputTextField
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0
                                                                       constant:0.0];
    
    NSLayoutConstraint *sendButtonRight = [NSLayoutConstraint constraintWithItem:self.sendButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.tableView
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0.0];
    
    [self.view addConstraints:@[sendButtonTop, sendButtonBottom, sendButtonLeft, sendButtonRight]];
}

- (void)setupTextField
{
    self.inputTextField = [[UITextField alloc] init];
    [self.view addSubview:self.inputTextField];
    self.inputTextField.backgroundColor = [UIColor greenColor];
    self.inputTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *textFieldTop = [NSLayoutConstraint constraintWithItem:self.inputTextField
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.tableView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:0.0];
    
    NSLayoutConstraint *textFieldBottom = [NSLayoutConstraint constraintWithItem:self.inputTextField
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.tableView
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:40.0];
    
    NSLayoutConstraint *textFieldLeft = [NSLayoutConstraint constraintWithItem:self.inputTextField
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.tableView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:0.0];
    
    NSLayoutConstraint *textFieldRight = [NSLayoutConstraint constraintWithItem:self.inputTextField
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.tableView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0
                                                                       constant:-80.0];
    
    [self.view addConstraints:@[textFieldTop, textFieldBottom, textFieldLeft, textFieldRight]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text=[NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    return cell;
}

@end
