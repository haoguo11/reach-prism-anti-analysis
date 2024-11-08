function [eucDStruc] = get_eucD_shuffle_LR(Data,shuffleData,nameCond,cc,d)

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
if ~isequal(size(Data,3),length(nameCond))
    error('The number of conditions does not match.');
end

[PC,~,~] = pca(Data(:,:)');
eucDStruc = calculate_eucD( Data(:,:,cc) , nameCond(cc) , PC(:,d) );

for iShuffle = 1:numShuffle
    sData = shuffleData{iShuffle};
    [sPC,~,~] = pca(sData(:,:)');
    eucDShuffleStruc = calculate_eucD( sData(:,:,cc) , nameCond(cc) , sPC(:,d) );
    eucDShuffle(:,iShuffle) = eucDShuffleStruc.eucD;
end
eucDStruc.shuffle = eucDShuffle;

end

