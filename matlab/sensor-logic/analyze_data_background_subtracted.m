close all;
clear;
clc;

T = 65.84; %ns

% myDir = uigetdir; %gets directory
% dacDir = "C:\Users\smartlab\Documents\modules-main\modules-main\matlab\DAC_ranges\pipeline\720cm";
% myFiles = dir(fullfile(dacDir,'*.mat')); %gets all wav files in struct
% vals = zeros(length(myFiles));
% for k = 1:length(myFiles)
%   baseFileName = myFiles(k).name;
%   fullFileName = fullfile(dacDir, baseFileName);
%   fprintf(1, 'Now reading %s\n', fullFileName);
%   A = load(fullFileName);
%   obj = pipeline(A.radar_frames, T, 0.1, A.timestamps, regexprep(baseFileName, '_', ' '));
%   vals(k) = obj.selR;
% end
% 
% figure
% plot(vals)
% xlabel("dac ranges")
% ylabel("selR")
% title("selR across different DAC ranges")

T = 65.84; %ns

radar_frames = "C:\Users\smartlab\Documents\modules-main\modules-main\matlab\DAC_ranges\pipeline\720cm\720cm_100ms_tag_tx3_ddc_1_dac_max_1240_dac_min_1040.mat";
radar_frame_background = "C:\Users\smartlab\Documents\modules-main\modules-main\matlab\DAC_ranges\pipeline\720cm\background\background_720cm_100ms_tag_tx3_ddc_1_dac_max_1240_dac_min_1040.mat";

A = load(radar_frames);
B = load(radar_frame_background);


[bins, samples] = size(A.radar_frames);

obj = pipeline(A.radar_frames, A.timestamps, 20, bins, T, 0.1, regexprep("720cm_100ms_tag_tx3_ddc_1_dac_max_1240_dac_min_1040", '_', ' '));


C = A.radar_frames - B.radar_frame;
obj1 = pipeline(C, A.timestamps, 20, bins, T, 0.1, regexprep("720cm_100ms_tag_tx3_ddc_1_dac_max_1240_dac_min_1040", '_', ' '));