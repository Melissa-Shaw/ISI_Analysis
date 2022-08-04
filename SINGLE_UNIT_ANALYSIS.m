% Set up
shared_drive = 'X:';
addpath([shared_drive '\cortical_dynamics\User\ms1121\Code\General']);

% load db struct
run('makedb_TCB2_MS'); % get db struct

% set script options - TEMP MEASURE TO MAKE SCRIPT FLEXIBLE WHILE CODING
opt.save_indv_fig = true;

for exp = [Batch1PFC Batch2PFC]
    if exp ~= 52 & exp ~= 53
        % load spikestruct
        [spikestruct] = load_spikestruct(shared_drive,db,exp);

        % extract parameters
        pre_cond = db(exp).cond(1);
        post_cond = db(exp).cond(2);
        num_units = size(spikestruct.raster,1);
        cond_raster = spikestruct.condspikevector;
        if spikestruct.dose > 0
            solution = 'TCB2';
        else
            solution = 'Control';
        end

        % plot ISI distributions
        figure
        T = tiledlayout(4,6);
        title(T, ['Exp: ' num2str(exp) ' Solution: ' solution]);
        count = 1;
        for n = 1:num_units
            pre_raster = cond_raster{pre_cond}(n,:);
            post_raster = cond_raster{post_cond}(n,:);
            if count > 24
                figure
                tiledlayout(4,6);
                count = 1;
            end
            if sum(pre_raster) > 0 % if no firing in pre condition exclude neuron
                plot_unit_ISI(pre_raster,post_raster);
                count = count + 2;
            end
        end

        % save ISI distribution plots
        if opt.save_indv_fig == true
            FolderPath = [shared_drive '\cortical_dynamics\User\ms1121\Analysis Testing\ISI_Figures\Exp_Summaries\Exp_' num2str(exp) '_Unit_Figures'];
            mkdir(FolderPath);
            save_all_figures(FolderPath,'ISI_distributions');
            close all
        end
        
        % disp progress
        clear spikestruct n post_cond pre_cond pre_raster post_raster solution T count cond_raster
        disp(['Exp: ' num2str(exp) ' complete.']);
    end
end







