
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

f2 = figure(2);
set(gcf,'Position',[100,100,370,300]);
if strcmp(prefix,'Prism+Anti')
    cosCVAll = {cosCVcross13};
else
    cosCVAll = {cosCVcross12};
end

imagesc(cosCVAll{1},[-1 1]);
c = colorbar; c.FontSize = 20;
colormap(jet(256));
hold on;

plot(tCue*[1 1]+0.5,[0 length(t)+1],'color',[0.3 0.3 0.3],'LineWidth',1,'LineStyle',':');
plot([0 length(t)+1],tCue*[1 1]+0.5,'color',[0.3 0.3 0.3],'LineWidth',1,'LineStyle',':');
plot(40*[1 1]+0.5,[0 length(t)+1],'color',[0.3 0.3 0.3],'LineWidth',1,'LineStyle',':');
plot([0 length(t)+1],40*[1 1]+0.5,'color',[0.3 0.3 0.3],'LineWidth',1,'LineStyle',':');

x = [40.5, 60, 60, 40.5, 40.5];
y = [60, 60, 40.5, 40.5, 60];
plot(x, y, 'color',[1 1 1], 'LineStyle','-', 'LineWidth', 2);
x = [40.5, 60, 60, 40.5, 40.5] - 20;
y = [60, 60, 40.5, 40.5, 60] - 20;
plot(x, y, 'color',[1 1 1], 'LineStyle',':', 'LineWidth', 2);

hold off;
set(gca,'XTick',[]); set(gca,'YTick',[]);
set(gca,'XColor',[0.3 0.3 0.3]);
set(gca,'YColor',[0.3 0.3 0.3]);

set(gcf,'renderer','Painters');
