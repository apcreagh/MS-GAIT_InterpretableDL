function [x, options]=return_xaxis(options)
%Worker function to create either:
%     1) x-axis values in seconds [s];
%     2) x-axis values in seconds [s] from a specific time;
%     3) x-axis values in number of samples;
%--------------------------------------------------------------------------
%Input:
%     options: structure containing optional inputs.
%        'xaxis_time': 1/0 (binary); use x-axis values in seconds [s] (1)
%        or number of samples (0)
%        'specific_x_axis':  [minimum value, maximum value], in seconds [s]
% =========================================================================
% Output:
%     x: x-axis values
%     options: structure containing optional inputs.
%__________________________________________________________________________ 
%% Andrew Creagh. andrew.creagh@eng.ox.ac.uk
% Last modified in Jan 2021
if isfield(options, 'specific_x_axis') && ~isempty(options.specific_x_axis)
    x=linspace(...
        min(options.specific_x_axis), max(options.specific_x_axis), ...
                options.num_samples);
    options.xlabel='Time [s]';  
elseif isfield(options, 'xaxis_time') && options.xaxis_time
    options.xlabel='Time [s]';
    fs=options.fs;
    x=linspace(1/fs, options.num_samples/fs, options.num_samples);  
elseif isfield(options, 'xaxis_time') && ~options.xaxis_time
    options.xlabel='Samples';
    x=1:options.num_samples;
end
end 
%EOF