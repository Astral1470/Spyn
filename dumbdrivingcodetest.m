%runs on startup to ensure we are connected to the brick
if exist('brick', 'var') == 0 %only connect once
    brick = ConnectBrick("group5");
    brick.playTone(100, 800, 500); %beep to say we
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
stopSignColor = 5;
endColor = 3;
atGoal = 0;
stoppedAlready = 0;


disp(brick.ColorCode(colorSensorPort));
%main program goes here
while(atGoal ~= 1)
    turnCounter = 0;
    disp('hi');
    while(brick.TouchPressed(touchSensorPort) ~= 1)
        if brick.ColorCode(colorSensorPort) == endColor || key == 'q'
            atGoal = 1;
           break; 
        end
        
        if(stoppedAlready ~= 1 && brick.ColorCode(colorSensorPort) == stopSignColor) %Handles stop lines
            brick.StopMotor('AD');
            pause(1);
            stoppedAlready = 1;
        end
        if(brick.ColorCode(colorSensorPort) ~= stopSignColor)
            stoppedAlready = 0;
        end
        
        brick.MoveMotor('A', 50); % move forward
        brick.MoveMotor('D', 55); % right side drive is higher speed TODO: ADD PID FOR THIS INSTEAD
        turnCounter = turnCounter+1;
    end
    if(atGoal ~= 1)
        brick.MoveMotorAngleRel('A', -50, 360); % back up from wall
        brick.MoveMotorAngleRel('D', -55, 360); % back up from wall
        brick.WaitForMotor('AD');
        if turnCounter > 10
            turnRight90(brick);
            pause(0.5);
            turnRight90(brick);
            pause(0.5);
            turnRight90(brick);
            turnCounter = 0;
        else
            turnRight90(brick);
            pause(0.5);
            turnRight90(brick);
            turnCounter = 10;
        end
    end
end

brick.StopAllMotors();
CloseKeyboard();

function turnRight90(brick)
   multi = 2.25;
   brick.MoveMotorAngleRel('A', 30, 90 * multi, 'Brake');
   brick.MoveMotorAngleRel('D', -30, 90 * multi, 'Brake');
   brick.WaitForMotor('AD');
end

        