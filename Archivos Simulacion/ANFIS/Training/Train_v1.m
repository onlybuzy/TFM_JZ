clc;clear;

training_w = zeros(1000,5);
LD = linspace(0.1,1,1000)';
training_w(:,1) = LD(randperm(size(LD, 1)), :);
FD = linspace(0.1,1,1000)';
training_w(:,2) = FD(randperm(size(FD, 1)), :);
RD = linspace(0.1,1,1000)';
training_w(:,3) = RD(randperm(size(RD, 1)), :);

i =1;
while i<=1000

if training_w(i,1) == training_w(i,2)  && training_w(i,2) == training_w(i,3)
    training_w(i,4)= 8-(12/0.9)*(1-training_w(i,1));
    training_w(i,5)= 8-(12/0.9)*(1-training_w(i,1));
else
    if min(training_w(i,1:3))==training_w(i,1)
        training_w(i,4)=8-(4/0.9)*(1-training_w(i,1));
        training_w(i,5)=8-(12/0.9)*(1-training_w(i,1));
    elseif min(training_w(i,1:3))==training_w(i,2)
        training_w(i,4)=8-(4/0.9)*(1-training_w(i,2));
        training_w(i,5)=8-(12/0.9)*(1-training_w(i,2));
    elseif min(training_w(i,1:3))==training_w(i,3)
        training_w(i,4)=8-(12/0.9)*(1-training_w(i,3));
        training_w(i,5)=8-(4/0.9)*(1-training_w(i,3));
    else
    %some conditions
    end
end
i = i+1;
end

training_wl = training_w(:,1:4);
training_wr= training_w(:,[1:3,5]);
