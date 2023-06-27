%this file use different background subtaction method. It subtract data
%from tag with data from background
close all;
clear;
clc;


T = 65.84; %ns

radar_frames = "C:\Users\wisel\Desktop\modules-main\new_work\tag_3_ddc_1_dac_max_1100_dac_min_949.mat";
radar_frame_background = "C:\Users\wisel\Desktop\modules-main\new_work\background_3_ddc_1_dac_max_1100_dac_min_949.mat";

A = load(radar_frames);
B = load(radar_frame_background);
range_to_cut=11


[bins, samples] = size(A.radar_frames);

% obj = pipeline(A.radar_frames, A.timestamps, 20, bins, T, 0.1, regexprep("720cm_100ms_tag_tx3_ddc_1_dac_max_1240_dac_min_1040", '_', ' '));
obj = pipeline(A.radar_frames, A.timestamps, range_to_cut, bins, T, 0.1, regexprep("pipeline_result_with_background", '_', ' '));


C = A.radar_frames - B.radar_frames;
obj = pipeline(C, A.timestamps, range_to_cut, bins, T, 0.1, regexprep("pipeline_result_after_background_subtraction", '_', ' '));

Tau = 65.84
tau = Tau/size(C,1);
tof = [tau:tau:size(C,1)*tau]*15;

figure;
imagesc([1:size(C,2)], tof(range_to_cut+1:end), abs(C(range_to_cut+1:end,:)));
colorbar;
title('amplitude with range versus timeframe with background subtraction')
xlabel('Timeframe Number');
ylabel('Range (cm)');

D = bsxfun(@minus, A.radar_frames, A.radar_frames(:,1));  % Subtract the first column from all other columns
figure;
imagesc([1:size(D,2)], tof(range_to_cut+1:end), abs(D(range_to_cut+1:end,:)));
colorbar;
title('amplitude with range versus timeframe after subtracting first frame')
xlabel('Timeframe Number');
ylabel('Range (cm)');
obj1 = pipeline(D, A.timestamps, range_to_cut, bins, T, 0.1, regexprep("pipeline result after subtracting first frame", '_', ' '));


