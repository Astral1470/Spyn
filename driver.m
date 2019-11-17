import Robot

Robot.startupOperations();

%Main Robot Loop
while true 
    pause(0.01); %Pause to not overload (Seconds(NOT milliseconds))
    
    %Keyboard controls
    global key
    switch key %key is automatically updated from an external program
        case 'uparrow' %Move Forward
            Robot.moveDriveTrain(100, 100);
        case 'downarrow' %Move Backward
            Robot.moveDriveTrain(-100, -100);
        case 'leftarrow' %Move Left
            Robot.moveDriveTrain(-50, 50);
        case 'rightarrow' %Move Right
            Robot.moveDriveTrain(50, -50);
        case 'tab' %Close Door
            Robot.changeDoorMode("closed");
        case 'return' %Lift Person
            Robot.changeDoorMode("lifting");
        case 'space' %Lower Door
            Robot.changeDoorMode("open");
        case 'r' %Reset Door Position
                if Robot.resetRampMode
                    Robot.resetMotorAngles(rampMotor);
                    Robot.print("Reset Ramp Motor!!!");
                end
        case 'q' %Quit
            break;
        case 0
            Robot.brakeDriveTrain();
    end %End of Switch
    
    %Diplay Info
    if Robot.resetRampMode
        Robot.print(brick.GetMotorAngle('C'));
    end
    if Robot.debugMode
        %Random Useful Info
    end
end %End of Main Robot Loop

Robot.cleanup();
