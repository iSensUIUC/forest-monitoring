% range doppler profile
clear
clc
close all;
range_to_cut=0
tx=3;
ddc_en=1;
dac_max=1100;
dac_min=949;
name="no table no corner reflector";
file_name = name + " " + tx + " ddc " + ddc_en + " dac max " + dac_max + " dac min " + dac_min +" ";

B = matfile(file_name);
[bins, numCols] = size(B.radar_frames);
bscan_data=B.radar_frames;
from=range_to_cut+1;
to=bins;
Tau = 65.84; %ns
tau = Tau/bins;
tof = [from*tau:tau:to*tau];
NFFTVel=512;
H = fft(bscan_data(from:to,:), NFFTVel, 2);
figure;
speed_of_light=14.9896229;%speed of light divided by 2 in cm/ns

Fs = 1/(Tau * 1e-9);  % Tau is converted from ns to s
frequencies = (-Fs/2 : Fs/NFFTVel : Fs/2-Fs/NFFTVel);
imagesc(frequencies, tof.*speed_of_light, fftshift(abs(H)));


% imagesc((1:numCols), tof.*speed_of_light, abs(H));
plot_name = replace(file_name, "_", " ");  % replace spaces with underscores
title(plot_name+" range doppler profile");
xlabel("Frequency (Hz)");
ylabel("Range (cm)");
% Save the plot to the 'plot' folder
if ~exist('plot', 'dir')
   mkdir('plot')
end
saveas(gcf, fullfile('plot', file_name + "range doppler profile.png"));
