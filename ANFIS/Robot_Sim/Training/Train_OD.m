

train_w=zeros(3000,5);
LD = 0.1 + (0.85 - 0.1) * rand(3000, 1);
FD = 0.1 + (0.85 - 0.1) * rand(3000, 1);
RD = 0.1 + (0.85 - 0.1) * rand(3000, 1);

train_w(:,1)=LD;
train_w(:,2)=FD;
train_w(:,3)=RD;

i =1;

while i<=3000

if train_w(i,1) == train_w(i,2)  && train_w(i,2) == train_w(i,3)
    train_w(i,4)= 9-(12/0.9)*(1-train_w(i,1));
    train_w(i,5)= 9-(12/0.9)*(1-train_w(i,1));
else
    if min(train_w(i,1:3))==train_w(i,1)
        train_w(i,4)=9-(4/0.9)*(1-train_w(i,1));
        train_w(i,5)=9-(12/0.9)*(1-train_w(i,1));
    elseif min(train_w(i,1:3))==train_w(i,2)
        train_w(i,4)=9-(4/0.9)*(1-train_w(i,2));
        train_w(i,5)=9-(12/0.9)*(1-train_w(i,2));
    elseif min(train_w(i,1:3))==train_w(i,3)
        train_w(i,4)=9-(12/0.9)*(1-train_w(i,3));
        train_w(i,5)=9-(4/0.9)*(1-train_w(i,3));
    else
    %some conditions
    end
end
i = i+1;
end


train_od=train_w(1:2250,:);
test_od=train_w(2251:3000,:);


train_od_l=train_od(:,1:4);
test_od_l=test_od(:,1:4);

train_od_r=train_od(:,[1:3,5]);
test_od_r=test_od(:,[1:3,5]);

