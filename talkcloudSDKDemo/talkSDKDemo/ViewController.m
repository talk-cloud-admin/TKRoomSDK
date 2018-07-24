//
//  ViewController.m
//  classdemo
//
//  Created by mac on 2017/4/28.
//  Copyright © 2017年 talkcloud. All rights reserved.
//

#import "ViewController.h"
#import "RoomController.h" 

@interface ViewController () 
@property (nonatomic, assign) BOOL autoSubscribe;
@property (weak, nonatomic) IBOutlet UITextField *roomId;
@property (weak, nonatomic) IBOutlet UITextField *role;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _autoSubscribe = YES; 
}

- (void)viewDidLayoutSubviews {
    //[_button setFrame:CGRectMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2, 200, 50)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (IBAction)onClickedStart:(UIButton *)sender {

    RoomController* pop = [[RoomController alloc] init];
    pop.roomid = self.roomId.text;
    if (!pop.roomid || pop.roomid.length == 0) {
        return;
    }
    
    pop.role = self.role.text;
    if (!pop.role || pop.role.length == 0) {
        return;
    }
    pop.password = self.password.text;
    [self presentViewController:pop animated:YES completion:nil];
}



@end
