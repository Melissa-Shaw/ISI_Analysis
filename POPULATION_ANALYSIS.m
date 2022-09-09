% Set up
shared_drive = 'X:';
addpath([shared_drive '\cortical_dynamics\User\ms1121\Code\General']);

% load db struct
run('makedb_TCB2_MS'); % get db struct

% set script options - TEMP MEASURE TO MAKE SCRIPT FLEXIBLE WHILE CODING
opt.save_fig = true;

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

        % find distributions of logISI for each unit
        nbins = 100;
        pre_distr = NaN(num_units,nbins); post_distr = pre_distr;
        pre_spiketimes = cell(num_units,1); post_spiketimes = pre_spiketimes;
        pre_logISI = cell(num_units,1); post_logISI = pre_logISI;
        for n = 1:num_units
            pre_raster = cond_raster{pre_cond}(n,:);
            [pre_spiketimes{n},pre_logISI{n}] = find_logISI(pre_raster);
            [pre_distr(n,:)] = histcounts(pre_logISI{n},nbins);
            
            post_raster = cond_raster{post_cond}(n,:);
            [post_spiketimes{n},post_logISI{n}] = find_logISI(post_raster);
            [post_distr(n,:)] = histcounts(post_logISI{n},nbins);
        end
        for n = 1:num_units
            pre_spiketimes{n} = pre_spiketimes{n}(1:end-1); % correcting for 1 less variable in ISI
            post_spiketimes{n} = post_spiketimes{n}(1:end-1);
        end

        % plot distributions of logISI across all units
        figure
        T = tiledlayout(2,3);
        title(T,['Exp: ' num2str(exp) ' Solution: ' solution ' Num units: ' num2str(num_units)]);
        
        % plot histogram of preVpost logISI across all units
        nexttile(1)
        histogram(cat(2,pre_logISI{:}),nbins,'FaceColor','k');
        hold on
        histogram(cat(2,post_logISI{:}),nbins,'FaceColor','r');
        xlabel('logISI');
        ylabel('Count');
        
        % plot pdf histogram of preVpost logISI across all units
        nexttile(2)
        histogram(cat(2,pre_logISI{:}),nbins,'FaceColor','k','Normalization','pdf');
        hold on
        histogram(cat(2,post_logISI{:}),nbins,'FaceColor','r','Normalization','pdf');
        xlabel('logISI');
        ylabel('PDF');
        
        % plot scatter of preVpost logISI across all units
        nexttile(3)
        scatter(cat(2,pre_spiketimes{:}),cat(2,pre_logISI{:}),'.');
        hold on
        scatter(cat(2,post_spiketimes{:}) + max(cat(2,pre_spiketimes{:})),cat(2,post_logISI{:}),'.');
        xline(max(cat(2,pre_spiketimes{:})));
        xlabel('Time (ms)');
        ylabel('logISI');
        
        
        % plot heatmaps of logISI
        nexttile(4)
        heatmap(pre_distr,'Colormap',parula);
        title('Pre');
        nexttile(5)
        heatmap(post_distr,'Colormap',parula);
        title('Post');
        
        % save figure
        if opt.save_fig == true
            FolderPath = [shared_drive '\cortical_dynamics\User\ms1121\Analysis Testing\ISI_Figures\Exp_Summaries\'];
            savefig([FolderPath 'Exp_' num2str(exp) '_ISI_Summary.fig']);
        end
        
        % progress report
        disp(['Exp: ' num2str(exp) ' complete.']);
        
    end
end
