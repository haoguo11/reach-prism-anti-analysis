
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

%%
foldername = '\RNN_python\test_pa\2steps\'; taskname = 'pa'; savename = 'PA_';
% foldername = '\RNN_python\test_np\2steps\'; taskname = 'np'; savename = 'DovePrism_';

numData = 1; % numData = 20 in Results

%% 
for iData = 1:numData
    
    loadfilename = [pwd foldername 'testing_' taskname '_' num2str(iData) '.hdf5'];
    
    prr_activity = h5read(loadfilename,'/activity1');
    trial_id = h5read(loadfilename,'/trial_id');
    output = h5read(loadfilename,'/output');
    
    [N,T,nTrial] = size(prr_activity);
    nCond = 4;
    
    psthTAtest1 = nan(N,T,nCond);
    model_output = cell(nCond,1);
    for iC = 1:nCond
        psthTAtest1(:,:,iC) = mean(prr_activity(:,:,trial_id' == iC),3);
        model_output{iC} = output(:,:,trial_id' == iC);
    end
    
    psthTT = cell(N,nCond);
    for iN = 1:N
        for iC = 1:nCond
            psthTT{iN,iC} = squeeze(prr_activity(iN,:,trial_id' == iC))';
        end
    end
    psthTAtest2 = tt2ta(psthTT);
    % psthTAtest1 should be equal to psthTAtest2

    [ psthTA , ~ ] = preprocess_data( psthTT , '2' , 5); % preprocessed in the same way as neural data
    
    model_output_all{iData} = model_output;
    psthTA_all{iData} = psthTA;
    
end

save(['Datasets\' savename 'RNN_pre_PRR.mat'],...
    'psthTA_all','model_output_all');
