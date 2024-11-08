
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

numShuffle = 100; % numRandoms = 10,000 in Results

%% dataset must only contains left- and right- trials
% [{'Pro Left'};{'Pro Right'};{'Anti Left'};{'Anti Right'}]
dc = plotPara.condLegend(condition);
for iC = 1:length(dc)
    spStr = split(dc{iC});
    if ~strcmp(spStr{2},'Left') && ~strcmp(spStr{2},'Right')
        error('Data must contain only left and right trials.');
    end
end

numCond = size(psthTT,2);
if numCond~=4 && numCond~=6
    error('The number of conditions in psthTT should be 4 or 6.');
end

%% shuffle the left- and right- trials
TA_LR = cell(1,numShuffle);
numUnit = size(psthTT,1);

if ~strcmp(prefix,'Prism+Anti') % 4 conditions
    iShuffle = 1;
    while iShuffle <= numShuffle
        
        L1 = cell(numUnit,1);   R1 = cell(numUnit,1);
        L2 = cell(numUnit,1);   R2 = cell(numUnit,1);
        
        for iUnit = 1:numUnit
            [L1{iUnit,1} , R1{iUnit,1}] = shuffle_trial(psthTT{iUnit,1} , psthTT{iUnit,2});
            [L2{iUnit,1} , R2{iUnit,1}] = shuffle_trial(psthTT{iUnit,3} , psthTT{iUnit,4});
        end
        
        TA_LR{iShuffle} = tt2ta([L1 R1 L2 R2]);
        
        iShuffle = iShuffle+1;
    end
    
else % 6 conditions
    iShuffle = 1;
    while iShuffle <= numShuffle
        
        L1 = cell(numUnit,1);   R1 = cell(numUnit,1);
        L2 = cell(numUnit,1);   R2 = cell(numUnit,1);
        L3 = cell(numUnit,1);   R3 = cell(numUnit,1);
        
        for iUnit = 1:numUnit
            [L1{iUnit,1} , R1{iUnit,1}] = shuffle_trial(psthTT{iUnit,1} , psthTT{iUnit,2});
            [L2{iUnit,1} , R2{iUnit,1}] = shuffle_trial(psthTT{iUnit,3} , psthTT{iUnit,4});
            [L3{iUnit,1} , R3{iUnit,1}] = shuffle_trial(psthTT{iUnit,5} , psthTT{iUnit,6});
        end
        
        TA_LR{iShuffle} = tt2ta([L1 R1 L2 R2 L3 R3]);
        
        iShuffle = iShuffle+1;
    end
end

%% save
% change the name of .mat files
if strcmp(prefix,'PA')
    fileName = regexprep(loadFileName,'.mat',['_' nameCuingType{CuingType} '_shuffleData_LR.mat']);
else
    fileName = regexprep(loadFileName,'.mat','_shuffleData_LR.mat');
end

% redirect to folder in which the .mat files are saved
if ~exist('ShuffleData_LR','dir')
    mkdir('ShuffleData_LR')
end
saveFileName = regexprep(fileName,'\Datasets\','\ShuffleData_LR\');

save(saveFileName,'TA_LR','psthTT','time','-v7.3');
