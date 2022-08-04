function [spiketimes,logISI] = find_logISI(spike_raster)
    spiketimes = find(spike_raster);
    ISI = diff(spiketimes);
    logISI = log(ISI);
end