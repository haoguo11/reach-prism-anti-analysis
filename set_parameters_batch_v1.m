
% Set parameters for all analyses

% Copyright (C) 2024  Hao Guo

% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%% set parameters: dataset
area = 'PRR';

postfix = '.mat';
% postfix = '_block.mat'; % for block-designed PA data

kernel = 'g20';
% kernel = 'g50';

preProcess = 1; % '0' for using raw data

%% set parameters: analysis window
% Note: in the raw data (161 bins), time(77) = -40, thus index = 77 represents 
%       the neural activity from -50 to -40 ms.
% tPhase = 62:121 means the analysis window is set to [-200 400] ms.
% tPhase = 42:86 means the analysis window is set to [-400 50] ms.

alignedEvent = {'pre'};       tPhase = 62:121;	phase = {'visualCue'};

%% set parameters: task conditions
% Cuing type in PA dataset
nameCuingType = {'ECES','LCLS','ECLS','LCES'}; % we only use ECES in Results

% conditions
switch prefix
    case 'DovePrism'
        condition = 1:4;
    case 'Prism+Anti'
        condition = 1:6;
    case 'PA'
        condition = [1 2 5 6]; % 1234 represent LRUD Pro, 5678 for LRUD Anti
        % condition = 1:8;
end

%% load data
%%%%% load the data aligned to 'alignedEvent{1}' %%%%%
for iM = 1:size(monkey,1)
    loadFileNameCell{iM,1} = [pwd '\Datasets\' prefix '_' monkey{iM} '_' alignedEvent{1} '_' area '_' kernel 'psth' postfix];
end
[loadFileName,numT,psthTA1,psthTT1,time1] = ...
    load_data(loadFileNameCell,monkey,prefix,CuingType,tPhase(1,:),condition,preProcess);
psthTA = psthTA1;   psthTT = psthTT1;   time = time1;

%%%%% load the data aligned to 'alignedEvent{2}' %%%%%
if size(alignedEvent,1) == 2 
    for iM = 1:size(monkey,1)
        loadFileNameCell2{iM,1} = [pwd '\Datasets\' prefix '_' monkey{iM} '_' alignedEvent{2} '_' area '_' kernel 'psth' postfix];
    end
    loadFileName = regexprep(loadFileName, alignedEvent{1}, '2Phases');
    [~,numT2,psthTA2,psthTT2,time2] = ...
        load_data(loadFileNameCell2,monkey,prefix,CuingType,tPhase(2,:),condition,preProcess);
    
    if ~isequal(numT,numT2)
        warning('The number of trials in two phases should be the same');
    end
    
    psthTA = cat(3,psthTA1,psthTA2);
    psthTT = cat(2,psthTT1,psthTT2);
    time = [time1;time2];
else
end

%% select units based on number of trials
switch postfix
    case '.mat'
        threNumTrial = 10; % 40     
    case '_block.mat'
        threNumTrial = 10;
end

selectUnit = ~any(numT(:,:) < threNumTrial , 2);
fprintf('%d units(among %d) are selected because of trial-number restriction.\n', sum(selectUnit),size(numT,1));

numT = numT(selectUnit,:);
psthTA = psthTA(selectUnit,:,:);
psthTT = psthTT(selectUnit,:);
fprintf('%d units in psthTA.\n', size(psthTA,1));
fprintf('%d units in psthTT.\n', size(psthTT,1));

if size(alignedEvent,1) == 2
    condition = [condition condition];
end

%% set parameters for plotting figures
switch prefix
    case 'DovePrism'
        plotPara.condColor = [0.2 0.8 0.2 ; 0.2 0.8 0.2 ; 1 0.39 0.28 ; 1 0.39 0.28];
        plotPara.condLinestyle = {'-';':';'-';':'};
        plotPara.condLegend = {'Normal Left';'Normal Right';'Prism Left';'Prism Right'};
        
    case 'Prism+Anti'
        plotPara.condColor = [0.2 0.8 0.2 ; 0.2 0.8 0.2 ; 1 0.39 0.28 ; 1 0.39 0.28;...
            0 0.48 0.76 ; 0 0.48 0.76 ; 0.4 0.2 0.6 ; 0.4 0.2 0.6];
        plotPara.condLinestyle = {'-';':';'-';':';'-';':';'-';':'};
        plotPara.condLegend = {'Normal Left';'Normal Right';'Prism Left';'Prism Right';...
            'Normal Left Anti';'Normal Right Anti';'Prism Left Anti';'Prism Right Anti'};
        
    case 'PA'
        plotPara.condColor = [0.2 0.8 0.2; 0.2 0.8 0.2;  0.25 0.25 0.9; 0.25 0.25 0.9;...
            0 0.48 0.76 ; 0 0.48 0.76; 0.4 0.2 0.6 ; 0.4 0.2 0.6];
        plotPara.condLinestyle = {'-';':';'-';':';'-';':';'-';':'};
        plotPara.condLegend = {'Pro Left';'Pro Right';'Pro Up';'Pro Down';...
            'Anti Left';'Anti Right';'Anti Up';'Anti Down'};
end
