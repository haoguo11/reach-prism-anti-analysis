
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

[N,T,C] = size(psthTA);

numVar = size(psthTA,1);
minNumSample = size(psthTA,2)*2;
[PC,projVAR,projvar,yProjOntoSub] =...
    get_projVar_subspace( psthTA , 'TO' , min(numVar,minNumSample) , 'whole' );

% For checking: PCtest should be equal to PC
[PCtest,~,~] = pca(psthTA(:,:)');
if ~isequal(PC,PCtest)
    error("The get_projVar_subspace gives different PCs.");
end

%% now plot
figure('position',[100,100,400,400]);
switch C
    case 4
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
    case 6
        b = bar([projvar.fi(1:plotD) projvar.se(1:plotD) projvar.th(1:plotD)]);
        b(1).FaceColor = plotPara.condColor(condition(1),:); b(1).EdgeColor = 'none';
        b(2).FaceColor = plotPara.condColor(condition(3),:); b(2).EdgeColor = 'none';
        b(3).FaceColor = plotPara.condColor(condition(5),:); b(3).EdgeColor = 'none';
        legendSubset = [b(1),b(2),b(3)];
        legendLabel = {'Normal Pro','Prism Pro','Normal Anti'};
end
hold on;
varTO = projvar.TO(1:plotD);
for iV = 1:plotD
    plot([iV-0.2 iV+0.2],[varTO(iV) varTO(iV)] , ...
        'LineWidth',1 , 'LineStyle',':' , 'Color', [0 0 0]);
end

box off;
set(gca,'TickDir','out','TickLength',[0.015 0.015]);
set(gca,'XTick',([1 plotD]));
ylim([0,0.6]); set(gca,'YTick',([0:0.2:0.6]));
xlabel('PCs');
ylabel('Fraction of variance explained');
legend(legendSubset,legendLabel);
title('Fig.2 PCs');
set(gca,'XColor',[0.3 0.3 0.3]);
set(gca,'YColor',[0.3 0.3 0.3]);
set(gcf,'renderer','Painters');

%% save figure
splLoadName = split(loadFileName,["\","."]);
if strcmp(prefix,'PA')
    saveFileName = ['Fig2_projVar_' splLoadName{end-1} '_' nameCuingType{CuingType}];
else
    saveFileName = ['Fig2_projVar_' splLoadName{end-1}];
end

saveas(gcf,saveFileName,'fig');

