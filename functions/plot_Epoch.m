function [ax, sig]=plot_Epoch(x, X, options)
% Worker funciton to plot the raw inertial sensor data
%--------------------------------------------------------------------------
% Input:
%     x: the x-axis, either in time [seconds, s] or number of samples
%     X: the signal data -  
%         as a [1 x N x C] matrix of inertial sensor data, where N are
%         the number of samples and C are the number of channels; or an
%         [N x C] matrix of inertial sensor data where N are the number
%         of samples and C are the number of channels;
% _________________________________________________________________________
%    options: structure containing optional inputs.
%       'fontsize': the fontsize of text & labels on the figure (default 10); 
%       'num_channels': the number of channels to plot, default = size of X
%       'ylabel': a string containing the y-axis label text(default='Accel.')
%       'ylimits': the y-axis limits
% =========================================================================
% Output:
%   ax: the axis handle
%   sig: the output signal as a cell 
%__________________________________________________________________________
%% Andrew Creagh. andrew.creagh@eng.ox.ac.uk
% Last modified in Jan 2021
%--------------------------------------------------------------------------
%set default values
ylimits=[-1.1,1.1];
fontsize=10;
ylabel_='Accel.';
%Remove singleton dimensions.
X=squeeze(X);
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
%% Plotting
%loop through channels
for channel=1:num_channels
    %get the signal
    y=X(:, channel); 
    %rescale the input between -1, +1 for nicer visualisation
    y=rescale(y, -1, 1);
    %make the signal smoother by interpolating the signal to a higher
    %number of points; this will help for visualisation of attribution
    %values overlaid on the signal later - apply here as well for
    %consistency.
    xq = linspace(x(1), x(end), length(x)*4);
    xi = interp1(x,x,xq);
    yi = interp1(x,y,xq);
    %plot the signal
    sig{channel}=plot(xi, yi);
    %colour the signal (grey in this example) and set linewith
    sig{channel}.Color=[150,150,150]./255;
    sig{channel}.LineWidth=1;
    
    %if last channel (mangnitude) embolden the signal with a higehr
    %linewith and colour the signal (black in this example).
    if channel==4 
       sig{channel}.Color=[0,0,0]./255;
       sig{channel}.LineWidth=1.24;
    end 
    hold on
end 
%set xlimits, ylimits
xlim([min(x), max(x)])
ylim(ylimits)
box on %set box on around the plot
ylabel(ylabel_) %set ylabel text
%xlabel(xaxis_label); %set xlabel text
set(gca, 'fontsize', fontsize) %set fontsize
%set(gca,'XMinorTick','on')  %set minor x ticks on
set(gca, 'TickLength', [0.015, 0.015])  %%set (x,y) tick length
ax=gca; %get the axis to output
end
%EOF