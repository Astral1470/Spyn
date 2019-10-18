%runs on startup to ensure we are connected to the brick
if exist('brick', 'var') == 0 %only connect once
    brick = ConnectBrick("group5");
    brick.playTone(100, 800, 500); %beep to say we
else
    brick.playTone(100, 1600, 100); %beep to say we are connected
end
    
    
%ports
leftDriveMotor = 'A';
rightDriveMotor = 'B';
rampMotor = 'C';
colorSensorPort = 1;
touchSensorPort = 3;
ultrasonicSensorPort = 4;
gyroSensorPort = 2;

%color sensor setup
brick.SetColorMode(colorSensorPort, 2);
stopSignColor = 5;

%random other variables
wheelCircumference = 360;

%main program goes here
while(~atGoal())
   if(wallInFront())
      turnLeft(90, 50);
      if(wallInFront())
          turnLeft(180, 50);
      end
   else
       forward(1, 50);
   end
end



%helper functions for simplicity
function forward(distance, speed) %distance in inches, speed in percent
    distanceMoved = 0;
    while(distanceMoved < distance)
        if shouldStop()
           pause(1); 
        end
        brick.MoveMotorAngleRel(leftDriveMotor + rightDriveMotor, speed, 5);
        distanceMoved = distanceMoved + (5/360) * wheelCircumference;
    end
end

function out = shouldStop() %do we see a stop sign?
    out = brick.ColorCode(colorSensorPort) == stopSignColor;
end

function out = atGoal() %placeholder
    out = false;
end

function out = wallInFront() %placeholder
    out = false;
end

function turnLeft(degrees, speed) %placeholder
    degrees + speed;
end