
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

[N,T,C] = size(psthTA);

tReMap = 21:40;
phaseX = [41 60];
phaseY = [60 41];

numRep = 100; % for cross-validation

if strcmp(prefix,'Prism+Anti')
    c = [1 2 5 6];
else
    c = [1 2 3 4];
end

saveFig = true;
saveCosSim = true;

%%
dataReMap = psthTA(:,tReMap,:);

vContext1 = dataReMap(:,:,c(1))-dataReMap(:,:,c(2));
vContext2 = dataReMap(:,:,c(3))-dataReMap(:,:,c(4));
csContext1 = squareform(1-pdist(vContext1,'cosine')) + eye(size(vContext1,1));
csContext2 = squareform(1-pdist(vContext2,'cosine')) + eye(size(vContext2,1));

vLeft = dataReMap(:,:,c(1))-dataReMap(:,:,c(3));
vRight = dataReMap(:,:,c(2))-dataReMap(:,:,c(4));
csLeft = squareform(1-pdist(vLeft,'cosine')) + eye(size(vLeft,1));
csRight = squareform(1-pdist(vRight,'cosine')) + eye(size(vRight,1));

[vPC,eigValue] = eig(csContext1+csContext2-csLeft-csRight,'vector');
vPC = fliplr(vPC);
projPC = vPC(:,1:6);
% projPC = vPC(:,[1:3 end end-1 end-2]);

y = projPC'*psthTA(:,:);
yLowD = reshape(y,[size(y,1) T C]);

%% now plot PCs
plotData.Y = yLowD;
plotData.var = [];
plotData.thickLines = tReMap;
plotData.condition = condition;
plotData.time = time(1):10:time(end);
plotData.axisName = {'vPC1','vPC2','vPC3','vPC4','vPC5','vPC6'};
plot_PCs(plotData,plotPara);
title('Fig.4 PCs');
set(gcf,'renderer','Painters');
f1 = gcf;

%% cross-validated cosine similarity
iRep = 1;
while iRep < numRep + 1
    % psthTTPart1 and psthTTPart2 have the same size as psthTT, but only with half of the total trials
    [psthTTPart1,psthTTPart2] = cellfun(@(c) partition_psthTT(c,0), psthTT , 'UniformOutput', false);
    
    psthTA1 = tt2ta(psthTTPart1);
    y1 = projPC'*psthTA1(:,:);
    yLowD1 = reshape(y1,[size(y1,1) T C]);
    vectorC1P1 = yLowD1(:,:,1)-yLowD1(:,:,2); % context 1, part 1
    vectorC2P1 = yLowD1(:,:,3)-yLowD1(:,:,4); % context 2, part 1
    
    psthTA2 = tt2ta(psthTTPart2);
    y2 = projPC'*psthTA2(:,:);
    yLowD2 = reshape(y2,[size(y2,1) T C]);
    vectorC1P2 = yLowD2(:,:,1)-yLowD2(:,:,2); % context 1, part 2
    vectorC2P2 = yLowD2(:,:,3)-yLowD2(:,:,4); % context 2, part 2
    
    if strcmp(prefix,'Prism+Anti')
        vectorC3P1 = yLowD1(:,:,5)-yLowD1(:,:,6); % context 3, part 1
        vectorC3P2 = yLowD2(:,:,5)-yLowD2(:,:,6); % context 3, part 2
    end
    
    tWindow = 1;
    t = 1 : tWindow : T-tWindow+1;
    cosSimC1a = nan(length(t),length(t));  cosSimC1b = nan(length(t),length(t));
    cosSimC2a = nan(length(t),length(t));  cosSimC2b = nan(length(t),length(t));
    cosSimC12a = nan(length(t),length(t)); cosSimC12b = nan(length(t),length(t));
    if strcmp(prefix,'Prism+Anti')
        cosSimC13a = nan(length(t),length(t)); cosSimC13b = nan(length(t),length(t));
    end
    
    for t1 = 1:length(t)
        for t2 = 1:length(t)
            
            i = t(t1):t(t1)+tWindow-1;
            j = t(t2):t(t2)+tWindow-1;
            
            vC1P1i = mean(vectorC1P1(:,i),2); % average across time if tWindow ~= 1
            vC1P2j = mean(vectorC1P2(:,j),2);
            cosSimC1a(t1,t2) = dot(vC1P1i,vC1P2j)/(norm(vC1P1i)*norm(vC1P2j));
            cosSimC1b(t2,t1) = dot(vC1P2j,vC1P1i)/(norm(vC1P2j)*norm(vC1P1i));
            
            vC2P1i = mean(vectorC2P1(:,i),2); % average across time if tWindow ~= 1
            vC2P2j = mean(vectorC2P2(:,j),2);
            cosSimC2a(t1,t2) = dot(vC2P1i,vC2P2j)/(norm(vC2P1i)*norm(vC2P2j));
            cosSimC2b(t2,t1) = dot(vC2P2j,vC2P1i)/(norm(vC2P2j)*norm(vC2P1i));
            
            % here is 'ij',therefore the idx is (t1,t2)
            cosSimC12a(t1,t2) = dot(vC1P1i,vC2P2j)/(norm(vC1P1i)*norm(vC2P2j));
            % note here is 'ji', not 'ij', therefore the idx should be (t2,t1)
            cosSimC12b(t2,t1) = dot(vC1P2j,vC2P1i)/(norm(vC1P2j)*norm(vC2P1i));
            
            if strcmp(prefix,'Prism+Anti')
                vC3P1i = mean(vectorC3P1(:,i),2);
                vC3P2j = mean(vectorC3P2(:,j),2);
                cosSimC13a(t1,t2) = dot(vC1P1i,vC3P2j)/(norm(vC1P1i)*norm(vC3P2j));
                cosSimC13b(t2,t1) = dot(vC1P2j,vC3P1i)/(norm(vC1P2j)*norm(vC3P1i));
            end
        end
    end
    
    cos1(:,:,iRep) = (cosSimC1a + cosSimC1b)/2;
    cos2(:,:,iRep) = (cosSimC2a + cosSimC2b)/2;
    cos3(:,:,iRep) = (cosSimC12a + cosSimC12b)/2;
    if strcmp(prefix,'Prism+Anti')
        cos4(:,:,iRep) = (cosSimC13a + cosSimC13b)/2;
    end
    
    iRep = iRep+1;
    
end

cosCVin1 = mean(cos1,3);
cosCVin2 = mean(cos2,3);
cosCVcross12 = mean(cos3,3);
if strcmp(prefix,'Prism+Anti')
    cosCVcross13 = mean(cos4,3);
end

tIdx = t-find(abs(round(time))==0);
tCue = find(tIdx == min(abs(tIdx)));

% now plot f2
run('plot_cosSim_heatmap');
title('Fig.4 cosine similarity');

%% save figures
if saveFig
    splLoadName = split(loadFileName,["\","."]);
    if strcmp(prefix,'PA')
        saveFileName1 = ['Fig4_vPCA_NeuralTraj_' splLoadName{end-1} '_' nameCuingType{CuingType}];
        saveFileName2 = ['Fig4_vPCA_heatmaps_' splLoadName{end-1} '_' nameCuingType{CuingType}];
    else
        saveFileName1 = ['Fig4_vPCA_NeuralTraj_' splLoadName{end-1}];
        saveFileName2 = ['Fig4_vPCA_heatmaps_' splLoadName{end-1}];
    end
    
    saveas(f1,saveFileName1,'fig');
    saveas(f2,saveFileName2,'fig');
end

%% save cosine similarity
if saveCosSim
    if strcmp(prefix,'PA')
        fileName = regexprep(loadFileName,'.mat',['_' nameCuingType{CuingType} '_cosSim.mat']);
    else
        fileName = regexprep(loadFileName,'.mat','_cosSim.mat');
    end

    if ~exist('cosSim','dir')
        mkdir('cosSim')
    end
    saveFileName = regexprep(fileName,'\Datasets\','\cosSim\');

    if strcmp(prefix,'Prism+Anti')
        save(saveFileName,'cos1','cos2','cos3','cos4','time');
    else
        save(saveFileName,'cos1','cos2','cos3','time');
    end
end
