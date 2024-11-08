
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

if length(monkey)==2 || strcmp(prefix,'Prism+Anti')
else
    error('Must include data from two monkeys or use Prism+Anti.');
end

plotD = 6;
ci = [2.5 97.5];

%% Read RandomData
for iM = 1:size(monkey,1)
    
    %%%% checking file name and load data %%%%
    loadFileName = [pwd '\RandomData\' prefix '_' monkey{iM} '_' alignedEvent{1} '_' area '_' kernel 'psth' postfix];
    if strcmp(prefix,'PA')
        loadFileName = regexprep(loadFileName, '.mat', ['_' nameCuingType{CuingType} '_randVar.mat']);
    else
        loadFileName = regexprep(loadFileName, '.mat', '_randVar.mat');
    end
    
    if exist(loadFileName,'file') == 2
        load(loadFileName);
        RPV{iM} = randProjVar;
    else
        error('Run save_random_subspace_and_projVar.m first.');
    end
    
    %%%% calculate alignment index %%%%
    [~,VARxon2,~,~] = get_projVar_subspace(psthTA,'se',plotD,'subset');
    projVAR1on2{iM} = VARxon2.('fi');
    [~,VARxon1,~,~] = get_projVar_subspace(psthTA,'fi',plotD,'subset');
    projVAR2on1{iM} = VARxon1.('se');
    
    if strcmp(prefix,'Prism+Anti')
        [~,VARxon3,~,~] = get_projVar_subspace(psthTA,'th',plotD,'subset');
        projVAR1on3{iM} = VARxon3.('fi');
        projVAR3on1{iM} = VARxon1.('th');
    end
    
    %%%% calculate p values %%%%
    numRandoms = size(RPV{iM}{1},2);
    for iD = 1:plotD
        switch prefix
            case 'DovePrism'
                pValue1on2{iM}(iD,1) = (sum(RPV{iM}{1}(iD,:) <= projVAR1on2{iM}(iD)) + 1) / (numRandoms + 1);
                pValue2on1{iM}(iD,1) = (sum(RPV{iM}{1}(iD,:) <= projVAR2on1{iM}(iD)) + 1) / (numRandoms + 1);
            case'PA'
                pValue1on2{iM}(iD,1) = (sum(RPV{iM}{1}(iD,:) >= projVAR1on2{iM}(iD)) + 1) / (numRandoms + 1);
                pValue2on1{iM}(iD,1) = (sum(RPV{iM}{1}(iD,:) >= projVAR2on1{iM}(iD)) + 1) / (numRandoms + 1);
            case 'Prism+Anti'
                pValue1on2{iM}(iD,1) = (sum(RPV{iM}{1}(iD,:) <= projVAR1on2{iM}(iD)) + 1) / (numRandoms + 1);
                pValue2on1{iM}(iD,1) = (sum(RPV{iM}{1}(iD,:) <= projVAR2on1{iM}(iD)) + 1) / (numRandoms + 1);
                pValue1on3{iM}(iD,1) = (sum(RPV{iM}{2}(iD,:) >= projVAR1on3{iM}(iD)) + 1) / (numRandoms + 1);
                pValue3on1{iM}(iD,1) = (sum(RPV{iM}{2}(iD,:) >= projVAR3on1{iM}(iD)) + 1) / (numRandoms + 1);
        end
    end
end

% confidence interval
if strcmp(prefix,'Prism+Anti')
    bootSample1 = RPV{1}{1}(plotD,:);
    bootSample2 = RPV{1}{2}(plotD,:);
    bootMean1 =  mean(bootSample1);
    bootMean2 =  mean(bootSample2);
    CI1 = prctile(bootSample1, ci);
    CI2 = prctile(bootSample2, ci);
    projVAR = [projVAR1on2{1}(plotD) projVAR2on1{1}(plotD) ...
        bootMean1 nan ...
        projVAR1on3{1}(plotD) projVAR3on1{1}(plotD)...
        bootMean2];
    high1 = CI1(2) - bootMean1;
    high2 = CI2(2) - bootMean2;
    low1 = bootMean1 - CI1(1);
    low2 = bootMean2 - CI2(1);
else
    bootSample1 = RPV{1}{1}(plotD,:);
    bootSample2 = RPV{2}{1}(plotD,:);
    bootMean1 =  mean(bootSample1);
    bootMean2 =  mean(bootSample2);
    CI1 = prctile(bootSample1, ci);
    CI2 = prctile(bootSample2, ci);
    projVAR = [projVAR1on2{1}(plotD) projVAR2on1{1}(plotD) ...
        bootMean1 nan ...
        projVAR1on2{2}(plotD) projVAR2on1{2}(plotD) ...
        bootMean2];
    high1 = CI1(2) - bootMean1;
    high2 = CI2(2) - bootMean2;
    low1 = bootMean1 - CI1(1);
    low2 = bootMean2 - CI2(1);
end

errhigh = [nan nan high1 nan nan nan high2];
errlow  = [nan nan low1 nan nan nan low2];

%% now plot
% Plot error bars
figure('position',[100 100 200 300]);
b = bar(1:7,projVAR);
b(1).FaceColor = [0.5 0.5 0.5]; hold on;
er = errorbar(1:7,projVAR,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
set(gca,'XTick',[],'YLim',[0 0.8],'YTick',0:0.2:0.8);
ylabel('Alignment index');
box off;
title('Fig.3 Alignment index');
set(gca,'TickDir','out','TickLength',[0.015 0.015]);
set(gca,'XColor',[0.3 0.3 0.3]);
set(gca,'YColor',[0.3 0.3 0.3]);
set(gcf,'renderer','Painters');

%% save figure
splLoadName = split(loadFileName,["\","."]);
if strcmp(prefix,'PA')
    saveFileName = ['Fig3_alignIdx_' splLoadName{end-1} '_' nameCuingType{CuingType}];
else
    saveFileName = ['Fig3_alignIdx_' splLoadName{end-1}];
end

saveas(gcf,saveFileName,'fig');
