function [ rSPs, tSPs, rAPs, tAPs , num] = Evaluate( Dataset,Features,Matching,AngleThreshold, type)
%EVALUATE Summary of this function goes here
%   Detailed explanation goes here

fileGt  = [Dataset 'pairs.txt'];

NumMethods = length(Features) * length(Matching);
rSPs = zeros(AngleThreshold, NumMethods);
tSPs = zeros(AngleThreshold, NumMethods);
rAPs = zeros(AngleThreshold, NumMethods);
tAPs = zeros(AngleThreshold, NumMethods);

count = 1;
for f = 1 : length(Features)
   for m = 1 : length(Matching)
       if type == 1 
          filename = [Dataset 'Results/' Features{f} '_' Matching{m} '.txt'];
       end
       if type == 2
          filename = [Dataset 'Results2/' Features{f} '_' Matching{m} '.txt'];
       end
       
            [rSP, tSP, rAP, tAP, num] = ComparePoses(filename, fileGt, AngleThreshold);
       rSPs(:,count) = rSP;
       tSPs(:,count) = tSP;
       rAPs(:,count) = rAP;
       tAPs(:,count) = tAP;
       count = count + 1;
   end
end



end

function [ rSP, tSP, rAP, tAP, numbers ] = ComparePoses( fileRes,fileGt, AngleThreshold)
%EVALUATE Summary of this function goes here
%   Detailed explanation goes here

[ninliers, posesRes] = LoadResults(fileRes);
[posesGt] = LoadGt(fileGt);

num = size(ninliers,1);

% the first column is rotatio, the second is translation
rSP = zeros(AngleThreshold,1);
tSP = zeros(AngleThreshold,1);
rAP = zeros(AngleThreshold,1);
tAP = zeros(AngleThreshold,1);


for idx = 1 : num
    
    if(ninliers(idx) < 10)
        continue;
    end
         
    [rError, tError] = GetPoseError(posesRes(idx,:), posesGt(idx,:));

    if(rError < AngleThreshold)
       rSP(1 + floor(rError)) = rSP(1 + floor(rError)) + 1;
       rAP(1 + floor(rError)) = rAP(1 + floor(rError)) + ninliers(idx);
    end
    
    if(tError < AngleThreshold)
       tSP(1 + floor(tError)) = tSP(1 + floor(tError)) + 1; 
       tAP(1 + floor(tError)) = tAP(1 + floor(tError)) + ninliers(idx); 
    end
end


rSP = cumsum(rSP); 
tSP = cumsum(tSP); 
rAP = cumsum(rAP);
tAP = cumsum(tAP);

numbers = num;

end







function [ ninliers, poses ] = LoadResults( fileRes )
A = dlmread(fileRes);
ninliers = A(:,3);
poses = A(:,4:15);
end

function [ posesGt ] = LoadGt( fileGt )
A = dlmread(fileGt);
posesGt = A(:,3:14);
end


function [rError, tError] = GetPoseError(poseRes, poseGt)
% pose is (1 * 12) matrix    
pose1 = reshape(poseRes,4,3);
pose1 = pose1';

pose2 = reshape(poseGt,4,3);
pose2 = pose2';


% Rotation
R1 = pose1(1:3, 1:3);
R2 = pose2(1:3, 1:3);
R_error = R1 \ R2;

a = R_error(1,1);
b = R_error(2,2);
c = R_error(3,3);
d = 0.5 * (a + b + c - 1.0);
rError = acos(max(min(d,1),-1)) * 180 / pi;
rError = abs(rError);

% Translation
t1 = pose1(1:3, 4); t1 = t1 / sqrt(t1'*t1);
t2 = pose2(1:3, 4); t2 = t2 / sqrt(t2'*t2);
tError = acos(t1' * t2) / pi * 180;
tError = abs(tError);


end



