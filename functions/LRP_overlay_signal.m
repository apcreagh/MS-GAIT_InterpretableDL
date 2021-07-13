function ax=LRP_overlay_signal(x, X, LRP, color_map,boundaries, options)
%% Project LRP attribution directly on a signal
% Worker function to plot the LRP attribution relavnce values overlaid
% directly onto the raw inertial sensor data
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
ylabel_='Accel.';
granularity=10; %set for how granular the signal interpolation should be; 
%Remove singleton dimensions.
X=squeeze(X);LRP=squeeze(LRP);
num_channels=size(X, 2);
%get options paramaters, if set 
if isfield(options, 'fontsize')
    fontsize=options.fontsize;end
if isfield(options, 'num_channels')
    num_channels=options.num_channels;end
if isfield(options, 'ylabel')
    ylabel_=options.ylabel;end
if isfield(options, 'ylimits')
    ylimits=options.ylimits;end
%--------------------------------------------------------------------------
%% Plot the LRP attribution projections
%loop through each sensor channel
for channel=1:num_channels
    %get the signal
    y=X(:, channel);  
    %rescale the input between -1, +1 for nicer visualisation
    y=rescale(y, -1, 1);
    %get LRP relevance values
    z=LRP(:, channel); 
    %interpolate all 3 signals
    xq = linspace(x(1), x(end), length(x)*granularity);
    xi = interp1(x,x,xq);
    yi = interp1(x,y,xq);
    zi = interp1(x,z,xq);     
    y=yi; z=zi; 
    %plot the raw (interpolated) sensor signal
    plot(xi, yi, 'Color', [40, 40, 40]./255, 'LineWidth', 1.5)
    hold on
    %overlay the relevance values directly on the signal
    surf([xi(:) xi(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
        'FaceColor', 'interp', ...    % Don't bother filling faces with color
        'EdgeColor', 'interp', ...  % Use interpolated color for edges
        'LineWidth', 1);
    hold on
    view(2); %view in 2-D from the top down
    hold on
    %add the colormap
    colormap(gca,color_map)    
end
%set limits
xlim([min(x), max(x)])
ylim(ylimits)
set(gca, 'TickLength', [0.015, 0.015])
%add a box to axis, but remove any grids
box on
grid off
%to set a specific LRP pseudocolor scale rather than the boundaries
if isfield(options, 'scale_LRP') && options.scale_LRP
    caxis(options.scale_range)
end 
%set pseudocolor limits
caxis(boundaries)
%--------------------------------------------------------------------------
%(optional): add colorbar to LRP plot
if options.add_colorbar
cc=colorbar; % Add a colorbar
%re-set pseudocolor limits
caxis(boundaries) 
cc.Location='southoutside';  
cc.Label.String = ['LRP'];
cc.FontSize=fontsize; 
%add tick labels and spacing
cc.Ticks = linspace(boundaries(1), boundaries(2), length(options.TickLabels)); 
cc.TickLabels =options.TickLabels;
end
%--------------------------------------------------------------------------
%xlabel('Samples')%xlabel('Time [s]')
ylabel(ylabel_) %add ylabel
set(gca, 'fontsize', fontsize) %set fontsize
ax=gca;
end 
%EOF