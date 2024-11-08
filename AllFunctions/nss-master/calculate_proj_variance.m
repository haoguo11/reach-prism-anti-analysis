function [ VAR , var ] = calculate_proj_variance( U , Data , ref , varargin )

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

D = size(U,2);
cData = Data(:,:);
ccData = bsxfun(@minus, cData, mean(cData,2));

if isempty(varargin) || strcmp(varargin{1},'svd')
    C = ccData*ccData'/(size(ccData,2)-1);
    [~,S,~] = svd(ccData','econ');  S = diag(S);
    eigvals = S(1:D).^2/(size(ccData,2)-1);
else
    if strcmp(varargin{1},'eig')
        C = cov(cData');
        eigvals = eigs(C, D, 'la');
        S = sqrt(eigs(ccData*ccData', D, 'la'));
    else
        error('Only the eig and SVD algorithms are applicable.')
    end
end

switch ref
    case 'whole'
        VAR = nan(D,1);
        r = sum(eigvals(1:D));
        for d = 1:D
            u = U(:,1:d);
            VAR(d,1) = trace(u'*C*u)/r;
        end
        var = diag(u'*C*u)./r;

    case 'subset'
        VAR = nan(D,1);
        var = nan(D,D);
        for d = 1:D
            u = U(:,1:d);
            r = sum(eigvals(1:d));
            VAR(d,1) = trace(u'*C*u)/r;
            var(d,1:d) = (diag(u'*C*u)./r)';
        end
end

end

