clear
close all
%% Load the data
addpath([pwd filesep 'functions'])
load([pwd filesep 'results' filesep 'LRP_MACRO_X_DBA_HC.mat']);
LRP=double(LRP); %ensure that LRP is a double precision array
load([pwd filesep 'data' filesep 'X_DBA_HC.mat'])
%set the DBA epoch variable 
SIGNAL_DATA(1, :, :)=X_DBA;
%% Parameters
%--------------------------------------------------------------------------
options.save_figure=0;  %1/0 (binary): save the figures?
%the path to save the figures 
options.save_pathname=[pwd , filesep, 'img', filesep];
options.save_name='LRP_DBA_HC';
options.normlise_lrp=1;         %min-max normalise the LRP 
options.xaxis_time=1;           %1/0 (binary); use x-axis values in seconds [s] vs samples (0)
options.fs=50;                  %the sampling frequency in Hertz (Hz)
options.scale_LRP=1;            %scale the LRP colormap to a specific range
options.scale_range=[-1, 1];    %the scale the LRP colormap to a specific range
options.boundaries=[-1 1];      %set the boundaries for the LRP colormap 
options.CWT_Ylimits=[0.5, 14];  %Set the frequency range to visualise the CWT, in Hertz (Hz)
options.CWT_boundaries=[0, 1.5];%Set the axis scaling range for the CWT colorbar, in Hertz (Hz)
options.black_key=20;           %Set the amount of non-relavant LRP values to be plotted 
                                %(higher black key denotes more harsh filtering of LRP values around zero)
%--------------------------------------------------------------------------
%Re-scale LRP values above min and max percentile thresholds to those percentile
%values. This combats outliers suffocating the heatmap intensities. 
ptile_val_max=95; ptile_val_min=5;
LRP=rescale_LRP(LRP, ptile_val_min, ptile_val_max);
% As this is to visualse healthy controls (HC), switch LRP positive and
% negative relevance to keep convention: (Ri>0) indicating f(x)>0  (i.e.
% MS). Blue and cold hues are negative relevance values (Ri<0) indicating
% f(x)<0 (i.e. HC)
LRP=-LRP;
%--------------------------------------------------------------------------
%% LRP-CWT attribution pipeline
fig=LRP_CWT(SIGNAL_DATA, LRP, options);
%--------------------------------------------------------------------------
%EOF