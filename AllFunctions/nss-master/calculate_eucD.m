function [ eucDStruc ] = calculate_eucD( Data , nameCond , whichAxis)

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

if size(Data,3) ~= length(nameCond)
    error('The number of condition in nameCond should match the Data.');
end

indexComb = nchoosek(1:size(Data,3),2);
condComb = nchoosek(nameCond,2);

for i = 1:size(condComb,1)

    vData = whichAxis'*(Data(:,:,indexComb(i,1)) - Data(:,:,indexComb(i,2)));
    D = normv( vData );

    eucDStruc(i).eucD = D;
    eucDStruc(i).minD = min(D);
    eucDStruc(i).maxD = max(D);
    eucDStruc(i).nameCond1 = condComb{i,1};
    eucDStruc(i).nameCond2 = condComb{i,2};

    D = [];
end

end
