
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

alpha = 0.01; % 0.001
plotD = 3;

%%
if strcmp(prefix,'PA')
    loadFileName1 = regexprep(loadFileName, '\Datasets\', '\EuclideanDistance\');
    loadFileName1 = regexprep(loadFileName1, '.mat', ['_' nameCuingType{CuingType} '_projEucD_PC.mat']);
else
    loadFileName1 = regexprep(loadFileName, '\Datasets\', '\EuclideanDistance\');
    loadFileName1 = regexprep(loadFileName1, '.mat', '_projEucD_PC.mat');
end

if exist(loadFileName1,'file') == 2
    load(loadFileName1);
else
    error('Run save_projEucD_PCA.m first.');
end

%%
para1 = 'context'; para2 = sContext12;
% para1 = 'direction'; para2 = sLR1;
% para1 = 'direction'; para2 = sLR2;

if strcmp(prefix,'Prism+Anti')
    switch para1
        case 'context'
            para3 = sContext13;
        case 'direction'
            para3 = sLR3;
    end
end

%% Plot Euclidean distance
colCS1 = plotPara.condColor(condition(3),:);
colMap1 = [colCS1 ; colCS1*0.7 ; colCS1*0.2];
if strcmp(prefix,'Prism+Anti')
    colCS2 = plotPara.condColor(condition(5),:);
    colMap2 = [colCS2 ; colCS2*0.7 ; colCS2*0.2];
end

figure('position',[100,100,600,200]);
% subplot, top 3 PCs
subplot(1,2,1);
x = [20, 40, 40, 20];
y = [-0.2, -0.2, 2.8, 2.8];
fill(x, y, [0.85 0.85 0.85], 'EdgeColor', 'none');
hold on;
for d = 1:plotD
    plot_eucD( para2(d,1) , {colMap1(d,:)} , alpha ); hold on;
end
if strcmp(prefix,'Prism+Anti')
    for d = 1:plotD
        plot_eucD( para3(d,1) , {colMap2(d,:)} , alpha ); hold on;
    end
end
hold off;
set(gca,'XLim',[0 length(time)],'Xtick',[0:20:length(time)],'Xticklabel',[time(1)-10:200:time(end)],'Ylim',[-0.2 3.2],'Ytick',[0 3]);
xlabel('Time aligned to visual cue onset (ms)');
ylabel('Euclidean distance');
box off;
set(gca,'TickDir','out','TickLength',[0.015 0.015]);
set(gca,'XColor',[0.3 0.3 0.3]);
set(gca,'YColor',[0.3 0.3 0.3]);

% subplot, select the PC with the largest Euclidean distance
subplot(1,2,2);
x = [20, 40, 40, 20];
y = [-0.2, -0.2, 2.8, 2.8];
fill(x, y, [0.85 0.85 0.85], 'EdgeColor', 'none');
hold on;
dMax1 = get_dim_maxEucD(para2);
plot_eucD( para2(dMax1,1) , {colMap1(1,:)} , alpha );
text(40,3,['PC ' num2str(dMax1)]);
if strcmp(prefix,'Prism+Anti')
    hold on;
    dMax2 = get_dim_maxEucD(para3);
    plot_eucD( para3(dMax2,1) , {colMap2(1,:)} , alpha );
    text(40,2.5,['PC ' num2str(dMax2)]) ;
end
hold off;
set(gca,'XLim',[0 length(time)],'Xtick',[0:20:length(time)],'Xticklabel',[time(1)-10:200:time(end)],'Ylim',[-0.2 3.2],'Ytick',[0 3]);
xlabel('Time aligned to visual cue onset (ms)');
ylabel('Euclidean distance');
box off;
title('Fig.2 EucDistance');
set(gca,'TickDir','out','TickLength',[0.015 0.015]);
set(gca,'XColor',[0.3 0.3 0.3]);
set(gca,'YColor',[0.3 0.3 0.3]);

set(gcf,'renderer','Painters');

%% save figure
splLoadName = split(loadFileName,["\","."]);
if strcmp(prefix,'PA')
    saveFileName = ['Fig2_eucD_' splLoadName{end-1} '_' nameCuingType{CuingType}];
else
    saveFileName = ['Fig2_eucD_' splLoadName{end-1}];
end

saveas(gcf,saveFileName,'fig');
