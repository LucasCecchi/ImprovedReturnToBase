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
//Note that drone gets released from ~2m above the ground and thinks that is 0m
const float HEIGHT = 10;
const float SPEED_TO_RTB = 6;
const float STAY_TIME = 3.0;
double rcLatitude;
double rcLongitude;
bool isReturning = false;
//this text
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _drone = [[DJIDrone alloc] initWithType:DJIDrone_Phantom];
    _drone.delegate = self;
    [_drone connectToDrone];
    [_groundStation enterNavigationModeWithResult:^(DJIError *error) {}];
    _rc = _drone.remoteController;
}

- (void) viewWillDisappear:(BOOL)animated{
    [_groundStation exitNavigationModeWithResult:^(DJIError *error) {}];
    [_drone disconnectToDrone];
    [_drone destroy];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Code for Improved Return To Base
//Only for Phantom 3 Professional
- (IBAction)onSwitchRTB:(id)sender {
    isReturning =!isReturning;
    if(!isReturning){
        [_groundStation stopGroundStationTask];
    }
}

-(void) remoteController:_rc didUpdateGpsData:(DJIRCGPSData)gpsData{
    rcLatitude = gpsData.mLatitude;
    rcLongitude = gpsData.mLongitude;
    CLLocationCoordinate2D homePoint = {rcLatitude, rcLongitude};
     [_maincontroller setHomePoint: homePoint WithResult:^(DJIError *error) {}];
     
    if(isReturning){
        
        if(CLLocationCoordinate2DIsValid(homePoint)){
            DJIGroundStationWaypoint* homeWayPoint = [[DJIGroundStationWaypoint alloc]initWithCoordinate:homePoint];
            
            homeWayPoint.altitude = HEIGHT;
            homeWayPoint.horizontalVelocity = SPEED_TO_RTB;
            homeWayPoint.stayTime = STAY_TIME;
            
            DJIGroundStationTask* RTBtask = [DJIGroundStationTask newTask];
            [RTBtask addWaypoint:homeWayPoint];
            
            [_groundStation uploadGroundStationTask:RTBtask];
            [_groundStation startGroundStationTask];
        }
        else{
            //Javier, change this to a pop-up alert when you can
            self.connectionText.text = @"GPS Error";
        }

    }


}

-(void) droneOnConnectionStatusChanged:(DJIConnectionStatus)status{
    switch (status) {
        case ConnectionStartConnect:
            
            break;
        case ConnectionSuccessed:
        {
            self.connectionText.text = @"Connected";
            break;
        }
        case ConnectionFailed:
        {
            self.connectionText.text = @"Connect Error";
            break;
        }
        case ConnectionBroken:
        {
            self.connectionText.text = @"Disconnected";
            break;
        }
        default:
            break;
    }
}

@end
