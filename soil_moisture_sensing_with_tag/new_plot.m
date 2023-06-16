clear
clc
close all;

file_name = 'new_3_ddc_1_dac_max_1100_dac_min_949.mat';

A = matfile(file_name);
A = A.radar_frames;

Tau = 65.84
tau = Tau/size(A,1);
tof = [tau:tau:size(A,1)*tau]*15;

figure;
imagesc([1:size(A,2)], tof, abs(A));
colorbar;
xlabel('Timeframe Number');
ylabel('Range (cm)');


figure
plot(tof, abs(A(:,1)))
title(extractBefore(file_name, 'soil'));
xlabel("Range (cm)")
ylabel("Amplitude")
