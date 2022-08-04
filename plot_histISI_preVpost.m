function [h1,h2] = plot_histISI_preVpost(logISI_pre, logISI_post)
    [h1] = histogram(logISI_pre,50,'FaceColor','k');
    hold on
    [h2] = histogram(logISI_post,50,'FaceColor','r');
    hold off
    xlabel('logISI');
    ylabel('Count');
end