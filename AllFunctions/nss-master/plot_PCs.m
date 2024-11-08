function hAxis = plot_PCs(plotData,plotPara)

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

Y = plotData.Y;
var = plotData.var;
thickLines = plotData.thickLines;
condition = plotData.condition;
time = plotData.time;
axisName = plotData.axisName;

condColor = plotPara.condColor;
condLinestyle = plotPara.condLinestyle;
condLegend = plotPara.condLegend;

[D,T,C] = size(Y);
if D <= 12
    if D <= 6
        m = 2; n = 3;
    else
        m = 3; n = 4;
    end
else
    error('The number of dimensions should be less than or equal to 12.');
end

minValue = floor(min(min(min(Y)))*10-2)/10;
maxValue = ceil(max(max(max(Y)))*10+2)/10;
maxAbs = max(abs([minValue maxValue]));

figure; clf;
p = get(gcf,'Position');
set(gcf,'Position',[p(1),p(2)+p(4)-580,1220,580]);

for d = 1:D
    y = squeeze(Y(d,:,:));
    
    subplot(m,n,d);
    for iC = 1:C
        plot(1:T,y(1:T,iC),...
            'Color',condColor(condition(iC),:),...
            'LineStyle',condLinestyle{condition(iC)},...
            'LineWidth',0.6); hold on;
        
        if ~isempty(thickLines)
            plot(thickLines,y(thickLines,iC),...
                'Color',condColor(condition(iC),:),...
                'LineStyle',condLinestyle{condition(iC)},...
                'LineWidth',1.6); hold on;
        end
    end

    set(gca,'XLim',[0 length(time)],...
        'Xtick',0:20:length(time),...
        'Xticklabel',time(1)-10:200:time(end),...
        'Ylim',[-maxAbs maxAbs],...
        'Ytick',linspace(ceil(-maxAbs/0.5)*0.5, floor(maxAbs/0.5)*0.5, 3));
    
    xlabel('Time aligned to visual cue onset (ms)');
    if ~isempty(axisName)
        ylabel(axisName{d});
    else
        ylabel(['PC' num2str(d)]);
    end
    
    box off;
    set(gca,'TickDir','out','TickLength',[0.015 0.015]);
    set(gca,'XColor',[0.3 0.3 0.3]);
    set(gca,'YColor',[0.3 0.3 0.3]);
    
    if ~isempty(var)
        text(2,maxAbs/2,[num2str(var(d)) '%']);
    end
    
    hAxis(d) = gca;
    
end

end