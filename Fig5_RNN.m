
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

whichData = 1;

%%
psthTA = psthTA_all{whichData};

%% same as Fig2_PCA_projVar_Bars
numVar = size(psthTA,1);
minNumSample = size(psthTA,2)*2;
[PC,projVAR,projvar,yProjOntoSub] =...
    get_projVar_subspace( psthTA , 'TO' , min(numVar,minNumSample) , 'whole' );

% now plot
figure('position',[100,100,400,400]);
b = bar([projvar.fi(1:plotD) projvar.se(1:plotD)]);
b(1).FaceColor = plotPara.condColor(condition(1),:); b(1).EdgeColor = 'none';
b(2).FaceColor = plotPara.condColor(condition(3),:); b(2).EdgeColor = 'none';
legendSubset = [b(1),b(2)];
switch prefix
    case 'DovePrism'
        legendLabel = {'Normal','Prism'};
    case 'PA'
        legendLabel = {'Pro','Anti'};
end
box off;
set(gca,'TickDir','out','TickLength',[0.015 0.015]);
set(gca,'XTick',([1 plotD]));
ylim([0,1]); set(gca,'YTick',([0:0.2:1]));
xlabel('PCs');
ylabel('Fraction of variance explained');
set(gca,'XColor',[0.3 0.3 0.3]);
set(gca,'YColor',[0.3 0.3 0.3]);
legend(legendSubset,legendLabel);
title('Fig.5 PCs (example RNN)');
set(gcf,'renderer','Painters');

% save figure
saveFileName = [scriptname '_' prefix '_projVar'];
saveas(gcf,saveFileName,'fig');

%% same as Fig3_PCA_crossProjVar
% 1 on 1
data1 = psthTA(:,:,[1 2]); [pc1,~,eigV1] = pca(data1(:,:)');
[var1,~] = calculate_proj_variance( pc1 , data1 , 'whole');
% 2 on 2
data2 = psthTA(:,:,[3 4]); [pc2,~,eigV2] = pca(data2(:,:)');
[var2,~] = calculate_proj_variance( pc2 , data2 , 'whole');
% 1 on 2
[projVAR1on2,~] = calculate_proj_variance( pc2(:,1:plotD) , data1 , 'whole');

% now plot
figure('position',[100,100,200,300]);

f1 = plot(var1(1:plotD,1),'Color',plotPara.condColor(condition(1),:),'LineWidth',1);hold on;
f2 = plot(var2(1:plotD,1),'Color',plotPara.condColor(condition(3),:),'LineWidth',1);
f3 = plot(projVAR1on2(1:plotD,1),'Color',[0 0 0],'LineWidth',1.2);

s1 = scatter(1:plotD,var1(1:plotD,1),'o','LineWidth',1,...
    'MarkerEdgeColor',plotPara.condColor(condition(1),:));
s2 = scatter(1:plotD,var2(1:plotD,1),'o','LineWidth',1,...
    'MarkerEdgeColor',plotPara.condColor(condition(3),:));
s3 = scatter(1:plotD,projVAR1on2(1:plotD,1),'o','LineWidth',1.2,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',plotPara.condColor(condition(3),:));
set(s1,'SizeData',50);
set(s2,'SizeData',50);
set(s3,'SizeData',65);

legendSubset = [f1,f2,s3];
switch prefix
    case 'DovePrism'
        legendLabel = {'Normal on Normal','Prism on Prism','Normal on Prism'};
    case 'PA'
        legendLabel = {'Pro on Pro','Anti on Anti','Pro on Anti'};
end

hold off;
box off;
set(gca,'TickDir','out','TickLength',[0.015 0.015]);
xlim([0.5,plotD+0.5]);set(gca,'XTick',([1 plotD]));
ylim([0,1]); set(gca,'YTick',([0:0.5:1]));
xlabel('Cumulative PCs');
ylabel('Fraction of variance explained');
set(gca,'XColor',[0.3 0.3 0.3]);
set(gca,'YColor',[0.3 0.3 0.3]);
legend(legendSubset,legendLabel);
title('Fig.5 crossProj (example RNN)');
set(gcf,'renderer','Painters');

% save figure
saveFileName = [scriptname '_' prefix  '_crossProjVar'];
saveas(gcf,saveFileName,'fig');
