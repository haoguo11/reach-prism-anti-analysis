function plot_eucD( D , Color , alpha)

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

T = size(D{1}.shuffle,1);
nShuffle = size(D{1}.shuffle,2);

for iData = 1:length(D)
    d = D{iData}.eucD;
    dShuffle = D{iData}.shuffle;
    colMap = Color{iData};

    for t = 1:T
        p(t,1) = (sum(dShuffle(t,:) >= d(t)) + 1) / (nShuffle + 1);
    end

    pSig = find(p < alpha);
    bl = [0;find(diff(pSig)~=1);length(pSig)];
    plot(d,'LineWidth',0.6,'color',colMap); hold on;
    for iBlock = 1:length(bl)-1
        rangeBlock = pSig(bl(iBlock)+1:bl(iBlock+1));
        plot(rangeBlock,d(rangeBlock),'LineWidth',1.6,'color',colMap);
    end
end

hold off;

end

