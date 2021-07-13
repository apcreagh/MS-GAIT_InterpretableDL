function LRP=rescale_LRP(LRP, ptile_val_min, ptile_val_max)
%% Rescale the LRP values at the extremities
% Function re-scales (throttles) values above and below a specified percentile to that
% respective percentile value. This provides much more interpretable
% heatmaps as LRP values can have large outliers at the extermities (as it
% is unbounded). These outliers can influnce the heatmap intensity,
% suffocating lower relevance values. 
%--------------------------------------------------------------------------
% Input:
%     LRP: the LRP relevance values in one of the following formats:  
%         - [S x N x C] matrix of inertial sensor data, where S are the 
%           number of observations; N are the number of samples; C are the 
%           number of channels;
%         - [1 x N x C] matrix of inertial sensor data where N are the 
%           number of samples and C are the number of channels;
%         - [N x C] matrix of inertial sensor data where N are the number
%           of samples and C are the number of channels;
%     ptile_val_min: lower threshold value (percentile)
%                    (default=5, the 5th percentile);
%     ptile_val_max: higher threshold value (percentile)
%                    (default=5, the 95th percentile);
% =========================================================================
% Output:
%   LRP: the rescaled LRP values
%__________________________________________________________________________
%% Andrew Creagh. andrew.creagh@eng.ox.ac.uk
% Last modified in Jan 2021
%--------------------------------------------------------------------------
%set default values 
if ~exist('ptile_val_max', 'var') 
ptile_val_max=95;end 
if ~exist('ptile_val_min', 'var') 
ptile_val_min=5;end 
%--------------------------------------------------------------------------
%Rescale by percentile:
lrp_scale=LRP;
nSz=size(LRP);
LRP=LRP(:); %make vector
LRP(LRP>prctile(lrp_scale(:),ptile_val_max))=prctile(lrp_scale(:),ptile_val_max);
LRP(LRP<prctile(lrp_scale(:),ptile_val_min))=prctile(lrp_scale(:),ptile_val_min);
LRP=reshape(LRP, nSz);%re-packge back into the correct dimensions
end 
%EOF