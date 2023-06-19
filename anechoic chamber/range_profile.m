clear
clc
close all;
range_to_cut=0

file_name = "table with 1 corner reflector 3 ddc 1 dac max 1100 dac min 949";

B = matfile(file_name);
[bins, samples] = size(B.radar_frames);

A = real(B.radar_frames);

Tau = 65.84;
T = 65.84; %ns
speed_of_light=14.9896229;%speed of light divided by 2 in cm/ns
tau = Tau/size(A,1);
range = [tau:tau:size(A,1)*tau]*speed_of_light;

% Compute the average across columns
A_avg = mean(A, 2);

figure
plot(range(range_to_cut+1:end), A_avg(range_to_cut+1:end))
plot_name = replace(file_name, "_", " ");  % replace spaces with underscores
title(plot_name+" range profile");
xlabel("Range (cm)")
ylabel("Average Amplitude")
% Prepare the file_name variable for inclusion in the filename
name_no_spaces = replace(file_name, " ", "_");  % replace spaces with underscores
name_no_ext = extractBefore(name_no_spaces, ".");  % remove extension

% Save the plot to the 'plot' folder
if ~exist('plot', 'dir')
   mkdir('plot')
end
saveas(gcf, fullfile('plot', file_name + " Range Plot.png"))

% tof=[tau:tau:size(A,1)*tau]
% figure
% plot(tof(range_to_cut+1:end), A_avg(range_to_cut+1:end))
% title(file_name);
% xlabel("time of flight (ns)")
% ylabel("Average Amplitude")
% % Save the plot to the 'plot' folder
% if ~exist('plot', 'dir')
%    mkdir('plot')
% end
% saveas(gcf, fullfile('plot', name_no_ext + "_TOF_Plot.png"))
