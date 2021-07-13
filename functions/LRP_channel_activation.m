function ax=LRP_channel_activation(x, LRP, newmap,boundaries, TickLabels, options)
%% LRP Channel-Wise Heatmap
% Worker function to plot the LRP attribution relevance values
% (activations) for each input channel seperately as a heatmap
%--------------------------------------------------------------------------
% Input:
%     x: the x-axis, either in time [seconds, s] or number of samples
%     X: the signal data -  
%         as a [1 x N x C] matrix of inertial sensor data, where N are
%         the number of samples and C are the number of channels; or an
%         [N x C] matrix of inertial sensor data where N are the number
%         of samples and C are the number of channels;
%     LRP: a [1 x N x C] or [N x C]  matrix of corresponding LRP relavance
%          values per sensor sample;
%     color_map: the pseudocolor colormap for the min-max relavance values 
%     boundaries: the pseudocolor colormap boundaries for the min-max
%                 relavance values
% _________________________________________________________________________
%    options: structure containing optional inputs.
%     'scale_range': The axis scaling range for the LRP pseudocolor if
%                    independent of 'boundaries';
%     'add_colorbar': (0/1) (binary) option to add colorbar to plot;
%     'fontsize': the fontsize of text & labels on the figure (default 10);
%     'num_channels': the number of channels to plot, default = size of X;
%     'ylabel': a string containing the y-axis label text(default='Accel.')
%     'ylimits': the y-axis limits;
% =========================================================================
% Output:
%    ax: the axis handle
%__________________________________________________________________________
%% Andrew Creagh. andrew.creagh@eng.ox.ac.uk
% Last modified in Jan 2021
%--------------------------------------------------------------------------
%set default values
ylimits=[-1,1]; 
fontsize=11;
ylabel_='Channel';
xlabel_='';
%get options paramaters, if set 
if isfield(options, 'fontsize')
    fontsize=options.fontsize;end
if isfield(options, 'xlabel')
    xlabel_=options.xlabel;end
if isfield(options, 'ylabel')
    ylabel_=options.ylabel;end
%--------------------------------------------------------------------------
% Create Heatmap
%--------------------------------------------------------------------------
%set the mean relevace as the minimum LRP value, so LRP close to zero are
%(non-relevance regions) are not visualsed
minimum=mean(boundaries); 
%generate the heatmap matrix of LRP values per channel for plotting
if size(LRP,3)>1 %functionality for [NxC] LRP matrix
    Z=squeeze(LRP(:, :, :));
    ytile=[0,1,1.10, 2.10, 2.20, 3.20, 3.30, 4.30];
    %set the ytick locations as the middle of the channel
    yticklocs=movmean(ytile, 2);
    yticklocs=yticklocs(2:2:length(yticklocs));
    %create the heatmap matrix
    Zpadded=[...
        Z(:,1),...
        zeros(size(Z,1), 1)+minimum,...
        Z(:,2),...
        zeros(size(Z,1), 1)+minimum...
        Z(:,3),...
        zeros(size(Z,1), 1)+minimum...
        Z(:,4),...
        zeros(size(Z,1), 1)+minimum...
        ];
else %alternative functionality for [NxC] LRP matrix (legacy)
    Z=squeeze(LRP(:, :, :));
    ytile=[0, 1];
    yticklocs=mean(ytile);
    Zpadded=[Z;Z];
    Zpadded=Zpadded';
end
% create a mesh grid to apply project relevance values
[X,Y] = meshgrid(x,ytile);
%create heatmap using a surface plot
pc=surf(X,Y,Zpadded');
pc.EdgeColor='none';   %hide the edge line color
xlim([min(x), max(x)]) %set the xlimits
ylim([min(ytile),max(ytile)]) %set the ylimits
yticks(yticklocs) %set the y-label tick locations
yTickLabels={'a_x', 'a_y', 'a_z', '||a||'}; %set the channel labels
% yTickLabels=1:4; (if we want to just denote as channel 1 to channel 4)
yticklabels(yTickLabels);
set(gca, 'TickLength', [0.015, 0.015])
set(gca,'TickDir', 'out')
view(2);  %view in 2-D from the top down
colormap(gca,newmap) %set relevance the colormap
caxis(boundaries) %set pseudocolor limits
%--------------------------------------------------------------------------
%(optional): add colorbar to LRP plot
if options.add_colorbar
    cc=colorbar; % Add a colorbar
    cc.Location='southoutside'; 
    cc.Label.String = ['LRP'];
    cc.FontSize=fontsize;
    caxis(boundaries); %re-set pseudocolor limits
    if isfield(options, 'scale_LRP') ...
            && options.scale_LRP && isfield(options, 'scale_range')
        caxis(options.scale_range)
    end
    %Set the ticks to be either end of the colorbar
    cc.Ticks=linspace(boundaries(1), boundaries(2), length(TickLabels));
    cc.TickLabels=TickLabels;
end
%--------------------------------------------------------------------------
box on %add a box around the axis
ylabel(ylabel_); %set y-label string
xlabel(xlabel_); %set x-label string
set(gca, 'fontsize', fontsize) %set fontsize
ax=gca;
end 
%EOF