
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
numRandoms = 100; % numRandoms = 10,000 in Results

%% use random subspace selection method
numCond = size(psthTA,3);
if numCond~=4 && numCond~=6
    error('The number of conditions in psthTA should be 4 or 6.');
end

data1 = psthTA; 
C1 = cov(data1(:,:)');
[U1,S1,~] = svd(C1);
% [U1,S1] = eig(C1);

randProjVar{1} = nan(D,numRandoms);
randU1 = cell(D,numRandoms);
randU2 = cell(D,numRandoms);

if strcmp(prefix,'Prism+Anti')
    randProjVar{2} = nan(D,numRandoms);
    randU3 = cell(D,numRandoms);
end

% now generate random subspace and calculate the variance
for iRand = 1:numRandoms
    for d = 1:D
        
        % generate random subspace
        uRand1 = generate_random_subspace(C1,U1,S1,d);
        uRand2 = generate_random_subspace(C1,U1,S1,d);
        if strcmp(prefix,'Prism+Anti')
            uRand3 = generate_random_subspace(C1,U1,S1,d);
        end
        
        % calculate the alignment index
        randProjVar{1}(d,iRand) = trace((uRand1'*uRand2)*uRand2'*uRand1)/d;
        randU1{d,iRand} = uRand1;
        randU2{d,iRand} = uRand2;
        if strcmp(prefix,'Prism+Anti')
            randProjVar{2}(d,iRand) = trace((uRand1'*uRand3)*uRand3'*uRand1)/d;
            randU3{d,iRand} = uRand3;
        end
        
    end 
end

%% save
if strcmp(prefix,'PA')
    fileName1 = regexprep(loadFileName,'.mat',['_' nameCuingType{CuingType} '_randData.mat']);
    fileName2 = regexprep(loadFileName,'.mat',['_' nameCuingType{CuingType} '_randVar.mat']);
else
    fileName1 = regexprep(loadFileName,'.mat','_randData.mat');
    fileName2 = regexprep(loadFileName,'.mat','_randVar.mat');
end

% redirect to folder in which the .mat files are saved
if ~exist('RandomData','dir')
    mkdir('RandomData')
end
saveFileName1 = regexprep(fileName1,'\Datasets\','\RandomData\');
saveFileName2 = regexprep(fileName2,'\Datasets\','\RandomData\');

% save random subspaces and psthTA and psthTT
save(saveFileName1,'randU1','randU2','psthTA','psthTT','time');
if strcmp(prefix,'Prism+Anti')
    save(saveFileName1,'randU3','-append');
end

% save projVar in a separated file
save(saveFileName2,'randProjVar','psthTA','psthTT','time');

