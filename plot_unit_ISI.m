
% e.g. pre_raster = spikestruct.condspikevector{1}(1,:);
% e.g. post_raster = spikestruct.condspikevector{3}(1,:);

function [pre_h,post_h] = plot_unit_ISI(pre_raster,post_raster)

    % find pre and post spiketimes and logISI
    [pre_spiketimes,pre_logISI] = find_logISI(pre_raster);
    [post_spiketimes,post_logISI] = find_logISI(post_raster);

    % plot histogram of logISI preVpost
    nexttile
    [pre_h] = histogram(pre_logISI,50,'FaceColor','k');
    hold on
    [post_h] = histogram(post_logISI,50,'FaceColor','r');
    hold off
    xlabel('logISI');
    ylabel('Count');

    % plot scatter of logISI against time in preVpost
    nexttile
    scatter(pre_spiketimes(2:end),pre_logISI,'.');
    hold on
    scatter(post_spiketimes(2:end)+max(pre_spiketimes),post_logISI,'.');
    xline(max(pre_spiketimes))
    xlabel('Time (ms)');
    ylabel('logISI');
    
end