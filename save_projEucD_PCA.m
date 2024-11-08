
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

D = 6;

%%
loadFileNameLR = regexprep(loadFileName, '\Datasets\', '\ShuffleData_LR\');
loadFileNameContext = regexprep(loadFileName, '\Datasets\', '\ShuffleData_Context\');

if strcmp(prefix,'PA')
    loadFileNameLR = regexprep(loadFileNameLR, '.mat', ['_' nameCuingType{CuingType} '_shuffleData_LR.mat']);
    loadFileNameContext = regexprep(loadFileNameContext, '.mat', ['_' nameCuingType{CuingType} '_shuffleData_Context.mat']);
else
    loadFileNameLR = regexprep(loadFileNameLR, '.mat', '_shuffleData_LR.mat');
    loadFileNameContext = regexprep(loadFileNameContext, '.mat', '_shuffleData_Context.mat');
end

if exist(loadFileNameLR,'file') == 2
    load(loadFileNameLR);
    psthTTLR = psthTT;
    timeLR = time;
else
    error('Run save_shuffle_data_LR.m first.');
end

if exist(loadFileNameContext,'file') == 2
    load(loadFileNameContext);
    psthTTContext = psthTT;
    timeContext = time;
else
    error('Run save_shuffle_data_Context.m first.');
end

cName = plotPara.condLegend(condition);
dataLR = tt2ta(psthTTLR);
dataContext = tt2ta(psthTTContext);

sum(sum(sum(dataLR-psthTA)))

if ~isequal(dataLR,dataContext) || ~isequal(timeLR,timeContext)
    error('The analysis time window must match.');
end

%% calculate euclidean distance between Left and Right
sLR1 = cell(D,1); LR1 = cell(D,1); % Left vs. Right in Context 1
sLR2 = cell(D,1); LR2 = cell(D,1); % Left vs. Right in Context 2
for d = 1:D
    sLR1{d} = get_eucD_shuffle_LR(dataLR,TA_LR,cName,1:2,d);
    LR1{d} = get_eucD_shuffle_LR(dataLR,TA_LR,cName,1:2,1:d);
    sLR2{d} = get_eucD_shuffle_LR(dataLR,TA_LR,cName,3:4,d);
    LR2{d} = get_eucD_shuffle_LR(dataLR,TA_LR,cName,3:4,1:d);
end
if strcmp(prefix,'Prism+Anti')
    sLR3 = cell(D,1); LR3 = cell(D,1); % Left vs. Right in Context 3
    for d = 1:D
        sLR3{d} = get_eucD_shuffle_LR(dataLR,TA_LR,cName,5:6,d);
        LR3{d} = get_eucD_shuffle_LR(dataLR,TA_LR,cName,5:6,1:d);
    end
end

%% calculate euclidean distance between different Contexts
if ~strcmp(prefix,'Prism+Anti') % 4 cnditons
    nameCond = {'Context 1';'Context 2'};
    sContext12 = cell(D,1); Context12 = cell(D,1);
    for d = 1:D
        sContext12{d} = get_eucD_shuffle_Context(dataContext,TA_Context,nameCond,{[1 2],[3 4]},d);
        Context12{d} = get_eucD_shuffle_Context(dataContext,TA_Context,nameCond,{[1 2],[3 4]},1:d);
    end
else % 6 conditions, the TA_context is organized as [L1,R1,L2,R2,L3,R3]
    nameCond = {'Context 1';'Context 2';'Context 1';'Context 3'};
    sContext12 = cell(D,1); Context12 = cell(D,1);
    sContext13 = cell(D,1); Context13 = cell(D,1);
    for d = 1:D
        sContext12{d} = get_eucD_shuffle_Context(dataContext,TA_Context,nameCond(1:2),{[1 2],[3 4]},d);
        Context12{d} = get_eucD_shuffle_Context(dataContext,TA_Context,nameCond(1:2),{[1 2],[3 4]},1:d);
        sContext13{d} = get_eucD_shuffle_Context(dataContext,TA_Context,nameCond(3:4),{[1 2],[5 6]},d);
        Context13{d} = get_eucD_shuffle_Context(dataContext,TA_Context,nameCond(3:4),{[1 2],[5 6]},1:d);
    end
end

%% Save
if strcmp(prefix,'PA')
    fileName = regexprep(loadFileName,'.mat',['_' nameCuingType{CuingType} '_projEucD_PC.mat']);
else
    fileName = regexprep(loadFileName,'.mat','_projEucD_PC.mat');
end

if ~exist('EuclideanDistance','dir')
    mkdir('EuclideanDistance')
end
saveFileName = regexprep(fileName,'\Datasets\','\EuclideanDistance\');

if ~strcmp(prefix,'Prism+Anti')
    save(saveFileName,'sLR1','LR1','sLR2','LR2','sContext12','Context12','time');
else
    save(saveFileName,'sLR1','LR1','sLR2','LR2','sLR3','LR3','sContext12','Context12','sContext13','Context13','time');
end
