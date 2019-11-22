%runs on startup to ensure we are connected to the brick
global brick
global gyroSensorPort

if isempty(brick) %only connect once
    brick = ConnectBrick("group5");
    brick.playTone(100, 200, 500); %beep to say we finished connecting
else
    brick.playTone(100, 1600, 100); %beep to say we are connected
end


global key
InitKeyboard();    
    
%ports
colorSensorPort = 2;
touchSensorPort = 1;
ultrasonicSensorPort = 3;
gyroSensorPort = 4;

%color sensor setup
brick.SetColorMode(colorSensorPort, 2);
brick.GyroCalibrate(gyroSensorPort);

stopSignColor = 5;
endColor = 3;
atGoal = 0;
stoppedAlready = 0;
wallDist = 40;
turnCounter = 0;
disp(brick.ColorCode(colorSensorPort));
%main program goes here

while(atGoal ~= 1)
    while(brick.TouchPressed(touchSensorPort) ~= 1)
        pause(0.01);
        if brick.ColorCode(colorSensorPort) == endColor || key == 'q'
            atGoal = 1;
           break; 
        end
        
        if(stoppedAlready ~= 1 && brick.ColorCode(colorSensorPort) == stopSignColor) %Handles stop lines
            brick.StopMotor('AD');
            pause(1);
            stoppedAlready = 1; % prevents us from stopping indefinitely
        end
        if(brick.ColorCode(colorSensorPort) ~= stopSignColor) % allows us to handle a second stop sign
            stoppedAlready = 0;
        end
        if(turnCounter > 12 && brick.UltrasonicDist(ultrasonicSensorPort) > wallDist)
            brick.MoveMotorAngleRel('A', 50, 240); % drive halfway through next tile
            brick.MoveMotorAngleRel('D', 55, 240);
            brick.WaitForMotor('AD');
            
            turn(90);
            turnCounter = 0;
        end
        
        brick.MoveMotor('A', 50); % move forward
        brick.MoveMotor('D', 55); % right side drive is higher speed TODO: ADD PID FOR THIS INSTEAD
        turnCounter = turnCounter+1;
    end
    if(atGoal ~= 1)
        brick.MoveMotorAngleRel('A', -50, 360); % back up from wall
        brick.MoveMotorAngleRel('D', -55, 360); % back up from wall
        brick.WaitForMotor('AD');

        turn(-90);
    end
end

brick.StopAllMotors();
CloseKeyboard();


% This function is no longer used and only exists here in memory of its
% service RIP 

% function turnRight90(brick)
%    multi = 2.25;
%    brick.MoveMotorAngleRel('A', 30, 90 * multi, 'Brake');
%    brick.MoveMotorAngleRel('D', -30, 90 * multi, 'Brake');
%    brick.WaitForMotor('AD');
%    pause(0.5);
% end

function turn(degrees)
   global brick;
   global gyroSensorPort;
   
   startAngle = brick.GyroAngle(gyroSensorPort);
   dir = degrees / abs(degrees);
   for i = 1:2
       while(abs(brick.GyroAngle(gyroSensorPort) - startAngle) < abs(degrees))
           brick.MoveMotor('A', 60 * dir / i);
           brick.MoveMotor('D', -60 * dir / i);
           pause(0.01);
       end
       brick.StopMotor('AD', "Brake");
       pause(0.2);
       while(abs(brick.GyroAngle(gyroSensorPort) - startAngle) > abs(degrees))
           brick.MoveMotor('A', -45 * dir / i);
           brick.MoveMotor('D', 45 * dir / i);
           pause(0.01);
       end
   end
   brick.StopMotor('AD', "Brake");
   pause(0.5);
end

        