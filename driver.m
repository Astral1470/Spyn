%Constants
global debugMode
debugMode = false;
global resetRampMode
resetRampMode = false;
global rampClosedPosition
rampClosedPosition = 0;
global rampLiftingPosition
rampLiftingPosition = 124;
global rampOpenPosition
rampOpenPosition = 172;

%Motor Ports
global leftDriveMotor
leftDriveMotor = 'A';
global rightDriveMotor
rightDriveMotor = 'D';
global drivetrainMotors
drivetrainMotors = strcat(leftDriveMotor, rightDriveMotor);
global rampMotor
rampMotor = 'C';
global allMotors
allMotors = strcat(leftDriveMotor, rightDriveMotor, rampMotor);

%Sensor Ports
global touchSensorPort
touchSensorPort = 1;
global colorSensorPort
colorSensorPort = 2;
global ultrasonicSensorPort
ultrasonicSensorPort = 3;
global gyroSensorPort
gyroSensorPort = 4;

startupOperations();

while true %Main Robot Loop
    pause(0.01); %Pause to not overload (Seconds(NOT milliseconds))
    
    %Keyboard controls
    global key
    switch key %key is automatically updated from an external program
        case 'uparrow' %Move Forward
            moveDriveTrain(100, 100);
        case 'downarrow' %Move Backward
            moveDriveTrain(-100, -100);
        case 'leftarrow' %Move Left
            moveDriveTrain(-50, 50);
        case 'rightarrow' %Move Right
            moveDriveTrain(50, -50);
        case 'tab' %Close Door
            changeDoorMode("closed");
        case 'return' %Lift Person
            changeDoorMode("lifting");
        case 'space' %Lower Door
            changeDoorMode("open");
        case 'r' %Reset Door Position
                if resetRampMode
                    resetMotorAngles(rampMotor);
                    display("Reset Ramp Motor!!!");
                end
        case 'q' %Quit
            break;
        case 0
            brakeDriveTrain();
    end %End of Switch
    
    %Diplay Info
    if resetRampMode
        display(brick.GetMotorAngle('C'));
    end
    if debugMode
        %Random Useful Info
    end
end %End of Main Robot Loop

cleanup();

%%%% MOTOR FUNCTIONS %%%%
%% Sets both drivetrain motors at once
function moveDriveTrain(leftPower, rightPower)
    global brick
    global leftDriveMotor
    global rightDriveMotor
    brick.MoveMotor(leftDriveMotor, leftPower);
    brick.MoveMotor(rightDriveMotor, rightPower);
end

%% Brakes the drivetrain motors
function brakeDriveTrain()
    global brick
    global drivetrainMotors
    brick.StopMotor(drivetrainMotors, "Brake");
end

%% Changes to mode of the door to one of: "open", "lifting", "closed"
function changeDoorMode(doorMode)
    global brick
    global rampMotor
    global rampOpenPosition
    global rampLiftingPosition
    global rampClosedPosition
    global debugMode
    if doorMode == "open"
        if debugMode
            display("Opening Door");
        end
        brick.MoveMotorAngleAbs(rampMotor, 20, rampOpenPosition, 'Brake'); 
        brick.WaitForMotor('A'); % Wait for motor to complete motion
    elseif doorMode == "lifting"
        if debugMode
            display("Lifting Door");
        end
        brick.MoveMotorAngleAbs(rampMotor, 20, rampLiftingPosition, 'Brake');
    elseif doorMode == "closed"
        if debugMode
            display("Closing Door");
        end
        brick.MoveMotorAngleAbs(rampMotor, 100, rampClosedPosition, 'Brake');
        
    else
        error("Invalid Door Mode Requested (Check spelling/grammer?)");
    end
end

%% Resets the motor angles of the desired motors
function resetMotorAngles(motors)
    global brick
    global debugMode
    brick.ResetMotorAngle(motors);
    if debugMode
        display("Resetting Angles for motors: " + motors);
    end
end

%% Stops all motors
function stopAllMotors()
    global brick
    brick.StopAllMotors();
end

%%%% SENSOR FUNCTIONS %%%%
%% Gets if the front touch sensor was pushed
function frontTouchSensor = getFrontTouchSensor()
    global brick
    global touchSensorPort
    frontTouchSensor = brick.TouchPressed(touchSensorPort);
end

%%% MISC FUNCTIONS %%%%
%% performs nessesary startup operations
function startupOperations()
    connectToBrick();

    InitKeyboard();

    %global allMotors
    %Maybe dont want this so that the ramp stays in the same place
    %resetMotorAngles(allMotors); 
    try
        display("Battery Level: " + getBatteryLevel() + "%");
    catch
        error('Well it would appear that there is a valid instance of brick but it is also not. Try restarting matlab.');
    end
    
end

%% Connects to the brick if we are not already
function connectToBrick()
    global brick
    if isempty(brick)
        display("Connecting to Brick...");
        brick = ConnectBrick("group5");
        try
            brick.playTone(100, 800, 500);
        catch
            error('Well it would appear that there is a valid instance of brick but it is also not. Try restarting matlab.');
        end
    else
        display("Brick already connected.");
    end
end

%% Gets the battery Level
function batteryLevel = getBatteryLevel()
    global brick
    batteryLevel = brick.GetBattLevel();
end

%% Cleansup things to get ready to close
function cleanup()
    global brick
    brick.StopAllMotors();
    CloseKeyboard();
end
