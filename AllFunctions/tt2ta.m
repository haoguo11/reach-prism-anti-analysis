function [outputTA] = tt2ta(inputTT)

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

% inputTT: (trial-by-trial PSTH) 2D cell of size #Units x #Conditions, 
% in each cell, 2D matrix of #Trials x #TimePoints
% outputTA: (trial-averaged) 3D matrix of #Units x #TimePoints x #Conditions

N = size(inputTT,1);
T = size(inputTT{1},2);
C = size(inputTT,2);

TA_2d = cell2mat(cellfun(@(c) mean(c), inputTT, 'UniformOutput', false));
outputTA = reshape(TA_2d,[N,T,C]);

end

