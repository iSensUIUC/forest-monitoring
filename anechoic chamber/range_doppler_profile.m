clear
clc
close all;

file_name = "table with 1 corner reflector 3 ddc 1 dac max 1100 dac min 949 ";
B = matfile(file_name);
[bins, numCols] = size(B.radar_frames);
bscan_data=B.radar_frames;
range_to_cut=0
from=range_to_cut+1;
to=bins;
Tau = 65.84;
tau = Tau/bins;
tof = [from*tau:tau:to*tau];
NFFTVel=512;
H = fft(bscan_data(from:to,:), NFFTVel, 2);
figure;
speed_of_light=14.9896229;%speed of light divided by 2 in cm/ns
imagesc((1:numCols), tof.*speed_of_light, abs(H));
plot_name = replace(file_name, "_", " ");  % replace spaces with underscores
title(plot_name+" range doppler profile");
xlabel("Frequency");
ylabel("Range (cm)");
% Save the plot to the 'plot' folder
if ~exist('plot', 'dir')
   mkdir('plot')
end
saveas(gcf, fullfile('plot', file_name + "range doppler profile.png"));
