close all;
clear;
clc;
range_to_cut=0
no_background_name = "10 cm sand with metal plate as reflector.mat";
name = no_background_name;
background_name= "background for "+name;


path="C:\Users\wisel\Desktop\modules-main\forest_sensing"
radar_frames = fullfile(path, name);
radar_frame_background = fullfile(path, background_name);

A = load(radar_frames);
B = load(radar_frame_background);

[bins, samples] = size(A.radar_frames);

% obj = pipeline(A.radar_frames, A.timestamps, 20, bins, T, 0.1, regexprep("720cm_100ms_tag_tx3_ddc_1_dac_max_1240_dac_min_1040", '_', ' '));
% obj = pipeline(A.radar_frames, A.timestamps, range_to_cut, bins, T, 0.1, regexprep("pipeline_result_with_background", '_', ' '));


C = real(A.radar_frames - B.radar_frames);
output_name = "background subtraction result for " + name;
save(output_name, 'C');

% obj = pipeline(C, A.timestamps, range_to_cut, bins, T, 0.1, regexprep("pipeline_result_after_background_subtraction", '_', ' '));
C_avg = mean(C, 2);
Tau = 65.84;
T = 65.84; %ns

tau = Tau/size(C,1);
range = [tau:tau:size(C,1)*tau]*15;
figure
plot(range(range_to_cut+1:end), C_avg(range_to_cut+1:end))
title("background subtraction result for "+name+" Range Plot");
xlabel("Range (cm)")
ylabel("Average Amplitude")


% Save the plot to the 'plot' folder
if ~exist('plot', 'dir')
   mkdir('plot')
end
saveas(gcf, fullfile('plot', "background subtraction result for"+name + "_Range_Plot.png"))

tof=[tau:tau:size(C,1)*tau]
figure
plot(tof(range_to_cut+1:end), C_avg(range_to_cut+1:end))
title("background subtraction result for "+name+" TOF Plot");
xlabel("time of flight (ns)")
ylabel("Average Amplitude")
if ~exist('plot', 'dir')
   mkdir('plot')
end
saveas(gcf, fullfile('plot', "background subtraction result for"+name + "_TOF_Plot.png"))

% Tau = 65.84
% tau = Tau/size(C,1);
% tof = [tau:tau:size(C,1)*tau]*15;
% 
% figure;
% imagesc([1:size(C,2)], tof(range_to_cut+1:end), abs(C(range_to_cut+1:end,:)));
% colorbar;
% title('amplitude with range versus timeframe with background subtraction')
% xlabel('Timeframe Number');
% ylabel('Range (cm)');
% 
% D = bsxfun(@minus, A.radar_frames, A.radar_frames(:,1));  % Subtract the first column from all other columns
% figure;
% imagesc([1:size(D,2)], tof(range_to_cut+1:end), abs(D(range_to_cut+1:end,:)));
% colorbar;
% title('amplitude with range versus timeframe after subtracting first frame')
% xlabel('Timeframe Number');
% ylabel('Range (cm)');
% obj1 = pipeline(D, A.timestamps, range_to_cut, bins, T, 0.1, regexprep("pipeline result after subtracting first frame", '_', ' '));
% 
% 
