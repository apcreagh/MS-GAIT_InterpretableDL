function fig=LRP_CWT(SENSOR_DATA, LRP, options)
%% LRP-CWT Attribution Pipeline
% Function to plot the Layer-Wise Relevance Propagation (LRP) decomposition
% relevance values for a signal epoch, as well as the Continous Wavelet
% Transform (CWT) time-frequency analysis, combined into the LRP-CWT
% pipeline. 
%--------------------------------------------------------------------------
% Input:
%     SENSOR_DATA: a [1 x N x C] matrix of inertial sensor data, where N are
%                  the number of samples and C are the number of channels 
%                  such that:
%           SENSOR_DATA(1, :,1) - X-axis sensor data
%           SENSOR_DATA(1, :,2) - Y-axis sensor data
%           SENSOR_DATA(1, :,3) - Z-axis sensor data
%           SENSOR_DATA(1, :,4) - magnitude of sensor data ||a||
%
%     LRP: a [1 x N x C] matrix of corresponding LRP relavance values per
%          sensor sample;
% _________________________________________________________________________
%     options: structure containing optional inputs.
%         'fs': the sampling frequency in Hertz (Hz)
%         'fontsize': the fontsize of text & labels on the figure (default 10);
%         'save_name' a string denoting the save name for the figure;
%         'num_channels': the number of channels to plot, default = size of X
%         'ylabel': a string of the y-axis label text(default='Accel.')
%         'ylimits': the y-axis limits
%         (see embedded functions for further optional inputs)
% =========================================================================
% Output:
%     fig: the figure handle
%         The top row represents a 3-axis accelerometer trace. The
%         magnitude (||a||) of the 3-axis signal is highlighted in bold.
%         The second row depicts the top view of the CWT scalogram of
%         ||a||, which is the absolute value of the CWT as a function of
%         time and frequency. The DCNN input relevance values (Ri) are
%         determined using Layer-Wise Relevance Propagation (LRP). Red and
%         hot colours identify input segments denoting positive relevance
%         (Ri>0) indicating f(x)>0  (i.e. MS). Blue and cold hues are
%         negative relevance values (Ri<0) indicating f(x)<0 (i.e. HC),
%         while black represents Ri is approximately 0 inputs which have
%         little or no influence to the DCNNs decision. LRP values are
%         overlaid upon the accelerometer signal,where the bottom panel
%         represents the LRP activations per input (i.e.
%         aX,aY,aZ,||a||).
% -------------------------------------------------------------------------
% Reference: 
% [1]   A. P. Creagh et al. (2020), "Interpretable Deep Learning for the
%       Remote Characterisation of Ambulation in Multiple Sclerosis using
%       Smartphones," arXiv, https://arxiv.org/abs/2103.09171.
%__________________________________________________________________________
%% Andrew Creagh. andrew.creagh@eng.ox.ac.uk
% Last modified in Jan 2021
%% Initialisation 
%defaults
save_name='LRP';
fontsize=10; 
fs=50;

if isfield(options, 'fs')
    fs=options.fs; end
if isfield(options, 'fontsize')
    fontsize=options.fontsize; 
    else
    %add to options structure if fontsize not already denoted (legacy)
    options.fontsize=fontsize; 
end
%gather the save name if specified
if isfield(options, 'save_name')
save_name=options.save_name; end 
%-------------------------------------------------------------------------
% determine the number of sensor samples
num_samples=size(SENSOR_DATA, 2);
options.num_samples=num_samples;

%run the prep function to normalise LRP values, generate colormap for
%plotting etc
[LRP, TickLabels,newmap, boundaries]=prepare_LRP(LRP, options);

%if pre-existing boundaries for the LRP colorbar not denoted, use those
%instead of the calculated ones. Specifiying boundaries other than min/max
%can amplify certain high relevance regions for highlighting during
%visualisation
if isfield(options, 'boundaries') 
    boundaries=options.boundaries; end 

%Standalone function to generate the x-axis values in seconds [s], seconds
%from a specific time, or alternatively in number of samples:
[x, options]=return_xaxis(options);

%specify the y-limits for the acceleration axis
options.ylimits=[-1.2, 1.2];
%--------------------------------------------------------------------------
%% Plot LRP-CWT 
%-------------------------------------------------------------------------
% Plot the LRP-CWT figure
%-------------------------------------------------------------------------
fig=figure;
fig.Position=[66    50  335   628];
% 1)Plot the raw sensor signal
subplot(6,1,1)
%call function to plot raw sensor signal:
ax1=plot_Epoch(x, SENSOR_DATA, options);

% 2)Plot the CWT of the sensor signal
subplot(6,1,[2 3])
%span over 2 subplots for better visualision; surfs and meshes tend to get
%squished if they are plotted as one subplot.
%call function to plot CWT of the sensor signal:
ax2=plot_CWT(x, SENSOR_DATA, fs, options);

% 3)Plot the LRP values superimposed on the sensor signal 
subplot(6, 1, 4)
%denote the numbr of channels as 3, as we only want to look at the
%individual 3-axis, not overlay onto the magnitude as well, for visual
%purposes;
options.num_channels=3; 
%specify no colorbar, we'll put that on underneath the channel-wise
%activation heatmap later
options.add_colorbar=0;
%call function to plot overlay of LRP on the sensor signal:
ax3=LRP_overlay_signal(x, SENSOR_DATA, LRP, newmap,boundaries, options);

% 4)Plots the LRP values as individual heatmaps across sensor channels
subplot(6, 1, [5 6]) 
%span over 2 subplots for better visualision; surfs and meshes tend to get
%squished if they are plotted as one subplot. 
options.specific_x_axis=[]; %remove the axis label
options.xaxis_time=1; % options.xaxis_time=0;
% use the return_xaxis.m function to initalise the options structure for
% use in LRP_channel_activation.m
[~, options]=return_xaxis(options);
options.num_channels=4;%re-denote the number of channels
options.add_colorbar=1; %specify to add the LRP colorbar here now. 
ax4=LRP_channel_activation(x, LRP, newmap,boundaries, TickLabels, options);
%-------------------------------------------------------------------------
% Figure Beautification
%-------------------------------------------------------------------------
%shift this figures around, including the colorbars
shift_axis=0.025;
%get axes positions
h = findobj(gcf, 'Type', 'Axes');
h(2).Position(2)=h(2).Position(2)+shift_axis; %move up a bit
h(1).Position(2)=h(1).Position(2)+shift_axis; %move up a bit
h(1).Position(4)=h(1).Position(4)-0.03; %make channel plot smaller
h(1).Position(2)=h(1).Position(2)+0.045/2; %move up a bit
h(4).Position(4)=h(2).Position(4); %move up a bit
h(4).Position(2)=h(4).Position(2)+0.01; %move up a bit
h(1).Position(2)=h(1).Position(2)-0.01; %move up a bit

%get colorbar positions
cb = findobj(gcf, 'Type', 'Colorbar');
cb(1).Position(2)=cb(1).Position(2)-shift_axis/2; %move down the same amount we saved
cb(1).Position(4)=cb(2).Position(4); % make color bars the same size
%change the width of the LRP colorbar 
cb(1).Position(3)=cb(1).Position(3)-0.2; % make color bars the same size
cb(1).Position(1)=cb(1).Position(1)+0.1; % make color bars the same size

%change the position and size of the figure
fig=gcf;
fig.Position=[66 50 394 628];
set(fig, 'Color', 'w');

%order the axis by child, so when saved as a figure the LRP values are
%better rendered. 
h = findobj(gcf, 'Type', 'Axes');
for i=1:length(h)
h(i).SortMethod='ChildOrder';
end 
%-------------------------------------------------------------------------
%% Saving 
%if options.save_figure==1, save the figure as .png, .svg, and .fig
if options.save_figure
    saveas(fig, [options.save_pathname, filesep, save_name, '.fig'])
    saveas(fig, [options.save_pathname, filesep, save_name, '.png'])
    print(fig, [options.save_pathname, filesep, save_name, '.svg'],'-dsvg', '-painters')
    %ensure that we are using painters rendering in order to allow
    %overlaying of LRP values on signal plots;
end 
end 
%EOF