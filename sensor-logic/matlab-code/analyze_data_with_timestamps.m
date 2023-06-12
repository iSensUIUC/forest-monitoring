close all;
clear;
clc;


A = load('140cm_100ms_tag_tx3_ddc_1_dac_max_1135_dac_min_984.mat'); 
T = 65.84; % when PRF = 15.6, T = 65.84ns)
[bins,numCols] = size(A.radar_frames);

a = A.radar_frames ;


a = pipeline(a(1:bins,:), A.timestamps(), 1,bins, T, 0.1, 'downconverted DAC: (1135 984)');

