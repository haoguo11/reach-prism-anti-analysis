function [ part1 , part2 ] = partition_psthTT( psthTT , overlap )

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

numTrial = size(psthTT,1);
randInd = randperm(numTrial);

sizeTrial = 0.5 + overlap;
part1 = psthTT(randInd(1:floor(numTrial*sizeTrial)),:);
part2 = psthTT(randInd(floor(numTrial*(1-sizeTrial))+1:numTrial),:);

end

