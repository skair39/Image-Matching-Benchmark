% EVALUATE CAMERA POSE
clear; clc; close all;

wkdir = [pwd '/../'];

status=system('systeminfo'); 
if status==0 
   os='windows'; 
else 
  status=system('uname -a'); 
  if status==0 
      os='linux'; 
  else 
      os='unknown'; 
  end 
end 

exe = '';
if (strcmp(os, 'windows')==1)
    exe = [wkdir 'Algorithms/build/Release/RunAlgorithms.exe '];
else
    if (strcmp(os, 'linux')==1)
        exe = [wkdir 'Algorithms/build/RunAlgorithms '];
    end
end
    
% All datasets
% Datasets = {[wkdir 'Dataset/01-office/'], ...   
%     [wkdir 'Dataset/02-teddy/'],...
%     [wkdir 'Dataset/03-large-cabinet/'],...
%     [wkdir 'Dataset/04-kitti/'],...
%     [wkdir 'Dataset/05-castle/'],...
%     [wkdir 'Dataset/06-office-wide/'], ...
%     [wkdir 'Dataset/07-teddy-wide/'],...
%     [wkdir 'Dataset/08-large-cabinet-wide/']};

% All Features and Matching 
%Features = {'sift', 'surf', 'orb', 'akaze','brisk', 'kaze'};
%Matching = {'ratio', 'gms'};

% for testing
Datasets = {[wkdir 'Dataset/03-large-cabinet/']};
Features = {'orb'};
Matching = {'ratio'};

parfor d = 1 : length(Datasets)
   for f = 1 : length(Features)
        for m = 1 : length(Matching) 
            command = [exe Features{f} ' ' Matching{m} ' ' Datasets{d}];
            system(command);
        end
   end
end
