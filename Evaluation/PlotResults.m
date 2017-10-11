clear; clc; close all;
addpath('./export_fig');

wkdir = '../';

Features = {'sift', 'surf', 'orb', 'akaze', 'brisk', 'kaze'};
Matching = {'ratio', 'gms'};
AngleThreshold = 15;

Types = {'-', '--'};
Colors = {'r', 'g', 'b', 'k', 'm', 'c'};

NumMethods = length(Features) * length(Matching);

mkdir('./Curves');
CurveNames = {'./Curves/tum_video_',...
    './Curves/kitti_video_',...
    './Curves/strecha_wide_',...
    './Curves/tum_wide_'};

Datasets = cell(4,1);
Datasets{1} = {[wkdir 'Dataset/01-office/'], ...
    [wkdir 'Dataset/02-teddy/'],...
    [wkdir 'Dataset/03-large-cabinet/']};
Datasets{2} = {[wkdir 'Dataset/04-kitti/']};
Datasets{3} = {[wkdir 'Dataset/05-castle/']};
Datasets{4} = {[wkdir 'Dataset/06-office-wide/'], ...
    [wkdir 'Dataset/07-teddy-wide/'],...
    [wkdir 'Dataset/08-large-cabinet-wide/']};

for row = 1 : 4
    rSPs = zeros(AngleThreshold, NumMethods);
    tSPs = zeros(AngleThreshold, NumMethods);
    rAPs = zeros(AngleThreshold, NumMethods);
    tAPs = zeros(AngleThreshold, NumMethods);
    numbers = 0;

    CurveName = CurveNames{row};
    Dataset = Datasets{row};
    
    wide = 0;
    if row > 2
        wide = 1;
    end
    
    for idx = 1 : length(Dataset)
        [rSP, tSP, rAP, tAP, num] = Evaluate( Dataset{idx},Features,Matching,AngleThreshold, 1);
        rSPs = rSPs + rSP;
        tSPs = tSPs + tSP;
        rAPs = rAPs + rAP;
        tAPs = tAPs + tAP;
        numbers = numbers + num;
    end

    rAPs = rAPs ./ rSPs;
    tAPs = tAPs ./ tSPs;

    if wide == 0
        rSPs = rSPs / numbers;
        tSPs = tSPs / numbers;
    end
    
    Legends = cell(NumMethods,1);

    x = 1 : AngleThreshold;
    h1 = figure;
    count = 1;
    for f = 1 : length(Features)
        for m = 1 : length(Matching)
            line = [Colors{f} Types{m}];
            plot(x, rSPs(:,count), line, 'linewidth', 3);
            hold on;
            Legends{count} = [Features{f} '-' Matching{m}];
            count = count + 1;
        end
    end
    legend(Legends,'Location','SouthEast', 'FontSize', 10);
    grid on;
    xlabel('Rotational Angle Threshold (Degrees)');
    ylabel('SP');
    export_fig(h1, [CurveName 'rsp.pdf'], '-transparent');

    h2 = figure;
    count = 1;
    for f = 1 : length(Features)
        for m = 1 : length(Matching)
            line = [Colors{f} Types{m}];
            plot(x, tSPs(:,count), line, 'linewidth', 3);
            hold on;
            count = count + 1;
        end
    end
    grid on;
    xlabel('Translational Angle Threshold (Degrees)');
    ylabel('SP');
    export_fig(h2, [CurveName 'tsp.pdf'], '-transparent');

    h3 = figure;
    count = 1;
    for f = 1 : length(Features)
        for m = 1 : length(Matching)
            line = [Colors{f} Types{m}];
            plot(x, rAPs(:,count), line, 'linewidth', 3);
            hold on;
            count = count + 1;
        end
    end
    grid on;
    xlabel('Rotational Angle Threshold (Degrees)');
    ylabel('AP');
    export_fig(h3, [CurveName 'rap.pdf'], '-transparent');

    h4 = figure;
    count = 1;
    for f = 1 : length(Features)
        for m = 1 : length(Matching)
            line = [Colors{f} Types{m}];
            plot(x, tAPs(:,count), line, 'linewidth', 3);
            hold on;
            count = count + 1;
        end
    end
    grid on;
    xlabel('Translational Angle Threshold (Degrees)');
    ylabel('AP');
    export_fig(h4, [CurveName 'tap.pdf'], '-transparent');
end