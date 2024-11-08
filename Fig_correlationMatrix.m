
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

m1 = squeeze(psthTA(:,:,[1 2]));
m2 = squeeze(psthTA(:,:,[3 4]));

if strcmp(prefix,'Prism+Anti')
    m3 = squeeze(psthTA(:,:,[5 6]));
end

thre = 0.8;

corrM1 = corrcoef(m1(:,:)');
corrM2 = corrcoef(m2(:,:)');

%% hierarchical clustering
distM1 = 1-corrM1;
tree1 = linkage(squareform(distM1), 'complete');
T1 = cluster(tree1,'Cutoff',thre,'Criterion','distance');

[~,I1] = sort(T1,'ascend');

if length(unique(I1)) ~= length(I1)
    error('The index used for clustering is incorrect.')
end

%% now plot the clustered correlation heatmap
m1 = m1(I1,:,:);
m2 = m2(I1,:,:);
if strcmp(prefix,'Prism+Anti')
    m3 = m3(I1,:,:);
end

figure('Position',[100,100,1600,350]);
subplot(1,3,1);
imagesc(corrcoef(m1(:,:)'),[-1 1]);
c = colorbar; c.FontSize = 20;
colormap(jet(256));
set(gca,'XTick',[]); set(gca,'YTick',[]);
set(gca,'XColor',[0.3 0.3 0.3]);
set(gca,'YColor',[0.3 0.3 0.3]);

subplot(1,3,2);
imagesc(corrcoef(m2(:,:)'),[-1 1]);
c = colorbar; c.FontSize = 20;
colormap(jet(256));
set(gca,'XTick',[]); set(gca,'YTick',[]);
set(gca,'XColor',[0.3 0.3 0.3]);
set(gca,'YColor',[0.3 0.3 0.3]);

if strcmp(prefix,'Prism+Anti')
    subplot(1,3,3);
    imagesc(corrcoef(m3(:,:)'),[-1 1]);
    c = colorbar; c.FontSize = 20;
    colormap(jet(256));
    set(gca,'XTick',[]); set(gca,'YTick',[]);
    set(gca,'XColor',[0.3 0.3 0.3]);
    set(gca,'YColor',[0.3 0.3 0.3]);
end

title('SupFig.7 correlation matrix');

set(gcf,'renderer','Painters');

%% save figure
splLoadName = split(loadFileName,["\","."]);
if strcmp(prefix,'PA')
    saveFileName = ['Fig_corrMatrix_' splLoadName{end-1} '_' nameCuingType{CuingType}];
else
    saveFileName = ['Fig_corrMatrix_' splLoadName{end-1}];
end

saveas(gcf,saveFileName,'fig');
