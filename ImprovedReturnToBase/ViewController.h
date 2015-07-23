//
//  ViewController.h
//  ImprovedReturnToBase
//
//  Created by Lucas Cecchi on 7/2/15.
//  Copyright (c) 2015 Lucas Cecchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DJISDK/DJISDK.h>
@interface ViewController : UIViewController<DJIDroneDelegate>{
    DJIDrone*_drone;
    DJIRemoteController*_rc;
    DJIMainController*_maincontroller;
    NSObject<DJIGroundStation>* _groundStation;
}

@property (weak, nonatomic) IBOutlet UITextField *returnHomeText;
@property (weak, nonatomic) IBOutlet UISwitch *returnHomeSwitch;

@property (weak, nonatomic) IBOutlet UITextField *connectionText;


@end
