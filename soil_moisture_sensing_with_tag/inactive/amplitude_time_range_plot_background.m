clear
clc
close all;

file_name = 'background_3_ddc_1_dac_max_1100_dac_min_949';

A = matfile(file_name);
A = A.radar_frames;

Tau = 65.84
tau = Tau/size(A,1);
tof = [tau:tau:size(A,1)*tau]*15;
range_to_cut=11

figure;
imagesc([1:size(A,2)], tof(range_to_cut+1:end), abs(A(range_to_cut+1:end,:)));
colorbar;
title('amplitude with range versus timeframe before subtraction for background')
xlabel('Timeframe Number');
ylabel('Range (cm)');


figure
plot(tof(range_to_cut+1:end), abs(A(range_to_cut+1:end,1)))
title(extractBefore(file_name, 'soil'));
xlabel("Range (cm)")
ylabel("Amplitude")

% D = bsxfun(@minus, A, A(:,1));  % Subtract the first column from all other columns
% figure;
% imagesc([1:size(D,2)], tof(range_to_cut+1:end), abs(D(range_to_cut+1:end,:)));
% colorbar;
% title('amplitude with range versus timeframe after subtracting first frame for background')
% xlabel('Timeframe Number');
% ylabel('Range (cm)');