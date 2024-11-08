
% Set parameters for RNN analyses

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

%% load data
load([pwd '\Datasets\' prefix '_RNN_pre_PRR.mat']);

% condition
switch prefix
    case 'DovePrism'
        condition = 1:4; % 1234 represent NL, NR, PL, PR
    case 'PA'
        condition = [1 2 5 6]; % 1234 represent LRUD Pro, 5678 for LRUD Anti
end

%% set parameters for plotting figures
switch prefix
    case 'DovePrism'
        plotPara.condColor = [0.2 0.8 0.2 ; 0.2 0.8 0.2 ; 1 0.39 0.28 ; 1 0.39 0.28];
        plotPara.condLinestyle = {'-';':';'-';':'};
        plotPara.condLegend = {'Normal Left';'Normal Right';'Prism Left';'Prism Right'};
               
    case 'PA'
        plotPara.condColor = [0.2 0.8 0.2; 0.2 0.8 0.2;  0.25 0.25 0.9; 0.25 0.25 0.9;...
            0 0.48 0.76 ; 0 0.48 0.76; 0.4 0.2 0.6 ; 0.4 0.2 0.6];
        plotPara.condLinestyle = {'-';':';'-';':';'-';':';'-';':'};
        plotPara.condLegend = {'Pro Left';'Pro Right';'Pro Up';'Pro Down';...
            'Anti Left';'Anti Right';'Anti Up';'Anti Down'};
end
