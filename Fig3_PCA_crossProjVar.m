
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

plotD = 6;

%%
% 1 on 1
data1 = psthTA(:,:,[1 2]); [pc1,~,eigV1] = pca(data1(:,:)');
[var1,~] = calculate_proj_variance( pc1 , data1 , 'whole');

% 2 on 2
data2 = psthTA(:,:,[3 4]); [pc2,~,eigV2] = pca(data2(:,:)');
[var2,~] = calculate_proj_variance( pc2 , data2 , 'whole');

% 1 on 2
[projVAR1on2,~] = calculate_proj_variance( pc2(:,1:plotD) , data1 , 'whole');

if strcmp(prefix,'Prism+Anti')
    % 3 on 3
    data3 = psthTA(:,:,[5 6]); [pc3,~,eigV3] = pca(data3(:,:)');
    [var3,~] = calculate_proj_variance( pc3 , data3 , 'whole');

    % 1 on 3
    [projVAR1on3,~] = calculate_proj_variance( pc3(:,1:plotD) , data1 , 'whole');
end

%% now plot
figure('position',[100,100,200,300]);

f1 = plot(var1(1:plotD,1),'Color',plotPara.condColor(condition(1),:),'LineWidth',1);hold on;
f2 = plot(var2(1:plotD,1),'Color',plotPara.condColor(condition(3),:),'LineWidth',1);
f3 = plot(projVAR1on2(1:plotD,1),'Color',[0 0 0],'LineWidth',1.2);
if strcmp(prefix,'Prism+Anti')
    f4 = plot(var3(1:plotD,1),'Color',plotPara.condColor(condition(5),:),'LineWidth',1);
    f5 = plot(projVAR1on3(1:plotD,1),'Color',[0 0 0],'LineWidth',1.2);
end

s1 = scatter(1:plotD,var1(1:plotD,1),'o','LineWidth',1,...
    'MarkerEdgeColor',plotPara.condColor(condition(1),:));
s2 = scatter(1:plotD,var2(1:plotD,1),'o','LineWidth',1,...
    'MarkerEdgeColor',plotPara.condColor(condition(3),:));
s3 = scatter(1:plotD,projVAR1on2(1:plotD,1),'o','LineWidth',1.2,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',plotPara.condColor(condition(3),:));
set(s1,'SizeData',50);
set(s2,'SizeData',50);
set(s3,'SizeData',65);

if strcmp(prefix,'Prism+Anti')
    s4 = scatter(1:plotD,var3(1:plotD,1),'o','LineWidth',1,...
        'MarkerEdgeColor',plotPara.condColor(condition(5),:));
    s5 = scatter(1:plotD,projVAR1on3(1:plotD,1),'o','LineWidth',1.2,...
        'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',plotPara.condColor(condition(5),:));
    set(s4,'SizeData',50);
    set(s5,'SizeData',65);
end
hold off;

switch prefix
    case 'PA'
        legendSubset = [f1, f2, s3];
        legendLabel = {'Pro on Pro',...
            'Anti on Anti',...
            'Pro on Anti'};
    case 'DovePrism'
        legendSubset = [f1, f2, s3];
        legendLabel = {'Normal on Normal',...
            'Prism on Prism',...
            'Normal on Prism'};
    case 'Prism+Anti'
        legendSubset = [f1, f2, s3, f4, s5];
        legendLabel = {'Normal Pro on Normal Pro',...
            'Prism Pro on Prism Pro',...
            'Normal Pro on Prism Pro',...
            'Normal Anti on Normal Anti',...
            'Normal Pro on Normal Anti'};
end

box off;
set(gca,'TickDir','out','TickLength',[0.015 0.015]);
xlim([0.5,plotD+0.5]);set(gca,'XTick',([1 plotD]));
ylim([0,0.8]); set(gca,'YTick',([0:0.4:0.8]));
xlabel('Cumulative PCs');
ylabel('Fraction of variance explained');
legend(legendSubset,legendLabel);
title('Fig.3 cross-projections');
set(gca,'XColor',[0.3 0.3 0.3]);
set(gca,'YColor',[0.3 0.3 0.3]);
set(gcf,'renderer','Painters');

%% save figure
splLoadName = split(loadFileName,["\","."]);
if strcmp(prefix,'PA')
    saveFileName = ['Fig3_crossProjVar_' splLoadName{end-1} '_' nameCuingType{CuingType}];
else
    saveFileName = ['Fig3_crossProjVar_' splLoadName{end-1}];
end

saveas(gcf,saveFileName,'fig');
