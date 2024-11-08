function [ outputTA , outputTT ] = preprocess_data( inputTT , method , snConstant )

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

% inputTT: 2D cell of size #Units-by-#Conditions, in each cell, 2D matrix of #Trials-by-#TimePoints
% method:'1': only soft-normalization. '2': soft-normalization + mean-centered
% snConstant: soft-normalization constant, spikes/s
% outputTA: (trial-averaged) 3D matrix of #Units-by-#TimePoints-by-#Conditions
% outputTT: same size as psthTT

nUnits = size(inputTT,1);
nTPs = size(inputTT{1},2); % time points
nConds = size(inputTT,2);  % conditions

% trial-averaging
inputTA = nan(nUnits,nTPs,nConds);
for iCond = 1:nConds
    inputTA(:,:,iCond) = cell2mat(cellfun(@(c) mean(c), inputTT(:,iCond), 'UniformOutput', false));
end

%%%%
% Neural responses for each neuron are soft-normalized
minEachNeuron = min(inputTA(:,:)')';
maxEachNeuron = max(inputTA(:,:)')';
normalizeFactor = (maxEachNeuron - minEachNeuron) + snConstant;
normalizedTA = inputTA./repmat(normalizeFactor , [1 nTPs nConds]);

for iUnit = 1:nUnits
    normalizedTT(iUnit,:) = cellfun(@(c) c./repmat(normalizeFactor(iUnit),size(c)), inputTT(iUnit,:),'UniformOutput', false);
end


%%%% 2-steps preprocessing of data
if strcmp(method,'2')
    centerFactor = mean(normalizedTA,3);
    outputTA = normalizedTA - repmat(centerFactor,1,1,nConds);

    for iUnit = 1:nUnits
        outputTT(iUnit,:) = cellfun(@(c) c-repmat(centerFactor(iUnit,:),[size(c,1),1]), normalizedTT(iUnit,:),'UniformOutput', false);
    end

else % 1-step preprocessing of data
    outputTA = normalizedTA;
    outputTT = normalizedTT;
end

end

