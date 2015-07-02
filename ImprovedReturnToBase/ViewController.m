//
//  ViewController.m
//  ImprovedReturnToBase
//
//  Created by Lucas Cecchi on 7/2/15.
//  Copyright (c) 2015 Lucas Cecchi. All rights reserved.
//

#import "ViewController.h"
#import "DJISDK/DJIRemoteController.h"

@interface ViewController ()

@end

@implementation ViewController

double rcLatitude;
double rcLongitude;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _drone = [[DJIDrone alloc] initWithType:DJIDrone_Phantom];
    _drone.delegate = self;
    //_drone.remoteController.delegate = self;
    [_drone connectToDrone];
    [_groundStation enterNavigationModeWithResult:^(DJIError *error) {}];
    _rc = _drone.remoteController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickAdjust:(id)sender {
    
}
- (IBAction)onSwitchRTB:(id)sender {
    
}

-(void) remoteController:_rc didUpdateGpsData:(DJIRCGPSData)gpsData{
    rcLatitude = gpsData.mLatitude;
    rcLongitude = gpsData.mLongitude;
}

-(void) droneOnConnectionStatusChanged:(DJIConnectionStatus)status{
//add exeption-handling code here later
}

@end
