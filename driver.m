if exist('brick', 'var') == 0
    brick = ConnectBrick("group5");
    brick.playTone(100, 800, 500);   
end

global key
InitKeyboard();

leftDriveMotor = 'A';
rightDriveMotor = 'D';
rampMotor = 'C';
colorSensorPort = 1;
touchSensorPort = 2;
ultrasonicSensorPort = 4;
gyroSensorPort = 3;



while 1
    pause(0.1);
    switch key
        case 'uparrow'
                brick.MoveMotor(leftDriveMotor, -100);
                brick.MoveMotor(rightDriveMotor, -100);
        case 'downarrow'
                brick.MoveMotor(leftDriveMotor, 100);
                brick.MoveMotor(rightDriveMotor, 100);
        case 'leftarrow'
                brick.MoveMotor(leftDriveMotor, -100);
                brick.MoveMotor(rightDriveMotor, 100);
        case 'rightarrow'
                brick.MoveMotor(leftDriveMotor, 100);
                brick.MoveMotor(rightDriveMotor, -100);
        case 'tab' %Close Door
                brick.MoveMotorAngleAbs(rampMotor, 50, -60, 'Brake'); 
                brick.WaitForMotor(rampMotor);
        case 'return' %Lift Person
                brick.MoveMotorAngleAbs(rampMotor, 50, 70, 'Brake'); 
                brick.WaitForMotor(rampMotor);
        case 'space' %Lower Door
                brick.MoveMotorAngleAbs(rampMotor, 50, 120, 'Brake'); 
                brick.WaitForMotor(rampMotor);
        case 'q'
            break;
        case 0
            brick.StopMotor(leftDriveMotor);
            brick.StopMotor(rightDriveMotor);
    end
end

CloseKeyboard();
