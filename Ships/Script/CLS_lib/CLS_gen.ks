// CLS_Gen.ks - A library of general functions for the CLS (Common Launch Script)
// Copyright © 2021 Qwarkk6
// Lic. CC-BY-SA-4.0 

@lazyglobal off.

// Takes a "hh:mm:ss" input for a specific launch time and calculates seconds 
// until this time.
function secondsToLaunch {
	Parameter input.

	Local inputString is input:tostring.
	Local timeString is time:seconds:tostring.
	
	if not inputString:contains(":") { return input. }

	local hours is inputString:split(":")[0].
	local minutes is inputString:split(":")[1].
	local seconds is inputString:split(":")[2].
	local ss is "0." + timeString:split(".")[1].
	
	Local todaySeconds is time:second + Ss:tonumber() + time:minute*60 + time:hour*60*60.
	Local targetSeconds to seconds:tonumber() + minutes:tonumber()*60 + hours:tonumber()*60*60.
	
	if targetSeconds <= todaySeconds+23 {
		return targetSeconds + round(body:rotationperiod)*60*60 - todaySeconds.
	}
		
	return targetSeconds - todaySeconds.
}

//Figures out real world time (GMT).
Function realWorldTime {
	local rwtime is kuniverse:realtime.
	local years is floor(rwtime/31536000).
	set rwtime to rwtime-(years*31536000).
	local days is floor(rwtime/86400).
	set rwtime to rwtime-(days*86400).
	local hours is floor(rwtime/3600).
	set rwtime to rwtime-(hours*3600).
	local minutes is floor(rwtime/60).
	return hours+1 + "." + minutes.
}

//Camera control function
//Cameras for launch need to be tagged "CameraLaunch"
//Cameras for Stage sep need to be tagged "CameraSep"
//Cameras for onboard views need tagged "Camera1" or "camera2" with the number 
// associated with their stage
function cameraControl {
	//xxx i don't understand how variables context works
	//parameter StageNumber is currentstagenum.
	parameter Launch is false.
	parameter Abort is false.

	local stageString is "Camera" + StageNumber.
	
	if ship:partstaggedpattern("Camera"):length > 0 {
		for p in ship:partstaggedpattern("Camera") {
			p:getmodule("MuMechModuleHullCameraZoom"):doaction("deactivate camera",true).
			p:getmodule("MuMechModuleHullCameraZoom"):doaction("deactivate camera",true).
		}
	}
	
	if Launch {
		if ship:partstagged("CameraLaunch"):length = 1 {
			ship:partstagged("CameraLaunch")[0]:getmodule("MuMechModuleHullCameraZoom"):doaction("activate camera",true).
		}
	} else if Abort {
		for p in ship:partstaggedpattern("Camera") {
			p:getmodule("MuMechModuleHullCameraZoom"):doaction("deactivate camera",true).
			p:getmodule("MuMechModuleHullCameraZoom"):doaction("deactivate camera",true).
		}
	} else {
		if ship:partstagged(stageString):length = 1 {
			ship:partstagged(stageString)[0]:getmodule("MuMechModuleHullCameraZoom"):doaction("activate camera",true).
		}
	}
}