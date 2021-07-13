function ax=plot_CWT(x,X, fs, options)
%% Continuous Wavelet Transform (CWT)
% Worker function to plot the Continuous Wavelet Transform (CWT) of the raw
% inertial sensor data
%--------------------------------------------------------------------------
% Input:
%     x: the x-axis, either in time [seconds, s] or number of samples
%     X: the signal data -  
%         as a [1 x N x C] matrix of inertial sensor data, where N are
%         the number of samples and C are the number of channels; or an
%         [N x C] matrix of inertial sensor data where N are the number
%         of samples and C are the number of channels;
%     fs: the sampling frequency, in Hertz
% _________________________________________________________________________
%    options: structure containing optional inputs.
%     'freq_of_interest': the frequency range to sample the CWT, in Hertz
%     'CWT_Ylimits': the frequency range to visualise the CWT, in Hertz
%     'CWT_boundaries': The axis scaling range for the CWT colorbar
%     'fontsize': the fontsize of text & labels on the figure (default 10); 
% =========================================================================
% Output:
%    ax: the axis handle
%__________________________________________________________________________
%% Andrew Creagh. andrew.creagh@eng.ox.ac.uk
% Last modified in Jan 2021
%--------------------------------------------------------------------------
freq_of_interest=[0, 14];
CWT_boundaries=[0, 1.5];
fontsize=10;
%get options paramaters, if set 
if isfield(options, 'fontsize')
    fontsize=options.fontsize; end
if isfield(options, 'freq_of_interest')
    freq_of_interest=options.freq_of_interest; end
if isfield(options, 'CWT_boundaries')
    CWT_boundaries=options.CWT_boundaries; end
%--------------------------------------------------------------------------
%% Plot CWT
%Remove singleton dimensions.
X=squeeze(X);
%get the number of channels and samples 
num_channels=size(X, 2);num_samples=size(X, 1);
X=X(:, end); %get last value of X, if not a vector (should be the magnitude)

%extract the CWT with a Morlet Wavelet('amor')
[wt,f,coi,fb,scalingcfs] =cwt(X, 'amor', fs);
[scales, ~]=size(wt);

%pad the freq. vector for visualsation purposes
if min(f)>0.5 
    f(end+1)=0.5;wt(end+1, :)=zeros(1, num_samples);
    f(end+1)=0.5+1/fs;wt(end+1, :)=zeros(1, num_samples);
end 
f(end+1)=1/fs;wt(end+1, :)=zeros(1, num_samples);
f(end+1)=0.01;wt(end+1, :)=zeros(1, num_samples);
%window only the specific frequency range to visualse the CWT (in Hertz)
freq_of_interest_index=f>=freq_of_interest(1) & f < freq_of_interest(2);
f1=f(freq_of_interest_index);
wt1=wt(freq_of_interest_index,:);
%get the magnitude of the CWT coefficients
wt_mag=abs(wt1(:, 1:num_samples));
%calculate the scale-dependent energy
E=NaN(scales+1, 1);
for s=1:scales+1
 E(s, 1)=sum(abs(wt(s,:)).^2);  end 

%create a mesh grid for heatmap plotting
[Z,Y]=meshgrid(x, f1);
surf(Z,Y,wt_mag)
hold on
colormap(gca,jet(250))%set the colormap (using jet)
xlim([min(x), max(x)]) %xlimits
ylim(freq_of_interest) %limits
%rescale the CWT y-axis limits, for visual purposes if we want
if isfield(options, 'CWT_Ylimits')
    ylim(options.CWT_Ylimits)
end
set(gca, 'Yscale', 'log') %set the y-axis to log-scale
%set axis tick properties
set(gca,'YMinorTick','on') 
set(gca, 'YDir','normal','YTick',[0.5,1.5,3,7,14])
set(gca, 'TickLength', [0.015, 0.015])
set(gca,'TickDir', 'out')

%Add a colorbar
c=colorbar;
c.Label.String='CWT Coefficients';
c.FontSize=fontsize;
c.Location='southoutside'; 
caxis(CWT_boundaries) 
shading interp % use interpolated shading for a nice visualisation
%xlabel(xaxis_label);
ylabel('Frequency (Hz)');
view(2) %view in 2-D from the top down
box on %add a box to the plot
set(gca, 'fontsize', fontsize) %set font size
hold off %we're done!
ax=gca; %get the axis handle
%% Plot the Scale-Dependent Energy Spectrum
%This is anciallary code to plot corresponding the scale-dependent energy
%distribution. See publication for more details: 
%     Creagh, Andrew P., Cedric Simillion, Alan Bourke, Alf Scotland,
%     Florian Lipsmeier, Corrado Bernasconi, Johan van Beek et al.
%     "Smartphone-and smartwatch-based remote characterisation of
%     ambulation in multiple sclerosis during the two-minute walk test."
%     IEEE Journal of Biomedical and Health Informatics (2020).
%--------------------------------------------------------------------------
% fig=figure; plot(f1, smooth(E(freq_of_interest_index)),'k', 'Linewidth', 2)
% set(gca,'XScale','log') set(gca,
% 'YDir','normal','XTick',[0.5,1.5,3,7,14]) set(gca,'XMinorTick','on') %
% set(gca,'TickDir', 'out') set(gca, 'TickLength', [0.015, 0.015])
% xlim(freq_of_interest) xlim([0.5, 14]) %     set(gca,
% 'YDir','normal','XTick',[1, 3, 7]) xlabel('Frequency (Hz)')
% ylabel('Spectral Energy (E_s)')
end 
%EOF