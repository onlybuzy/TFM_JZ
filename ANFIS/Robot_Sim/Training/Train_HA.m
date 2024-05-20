clc, clear

train_w_HA=zeros(3000,3);

HA=-180 + (360) * rand(3000, 1);

train_w_HA(:,1)=HA;

i=1;

while i<=3000
    if train_w_HA(:,1) == 0
        train_w_HA(:,2) = 9;
        train_w_HA(i,3) = 9;
    elseif train_w_HA(i,1)>0 && train_w_HA(i,1)<=180
        train_w_HA(i,2) = 9-train_w_HA(i,1)*(12/180);
        train_w_HA(i,3) = 9-train_w_HA(i,1)*(4/180);
    elseif train_w_HA(i,1)>=-180 && train_w_HA(i,1)<0
        train_w_HA(i,2) = 9+train_w_HA(i,1)*(4/180);
        train_w_HA(i,3) = 9+train_w_HA(i,1)*(12/180);
    end
    i = i+1;
end

train_HA=train_w_HA(1:2250,:);
test_HA=train_w_HA(2251:3000,:);

train_HA_l=train_HA(:,[1,2,]);
test_HA_l=test_HA(:,[1,2,]);

train_HA_r=train_HA(:,[1,3]);
test_HA_r=test_HA(:,[1,3]);



