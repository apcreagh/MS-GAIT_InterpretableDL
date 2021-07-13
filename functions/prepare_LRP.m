function [LRP, TickLabels,newmap, boundaries]=prepare_LRP(LRP, options)
%% Function to prepare LRP plots;
% Function to normalise LRP values, generate colormap for LRP heatmaps.
%--------------------------------------------------------------------------
% Input:
%     LRP: a matrix/ tensor of LRP relavance values;
% _________________________________________________________________________
%     options: structure containing optional inputs.
%              'fontsize': the fontsize of text & labels on the figure 
%               (default 10); 
%              'save_name' a string denoting the save name for the figure;
% =========================================================================
% Output:
%     LRP: normalised matrix / tensor of LRP relavance values;
%     TickLabels: The LRP colorbar labels
%     newmap: The LRP colormap in RGB 
%     boundaries: The LRP colormap boundaries
%__________________________________________________________________________
%% Andrew Creagh. andrew.creagh@eng.ox.ac.uk
% Last modified in Jan 2021
%--------------------------------------------------------------------------
%% LRP Colormap & Limits
%set default values
black_key=1;
if isfield(options, 'black_key')  %see LRP_colormap.m for more details
    black_key=options.black_key;end

%generate the LRP colormap
newmap=LRP_colormap('diverging', [], black_key);

%normalise LRP 
if max(abs(LRP(:)))~=1
   LRP=LRP./max(abs(LRP(:))); end 

%set the colormap boundaries
boundaries=[-1, 1];
%set the colorbar labels
TickLabels={'R<<0', 'R=0', 'R>>0'};
%--------------------------------------------------------------------------
%We can modify these boundaries for visual effect, for example:
% boundaries=[min(LRP(:)), max(LRP(:))];
% TickLabels=cellstr(split(num2str([min(LRP(:)),0, max(LRP(:))]))); 
end
%EOF