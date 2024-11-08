
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

clear;
addpath([pwd '/AllFunctions']);
addpath([pwd '/AllFunctions/nss-master']);

%% %%%% only run once, for generating random data and shuffled data %%%%
paraversion = '_v1';
allScripts = {'save_random_subspace_and_projVar',...
    'save_shuffle_data_LR',...
    'save_shuffle_data_Context',...
    'save_projEucD_PCA'};
for iSc = 1:length(allScripts)
    clearvars -except 'allScripts' 'iSc' 'paraversion'
    scriptname = allScripts{iSc};
    prefix = 'Prism+Anti';  monkey = {'Sylvester'};
    CuingType = -1;
    run(['set_parameters_batch' paraversion]);
    run(scriptname);
end
clear;

%% %%%% figures (experimental data) %%%%
paraversion = '_v1';
allScripts = {'Fig2_PCA_projVar_Bars',...
    'Fig2_projEucD',...
    'Fig3_PCA_crossProjVar',...
    'Fig3_alignIdx',...
    'Fig4_vPCA',...
    'Fig_PCs',...
    'Fig_correlationMatrix'};
for iSc = 1:length(allScripts)
    clearvars -except 'allScripts' 'iSc' 'paraversion'
    scriptname = allScripts{iSc};
    prefix = 'Prism+Anti';  monkey = {'Sylvester'};
    CuingType = -1;
    run(['set_parameters_batch' paraversion]);
    run(scriptname);
    close all;
end
clear;

%% %%%% figures (RNN) %%%%
paraversion = '_RNN';
allScripts = {'Fig5_RNN'};
for iSc = 1:length(allScripts)
    clearvars -except 'allScripts' 'iSc' 'paraversion'
    scriptname = allScripts{iSc};

    prefix = 'DovePrism';
    run(['set_parameters' paraversion]);
    run(scriptname);

    prefix = 'PA';
    run(['set_parameters' paraversion]);
    run(scriptname);

    close all;
end
clear;
