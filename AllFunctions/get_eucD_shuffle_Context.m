function [eucDStruc] = get_eucD_shuffle_Context(Data,shuffleData,nameCond,cc,d)

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

numShuffle = size(shuffleData,2);
if ~isequal(size(Data),size(shuffleData{1}))
    error('The sizes of Data and shuffleData do not match.');
end

avgData = calculate_mean_acrossCond(Data , cc);
if ~isequal(size(avgData,3),length(nameCond))
    error('The number of conditions does not match.');
end

[PC,~,~] = pca(Data(:,:)');
eucDStruc = calculate_eucD( avgData , nameCond , PC(:,d) );

for iShuffle = 1:numShuffle
    SData = shuffleData{iShuffle};
    avgSData = calculate_mean_acrossCond(SData , cc);
    [SPC,~,~] = pca(SData(:,:)');
    eucDShuffleStruc = calculate_eucD( avgSData , nameCond , SPC(:,d) );
    eucDShuffle(:,iShuffle) = eucDShuffleStruc.eucD;
end
eucDStruc.shuffle = eucDShuffle;

end

