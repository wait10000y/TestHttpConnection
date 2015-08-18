//
//  MainViewController.m
//  TestHttpConnection
//
//  Created by wsliang on 15/4/27.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "MainViewController.h"

#import "Common.h"
#import "CommProfile.h"
#import "HttpClient.h"


@interface MainViewController ()

- (IBAction)actionOperations:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextView *textShow;

@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[HttpClient sharedObject] connectToServer:^(BOOL resOK, id resData, NSString *resErr) {
        NSLog(@"--------- http client connectToServer:%d ------------",resOK);
    }];
    NSLog(@"=============== viewDidLoad ================");

}

-(void)loadUser
{
    [[HttpClient sharedObject] userLoginWithName:@"12300" withPwd:@"12300" complete:^(BOOL resOK, id resData, NSString *resErr) {
        if (resOK) {
            self.textShow.text = [resData description];
        }else{
            self.textShow.text = resErr;
        }
    }];
    
}

-(void)loadList
{
    [[HttpClient sharedObject] listInterestWithComplete:^(BOOL resOK, id resData, NSString *resErr) {
        if (resOK) {
            self.textShow.text = [resData description];
        }else{
            self.textShow.text = resErr;
        }
    }];
}


- (IBAction)actionOperations:(UIButton *)sender {
    
//    [self loadUser];
    [self loadList];
    
}
































- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DLog(@"---------- memory warning ------------");
}


@end
