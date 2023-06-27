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
NFFTVel=512;
H = fft(bscan_data(from:to,:), NFFTVel, 2);
Tau = 65.84;
tau = Tau/size(bscan_data,1);
speed_of_light=14.9896229;%speed of light divided by 2 in cm/ns
range=[tau:tau:size(bscan_data,1)*tau]*speed_of_light;

% fig=figure;
% imagesc([1:size(bscan_data,2)], range(range_to_cut+1:end), abs((bscan_data(range_to_cut+1:end,:))));
% colorbar;
% title([' amplitude with range versus timeframe after subtracting first frame '])
% xlabel('Timeframe Number');
% ylabel('Range (cm)');
% set(fig, 'Position', [100, 50, 700, 400]) % [left, bottom, width, height]




figure;
Fs = 32;  % Tau is converted from ns to s
%     frequencies = (-Fs/2 : Fs/NFFTVel : Fs/2-Fs/NFFTVel);
%     imagesc(frequencies, range, fftshift(abs(H)));
frequencies = (0 : Fs/NFFTVel : Fs/2-Fs/NFFTVel);
H_positive = H(:,1:NFFTVel/2);  % This gets the first half of H, corresponding to the positive frequencies
imagesc(frequencies, range, abs(H_positive));

plot_name = replace(file_name, "_", " ");  % replace spaces with underscores
colorbar;
title(plot_name+" range doppler profile");
xlabel("Frequency (Hz)");
ylabel("Range (cm)");
% Save the plot to the 'plot' folder
if ~exist('plot', 'dir')
   mkdir('plot')
end
saveas(gcf, fullfile('plot', file_name + "range doppler profile.png"));
