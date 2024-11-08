
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

numVar = size(psthTA,1);
minNumSample = size(psthTA,2)*2;
[PC,projVAR,projvar,yProjOntoSub] =...
    get_projVar_subspace( psthTA , 'TO' , min(numVar,minNumSample) , 'whole' );

%% now plot
plotData.Y = yProjOntoSub.TO(1:plotD,:,:);
plotData.var = round(projvar.TO(1:plotD)*100,1);
plotData.thickLines = [];
plotData.condition = condition;
plotData.time = time(1):10:time(end);
plotData.axisName = {};

hAxis = plot_PCs(plotData,plotPara);
title('SupFig.2 PCs');

set(gcf,'renderer','Painters');

%% save figure
splLoadName = split(loadFileName,["\","."]);
if strcmp(prefix,'PA')
    saveFileName = ['Fig_PCs_' splLoadName{end-1} '_' nameCuingType{CuingType}];
else
    saveFileName = ['Fig_PCs_' splLoadName{end-1}];
end

saveas(gcf,saveFileName,'fig');
