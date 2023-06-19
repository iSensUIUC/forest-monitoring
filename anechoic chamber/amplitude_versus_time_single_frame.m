clear
clc
close all;

file_name = 'tag_3_ddc_1_dac_max_1100_dac_min_949';

B = matfile(file_name);
[bins, samples] = size(B.radar_frames);

A = B.radar_frames;

Tau = 65.84;
T = 65.84; %ns

tau = Tau/size(A,1);
range = [tau:tau:size(A,1)*tau]*15;
range_to_cut=0

figure;
imagesc([1:size(A,2)], range(range_to_cut+1:end), abs(A(range_to_cut+1:end,:)));
colorbar;
title('with tag amplitude with range versus timeframe before subtraction')
xlabel('Timeframe Number');
ylabel('Range (cm)');

tof=[tau:tau:size(A,1)*tau]
figure
plot(tof(range_to_cut+1:end), (A(range_to_cut+1:end,1)))
title(extractBefore(file_name, 'soil'));
xlabel("time of flight (ns)")
ylabel("Amplitude")

% obj = pipeline(B.radar_frames, B.timestamps, range_to_cut, bins, T, 0.1, regexprep("pipeline_result_with_background", '_', ' '));
% 
% 
% D = bsxfun(@minus, A, A(:,1));  % Subtract the first column from all other columns
% figure;
% imagesc([1:size(D,2)], tof(range_to_cut+1:end), abs(D(range_to_cut+1:end,:)));
% colorbar;
% title('amplitude with range versus timeframe after subtracting first frame')
% xlabel('Timeframe Number');
% ylabel('Range (cm)');
% 
% obj1 = pipeline(D, B.timestamps, range_to_cut, bins, T, 0.1, regexprep("pipeline result after subtracting first frame", '_', ' '));
