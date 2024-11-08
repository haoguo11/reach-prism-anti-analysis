function [ loadFileName, numTLoad, psthTALoad, psthTTLoad , timeLoad] =...
    load_data(loadFileNameCell,monkey,prefix,CuingType,tPhase,condition,normalize)

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loading PA (pro vs. anti) data:
% numT: number of trials (loaded data: unit-directions-mapping-cuing).
% psthTA is trial-averaged data (loaded data: 5D matrix of
%       unit-time-directions-mapping-cuing)
% psthTT is trial-by-trial data (loaded data: 4D cell of size
%       unit-directions-mapping-cuing, in each cell, 2D matrix of
%       trial-time)
% time: 161 bins in total, bin size 10ms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loading Prism (normal vs. prism) data:
% numT: 2D matrix of unit-conditions.
% psthTA: 3D matrix of unit-time-conditions
% psthTT: 2D cell of unit-conditions, in each cell, 2D matrix of trial-time
% time: 161 bins in total, bin size 10ms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% monkey: name of monkey
% tPhase: analysis window
% condition: index of conditions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load data
switch size(monkey,1)
    case 1
        loadFileName = loadFileNameCell{1};
        load(loadFileName);

    case 2 % in this case, group two monkeys' data
        load (loadFileNameCell{1}); % load monkey #1
        numT1 = numT; psthTA1 = psthTA; psthTT1 = psthTT;
        time1 = time;

        numT = []; psthTA = []; psthTT = []; time = [];

        load (loadFileNameCell{2}); % load monkey #2
        numT2 = numT; psthTA2 = psthTA; psthTT2 = psthTT;
        time2 = time;

        if ~isequal(round(time1),round(time2))
            error('The two time phases should be the same.');
        end

        loadFileName = regexprep(loadFileNameCell{1}, monkey{1}, '2Monkeys');
        numT = cat(1,numT1,numT2);
        psthTA = cat(1,psthTA1,psthTA2);
        psthTT = cat(1,psthTT1,psthTT2);
end

% select one CuingType if PA datasets
if strcmp(prefix,'PA')
    numT = numT(:,:,:,CuingType);
    psthTT = psthTT(:,:,:,CuingType);
    psthTA = psthTA(:,:,:,:,CuingType);
end
numTLoad = numT(:,:);
psthTT = psthTT(:,:);
psthTA = psthTA(:,:,:);

psthTTCut = cellfun(@(c) c(:,tPhase), psthTT(:,condition), 'UniformOutput', false);
psthTACut = psthTA(:,tPhase,condition);
timeLoad = time(tPhase);

for iCond = 1:size(psthTTCut,2)
    if sum(sum( psthTACut(:,:,iCond) - cell2mat(cellfun(@(c) mean(c), psthTTCut(:,iCond),'UniformOutput', false)) )) > 0.0000000001
        error('psthTT and psthTA do not match.');
    end
end

if normalize
    [psthTALoad , psthTTLoad] = preprocess_data(psthTTCut , '2' , 5); % two-steps normalization
else
    psthTALoad = psthTACut;
    psthTTLoad = psthTTCut;
end

end

