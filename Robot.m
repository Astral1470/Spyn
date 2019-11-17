classdef Robot
    properties (Constant)
        debugMode = false;
        resetRampMode = false;
        rampClosedPosition = 0;
        rampLiftingPosition = 124;
        rampOpenPosition = 172;

        %Motor Ports
        leftDriveMotor = 'A';
        rightDriveMotor = 'D';
        drivetrainMotors = strcat(Robot.leftDriveMotor, Robot.rightDriveMotor);
        rampMotor = 'C';
        allMotors = strcat(Robot.leftDriveMotor, Robot.rightDriveMotor, Robot.rampMotor);

        %Sensor Ports
        touchSensorPort = 1;
        colorSensorPort = 2;
        ultrasonicSensorPort = 3;
        gyroSensorPort = 4;
    end
    methods (Static)
        %%%% MOTOR FUNCTIONS %%%%
        %%Sets both drivetrain motors at once
        function moveDriveTrain(leftPower, rightPower)
            global brick
            brick.MoveMotor(Robot.leftDriveMotor, leftPower);
            brick.MoveMotor(Robot.rightDriveMotor, rightPower);
        end

        %%Brakes the drivetrain motors
        function brakeDriveTrain()
            global brick
            brick.StopMotor(Robot.drivetrainMotors, "Brake");
        end

        %%Changes to mode of the door to one of: "open", "lifting", "closed"
        function changeDoorMode(doorMode)
            global brick
            if doorMode == "open"
                if Robot.debugMode
                    Robot.print("Opening Door");
                end
                brick.MoveMotorAngleAbs(Robot.rampMotor, 20, Robot.rampOpenPosition, 'Brake'); 
            elseif doorMode == "lifting"
                if Robot.debugMode
                    Robot.print("Lifting Door");
                end
                brick.MoveMotorAngleAbs(Robot.rampMotor, 20, Robot.rampLiftingPosition, 'Brake');
            elseif doorMode == "closed"
                if Robot.debugMode
                    Robot.print("Closing Door");
                end
                brick.MoveMotorAngleAbs(Robot.rampMotor, 100, Robot.rampClosedPosition, 'Brake');

            else
                error("Invalid Door Mode Requested (Check spelling/grammer?)");
            end
        end

        %%Resets the motor angles of the desired motors
        function resetMotorAngles(motors)
            global brick
            brick.ResetMotorAngle(motors);
            if Robot.debugMode
                Robot.print("Resetting Angles for motors: " + motors);
            end
        end

        %%Stops all motors
        function stopAllMotors()
            global brick
            brick.StopAllMotors();
        end

        %%%%SENSOR FUNCTIONS %%%%
        %%Gets if the front touch sensor was pushed
        function frontTouchSensor = getFrontTouchSensor()
            global brick
            frontTouchSensor = brick.TouchPressed(Robot.touchSensorPort);
        end

        %%%MISC FUNCTIONS %%%%
        %%performs nessesary startup operations
        function startupOperations()
            Robot.connectToBrick();

            InitKeyboard();

            %global allMotors
            %Maybe dont want this so that the ramp stays in the same place
            %resetMotorAngles(allMotors); 
            try
                Robot.print("Battery Level: " + Robot.getBatteryLevel() + "%");
            catch
                error('Well it would appear that there is a valid instance of brick but it is also not. Try restarting matlab.');
            end

        end

        %%Connects to the brick if we are not already
        function connectToBrick()
            global brick
            if isempty(brick)
                Robot.print("Connecting to Brick...");
                brick = ConnectBrick("group5");
                try
                    brick.playTone(100, 800, 500);
                catch
                    error('Well it would appear that there is a valid instance of brick but it is also not. Try restarting matlab.');
                end
            else
                Robot.print("Brick already connected.");
            end
        end

        %%Gets the battery Level
        function batteryLevel = getBatteryLevel()
            global brick
            batteryLevel = brick.GetBattLevel();
        end

        %%Cleansup things to get ready to close
        function cleanup()
            global brick
            brick.StopAllMotors();
            CloseKeyboard();
        end

        %%Simple print function to make it look nice and because im lazy and wanted the word print
        function print(x)
            disp(x);
        end
    end
end