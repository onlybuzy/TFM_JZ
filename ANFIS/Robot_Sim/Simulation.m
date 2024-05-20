function Simulation(clientID,sim,Handle,fis_R,fis_L,fis_HA_R,fis_HA_L,simTime)

%Object Handles
RobotHandle = Handle(:,1);
SensorHandle = Handle(:,2:4);
MotorHandle = Handle(:,5:6);
TargetHandle = Handle(:,7:9);

vel_A=[];

ave=0;

figure ;
h1 = animatedline("Color",'b','LineWidth',2);
axis([-12.5,12.5,-12.5,12.5]);
set(gca, 'XDir','reverse','YDir','reverse')
xlabel('x');ylabel('y');title('Trayectoria');
grid on
box on

figure ;
h2 = animatedline("Color",'g','LineWidth',1);
xlabel('Tiempo(s)');ylabel('Velocidad(m/s)');title('Velocidad Robot vs. Tiempo');
grid on
box on

figure ;
h3 = animatedline("Color",'k','LineWidth',1);
xlabel('Tiempo(s)');ylabel('Angulo de Rumbo');title('Angulo de Rumbo vs Tiempo');
grid on
box on

figure ;
h4 = animatedline("Color",'y','LineWidth',0.6);
xlabel('Tiempo(s)');ylabel('Distancia (m)');title('Distancia al objetivo vs Tiempo');
grid on
box on


% subplot(3,5,[4 5])
% h2 = animatedline("Color",'g','LineWidth',0.5);
% xlabel('time(s)');ylabel('Velocity(m/s)');title('Velocty vs. Time');
% box on
%
% subplot(3,5,[9 10])
% h3 = animatedline("Color",'k','LineWidth',0.5);
% box on
% xlabel('time(s)');ylabel('Steering Angle(degree)');title('Steering Angle vs Time');
%
% subplot(3,5,[14 15])
% h4 = animatedline("Color",'y','LineWidth',0.5);
% box on
% xlabel('time(s)');ylabel('Distance(m)');title('Distance from Target vs Time');



%Simulation preparation
RobotPosition=zeros(1,3);
TargetPositionRobotFrame=zeros(1,3);
SensorDetectionState=zeros(1,3);
SensorDetectedPoint=zeros(3,3,1);
OD=zeros(1,3);
Distance=zeros(1,1);
Vel=zeros(1,3);
it=1;
itr = 0;
elapsedTime = 0;
tic;

while elapsedTime<=simTime
    itr=itr+1;
    if itr==1
        opmode = sim.simx_opmode_streaming;
    else
        opmode = sim.simx_opmode_buffer;
    end


    while it<4

        [~,RobotPosition(1,:)] = sim.simxGetObjectPosition(clientID,RobotHandle(1,:),-1,opmode);
        [~,TargetPositionRobotFrame(1,:)]= sim.simxGetObjectPosition(clientID,TargetHandle(1,it),RobotHandle(1,:),opmode);
        Distance(1,:)=norm(norm(TargetPositionRobotFrame(1,:)));
        [~,Vel(1,:)]=sim.simxGetObjectVelocity(clientID,RobotHandle(1,:),opmode);
        [~,SensorDetectionState(1,1),SensorDetectedPoint(1,:,1),~,~] = sim.simxReadProximitySensor(clientID,SensorHandle(1,1),opmode);
        [~,SensorDetectionState(1,2),SensorDetectedPoint(2,:,1),~,~] = sim.simxReadProximitySensor(clientID,SensorHandle(1,2),opmode);
        [~,SensorDetectionState(1,3),SensorDetectedPoint(3,:,1),~,~] = sim.simxReadProximitySensor(clientID,SensorHandle(1,3),opmode);



        if SensorDetectionState(1,1) == 0 && SensorDetectionState(1,2) == 0 && SensorDetectionState(1,3) == 0

            HA=-atan2d(TargetPositionRobotFrame(1,2),TargetPositionRobotFrame(1,1));

            HAvel_R=evalfis(fis_HA_R,HA);
            HAvel_L=evalfis(fis_HA_L,HA);

            if  Distance(1,:)>1
                sim.simxSetJointTargetVelocity(clientID,MotorHandle(1,1),0.9*HAvel_R,sim.simx_opmode_oneshot);
                sim.simxSetJointTargetVelocity(clientID,MotorHandle(1,2),0.9*HAvel_L,sim.simx_opmode_oneshot);
            else
                sim.simxSetJointTargetVelocity(clientID,MotorHandle(1,1),0.9*HAvel_R*Distance(1,:),sim.simx_opmode_oneshot);
                sim.simxSetJointTargetVelocity(clientID,MotorHandle(1,2),0.9*HAvel_L*Distance(1,:),sim.simx_opmode_oneshot);
            end



        else

            OD(1,:) = ObstacleDistance(SensorDetectionState(1,:),SensorDetectedPoint(:,:,1));

            if OD(1,1)>0.85
                OD(1,1)=0.85;
            end
            if OD(1,2)>0.85
                OD(1,2)=0.85;
            end
            if OD(1,3)>0.85
                OD(1,3)=0.85;
            end



            VelR=evalfis(fis_R,OD(1,:));

            VelL=evalfis(fis_L,OD(1,:));



            sim.simxSetJointTargetVelocity(clientID,MotorHandle(1,1),0.9*VelL,sim.simx_opmode_oneshot);
            sim.simxSetJointTargetVelocity(clientID,MotorHandle(1,2),0.9*VelR,sim.simx_opmode_oneshot);


        end

        if Distance(1,:)<0.3 &&  Distance(1,:)>0.1
            itr=0;
            break
        end

        if double(RobotPosition(1,1))~=0 && double(RobotPosition(1,2))~=0

            addpoints(h1,double(RobotPosition(1,1)),double(RobotPosition(1,2)));
            addpoints(h2,elapsedTime,double(norm(Vel(1,1))));
            vel_A(end+1) = norm(Vel(1,1));
            addpoints(h3,elapsedTime,double(-HA(1,:)));
            addpoints(h4,elapsedTime,double(Distance(1,:)));
            drawnow limitrate;

        end

        elapsedTime = toc;



        % addpoints(h2,elapsedTime,double(norm(Vel(1,1))));
        % addpoints(h3,elapsedTime,double(-HA(1,:)));
        % addpoints(h4,elapsedTime,double(Distance(1,:)));


    end

    it=it+1;

    if it==2
        sim.simxSetJointTargetVelocity(clientID,MotorHandle(1,1),0,sim.simx_opmode_oneshot);
        sim.simxSetJointTargetVelocity(clientID,MotorHandle(1,2),0,sim.simx_opmode_oneshot);
        display(mean(vel_A))
        break
    end

 
end





