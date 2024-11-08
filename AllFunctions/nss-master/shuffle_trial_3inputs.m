function [ shuffledP , shuffledQ , shuffledR ] = shuffle_trial_3inputs( P , Q , R )

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

numP = size(P,1);
numQ = size(Q,1);
numR = size(R,1);

indexShuffle = randperm(numP + numQ + numR);
PQR = [P;Q;R];

shuffledP = PQR(indexShuffle(1:numP),:);
shuffledQ = PQR(indexShuffle(numP+1:numP+numQ),:);
shuffledR = PQR(indexShuffle(numP+numQ+1:numP+numQ+numR),:);

end

