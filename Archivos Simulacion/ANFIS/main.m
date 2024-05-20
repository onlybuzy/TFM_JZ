clc;clear;close all;
disp('Program started');
% sim=remApi('remoteApi','extApi.h'); % using the header (requires a compiler)
sim=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
sim.simxFinish(-1); % just in case, close all opened connections
clientID=sim.simxStart('127.0.0.1',19999,true,true,5000,5);
    
if (clientID>-1)
    disp('Connected to remote API server');
    fis_R=readfis('RWO.fis');
    fis_L=readfis('LWO.fis');
    fis_HA_R=readfis('W_HA_R.fis');
    fis_HA_L=readfis('W_HA_L.fis');
    simTime=500;
    Handle=ObjectHandle(clientID,sim);
    Simulation(clientID,sim,Handle,fis_R,fis_L,fis_HA_R,fis_HA_L,simTime);
    sim.simxGetPingTime(clientID);
    sim.simxFinish(clientID);
else
    disp('Failed connecting to remote API server');
end
sim.delete();
    