function colormap_interp=LRP_colormap(cmap, ncolors, nreps_black)
%% Create LRP Heatmap Colormap
% Worker function generate an applicable RGB colormap for the LRP relevance
% projections.
%--------------------------------------------------------------------------
% Input:
%     cmap: a string denoting the type of colormap to generate:
%         'hot', hot(red) colormap; 
%         'cold', cold (blue) colormap;
%         'diverging', diverging colormap from the centre (min-max):
%                       cold<-centre->hot;
%         'inverse_diverging', diverging colormap from the centre (min-max):
%                       hot<-centre->cold;
%     ncolors: the number of unique color values
%     nreps_black: the number of black color values (black_key);
%                  the nreps_black denotes how much color weight we give to
%                  non-relevant values; the more black color values the
%                  less visually discernable low relevance values will be.
% =========================================================================
% Output:
%    colormap_interp: the (interpolated) LRP colormap in RGB format;
%__________________________________________________________________________
%% Andrew Creagh. andrew.creagh@eng.ox.ac.uk
% Last modified in Jan 2021
%--------------------------------------------------------------------------
%to manually make colormap:
% cmp_blue=[
%    247,252,240;224,243,219;204,235,197;168,221,181;123,204,196;...
%     78,179,211;43,140,190;8,104,172; 8,64,129]./255;
% cmp_red=[
% 255,255,204; 255,237,160; 254,217,118; 254,178,76; 253,141,60;
% 252,78,42; 227,26,28; 189,0,38; 128,0,38]./255;
%generate the colormap by plotting dummy figures and closing them.
fig=figure;cmp_red=colormap('hot');close(fig);
fig=figure;cmp_blue=colormap(cold);close(fig);
%--------------------------------------------------------------------------
%set default values
if ~exist('nreps_black', 'var') || isempty(nreps_black)
nreps_black=1;
end
%set black value in RGB
cmp_black=[5,5,5]./255;
%duplicate black values depending on nreps_black
cmp_black=repmat(cmp_black, nreps_black, 1);

%choose type of colormap to generate:
switch cmap
    case 'diverging'
        %cmp_blue=flipud(cmp_blue);
        cmp_red=flipud(cmp_red); 
        CMP=[cmp_red; cmp_black; cmp_blue];
    case 'hot'
        cmp_red=flipud(cmp_red);
        CMP=[cmp_red; cmp_black];
    case 'cold'
        cmp_blue=flipud(cmp_blue);
        CMP=[cmp_blue; cmp_black];
    case 'inverse_diverging'
        cmp_blue=flipud(cmp_blue);
        CMP=[cmp_blue; cmp_black; cmp_red];
end 
n = 500; %the number of dummy mesh grid indices
if ~exist('ncolors', 'var') || isempty(ncolors)
ncolors=round(size(CMP,1)/2);  %number of interpolated colors
end 
%--------------------------------------------------------------------------
[X,Y] = meshgrid(1:3,1:n);  %mesh of indices
%initalise colormap
map_color_pull=floor(linspace(1, size(CMP,1), ncolors));
%interpolate colormap
colormap_interp = interp2(...
      X([floor(linspace(1, n, ncolors))],:),...
      Y([floor(linspace(1, n, ncolors))],:),...
      CMP(map_color_pull, :),X,Y); 
%flip so colormaps ordered to diverge 
colormap_interp=flipud(colormap_interp);
%colormap_interp = brighten(colormap_interp,.5); %we could change the
%colormap brightness here
end 
%EOF