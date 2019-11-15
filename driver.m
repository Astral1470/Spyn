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
        case 'space'
                brick.MoveMotorAngleAbs(rampMotor, 20, 0, 'Brake'); 
                brick.WaitForMotor(rampMotor);
        case 'enter'
                brick.MoveMotorAngleAbs(rampMotor, 20, 80, 'Brake'); 
                brick.WaitForMotor(rampMotor);
        case 'tab'
                brick.MoveMotorAngleAbs(rampMotor, 20, 110, 'Brake'); 
                brick.WaitForMotor(rampMotor);
        case 'q'
            break;
        case 0
            brick.StopMotor(leftDriveMotor);
            brick.StopMotor(rightDriveMotor);
    end
end

CloseKeyboard();
