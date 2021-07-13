function fig=LRP_CWT(SENSOR_DATA, LRP, options)
%% LRP-CWT Attribution Pipeline
Function to plot the Layer-Wise Relevance Propagation (LRP) decomposition 
relevance values for a signal epoch, as well as the Continous Wavelet Transform (CWT) time-frequency
analysis, combined into the LRP-CWT pipeline. 
The raw epoch of sensor data is plotted, 

Shell function to preprocess the inertial sensor data according to the
% work presented in in [1]. This includes the raw sensor data
% visualisation, the filtering, orientation transformation and any sensor
% data normalisation (if necessary).
%--------------------------------------------------------------------------
% Input:
    SENSOR_DATA: a [N x C] matrix of inertial sensor data, where N are
                 the number of samples and C are the number of channels 
                 such that:
          SENSOR_DATA(:,1) - conatins the monotonically increasing time vector 
          SENSOR_DATA(:,2) - X-axis sensor data
          SENSOR_DATA(:,3) - Y-axis sensor data
          SENSOR_DATA(:,4) - Z-axis sensor data
          SENSOR_DATA(:,5) - magnitude of sensor data ||a||
      LRP: 
% _________________________________________________________________________
%     options: structure containing optional inputs.
%     - 'plot_sensor_data' 0/1 (binary off/on). Functionality to plot the 
%       raw sensor data (default,options.plot_sensor_data=0, off)
%     - 'orientation_independent_transformation' 0/1 (binary off/on).
%     Functionality to perform orientation_independent_transformation
%     (default, options.orientation_independent_transformation=1, on).
%     - 'normalise_sensor_data' 0/1 (binary off/on). Functionality to
%     detrend and normalise (zscore) the sensor data 
%      (options.normalise_sensor_data=0, off).
% =========================================================================
% Output:
%     fig: the figure handle
% -------------------------------------------------------------------------
% Reference: 
% [1]   A. P. Creagh et al. (2020), "Interpretable Deep Learning for the
%       Remote Characterisation of Ambulation in Multiple Sclerosis using
%       Smartphones," arXiv, https://arxiv.org/abs/2103.09171.
%
%% Andrew Creagh. andrew.creagh@eng.ox.ac.uk
% Last modified in Jan 2021
%%
save_name='LRP';
fontsize=10;
if isfield(options, 'fontsize')
    fontsize=options.fontsize;
end
options.fontsize=fontsize; % add to options - legacy 

if isfield(options, 'save_name')
save_name=options.save_name;
end 

%% [Plot Figures]

num_samples=size(SENSOR_DATA, 2);
options.num_samples=num_samples;

[LRP, TickLabels,newmap, boundaries]=prepare_LRP(LRP, options);

if isfield(options, 'boundaries') 
    boundaries=options.boundaries; end 

x=return_xaxis(options);
options.ylimits=[-1.2, 1.2];

fig=figure;
fig.Position=[66    50  335   628];

subplot(6,1,1)
ax=plot_Epoch(x, SENSOR_DATA, options);

subplot(6,1,[2 3])
ax=plot_CWT(x, SENSOR_DATA, options);
box on
% LRP Plots
subplot(6, 1, 4)
options.num_channels=3;
options.add_colorbar=0;
ax=LRP_overlay_signal(x, SENSOR_DATA, LRP, newmap,boundaries, options);

subplot(6, 1, [5 6])
options.specific_x_axis=[];
options.xaxis_time=1; 
% options.xaxis_time=0;
[~, options]=return_xaxis(options);
options.num_channels=4;
options.add_colorbar=1;
ax=LRP_channel_activation(x, LRP, newmap,boundaries, TickLabels, options);
box on
shift_axis=0.025;
%get axes positions
h = findobj(gcf, 'Type', 'Axes');
h(2).Position(2)=h(2).Position(2)+shift_axis; %move up a bit
h(1).Position(2)=h(1).Position(2)+shift_axis; %move up a bit
h(1).Position(4)=h(1).Position(4)-0.03; %make channel plot smaller
h(1).Position(2)=h(1).Position(2)+0.045/2; %ove up a bit
h(4).Position(4)=h(2).Position(4); %ove up a bit
h(4).Position(2)=h(4).Position(2)+0.01; %ove up a bit
h(1).Position(2)=h(1).Position(2)-0.01; %ove up a bit

%get colorbar positions
cb = findobj(gcf, 'Type', 'Colorbar');
cb(1).Position(2)=cb(1).Position(2)-shift_axis/2; %move down the same amount we saved
cb(1).Position(4)=cb(2).Position(4); % make color bars the same size

%change the width of the LRP colorbar 
cb(1).Position(3)=cb(1).Position(3)-0.2; % make color bars the same size
cb(1).Position(1)=cb(1).Position(1)+0.1; % make color bars the same size


fig=gcf;
fig.Position=[66 50 394 628];
set(fig, 'Color', 'w');
%%

h = findobj(gcf, 'Type', 'Axes');
for i=1:length(h)
h(i).SortMethod='ChildOrder';
end 

%%
if options.save_figure

    if options.quick_save_figure
        saveas(fig, [options.save_pathname, filesep, save_name, '.png'])
    else
        print(fig, [options.save_pathname, filesep, save_name, '.svg'],'-dsvg', '-painters')
        saveas(fig, [options.save_pathname, filesep, save_name '_specific_time', '.fig'])
       export_fig([options.save_pathname, filesep, save_name '_specific_time'],'-pdf', '-painters', '-r500')
       export_fig([options.save_pathname, filesep, save_name '_specific_time'], '-png', '-r500')


    end
end 

end 
