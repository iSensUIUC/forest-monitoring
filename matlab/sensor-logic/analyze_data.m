close all;
clear;
clc;

A = load('98cm_tag_100ms_3_ddc_0.mat');



T = 65.84; %ns
[bins, samples] = size(A.radar_frames);
tau = T/bins;
from = 100;
to = 400;

tof = [from*tau:tau:to*tau];

bscan_data = A.radar_frames(from:to,:); % ddc en
imagesc((1:samples), tof*15, abs(bscan_data))
figure;
plot(A.timestamps, (1:300))
xlabel('timestamps (seconds)')
ylabel('radar frame')
p = 30; % fps
    
obj = pipeline(bscan_data, tof, 0.1, p, A.timestamps, '98cm tag 100ms')

% A = load('1m_tag_100ms_3_ddc_1.mat');
% 
% 
% radar_frames = A.radar_frames(10:100,:); % ddc en
% imagesc(abs(radar_frames))
% figure;
% plot(A.timestamps, (1:300))
% xlabel('timestamps (HHMMSS)')
% ylabel('radar frame')
% 
% obj = pipeline(radar_frames, 0.1, 10, A.timestamps, '1m tag 100ms')
figure
tag = normalize(bscan_data(obj.selR,:));
sum(tag(:) >= 0.5)
plot(tag)

figure
plot(normalize(bscan_data(11,:)))
title("bin 11 SelR 0.0137")

figure
plot(normalize(bscan_data(68,:)))
title("bin 68 SelR 0.0132")

figure
plot(normalize(bscan_data(132,:)))
title("bin 132 SelR 0.0137")


figure
plot(normalize(bscan_data(185,:)))
title("bin 185 SelR 0.0131")

figure
plot(normalize(bscan_data(obj.selR,:)))
title("bin tag detected")

distance_detected = (from + obj.selR)*tau*15