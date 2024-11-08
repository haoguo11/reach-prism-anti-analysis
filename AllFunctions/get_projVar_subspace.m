function [subspace,projVAR,projvar,yProjOntoSub] =...
    get_projVar_subspace( Data , whichSub , D , ref )

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

[N,T,C] = size(Data);

if C~=4 && C~=6
    error('The number of conditions in Data should be 4 or 6.');
end

R.TO = Data;
R.fi = Data(:,:,[1 2]);
R.se = Data(:,:,[3 4]);
if C == 6
    R.th = Data(:,:,[5 6]);
end

RNames = fieldnames(R);
for i = 1:length(RNames)
    data = R.(RNames{i});
    [pc.(RNames{i}),~,~] = pca(data(:,:)');
end

subspace = pc.(whichSub);
for i = 1:length(RNames)
    data = R.(RNames{i});

    [projVAR.(RNames{i}) , projvar.(RNames{i}) ] = ...
        calculate_proj_variance( subspace(:,1:D) , data , ref );

    y = subspace(:,1:D)'*bsxfun(@minus, data(:,:), mean(data(:,:),2));
    yProjOntoSub.(RNames{i}) = reshape( y , [D T size(data,3)] );
end

end

