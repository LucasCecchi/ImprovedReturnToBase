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
//Note that drone gets released from around 2m above the ground and thinks that is 0m
const float HEIGHT = 10;
const float SPEED_TO_RTB = 6;
const float STAY_TIME = 3.0;
double rcLatitude;
double rcLongitude;
bool isReturning = false;

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
    //DJIGroundStationTask* RTBtask = [DJIGroundStationTask newTask];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickAdjust:(id)sender {
    
}
- (IBAction)onSwitchRTB:(id)sender {
    isReturning =!isReturning;
    if(!isReturning){
    //add code to get rid of task to return home
    }
}

-(void) remoteController:_rc didUpdateGpsData:(DJIRCGPSData)gpsData{
    rcLatitude = gpsData.mLatitude;
    rcLongitude = gpsData.mLongitude;
    if(isReturning){
        CLLocationCoordinate2D homePoint = {rcLatitude, rcLongitude};
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
        //add error handling code here later
        }
    }
}

-(void) droneOnConnectionStatusChanged:(DJIConnectionStatus)status{
//add exeption-handling code here later
}

@end
