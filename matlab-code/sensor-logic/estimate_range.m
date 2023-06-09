clear;
clc;
close all;

t = [0:0.0429:65.84]; % in nano seconds
dt = 0.0429; % time of each range bin

vertical_front= matfile('front_metal_plate_vertical_empty_box.mat');
vertical_front = vertical_front.frame;
vertical_front(1,1:60) = 0; % remove direct signal
[~,vertical_front_bin] = max(vertical_front, [], 'all');

horizontal_front = matfile('metal_plate_90cm_empty_box.mat');
horizontal_front = horizontal_front.frame;
horizontal_front(1,1:60) = 0; % remove direct signal
[~,horizontal_front_bin] = max(horizontal_front, [], 'all');

vertical_emtpy = matfile('back_metal_plate_vertical_empty_box.mat');
vertical_emtpy = vertical_emtpy.frame;
vertical_emtpy(1,1:60) = 0; % remove direct signal
[~,vertical_emtpy_bin] = max(vertical_emtpy, [], 'all');

vertical_leaves = matfile('back_metal_plate_vertical_leaves_box.mat');
vertical_leaves = vertical_leaves.frame;
vertical_leaves(1,1:60) = 0; % remove direct signal
[~,vertical_leaves_bin] = max(vertical_leaves, [], 'all');

horizontal_empty = matfile('horizontal_emtpy_box.mat');
horizontal_empty = horizontal_empty.frame;
horizontal_empty(1,1:60) = 0; % remove direct signal
[~,horizontal_empty_bin] = max(horizontal_empty, [], 'all');

horizontal_leaves = matfile('horizontal_leaves_box.mat');
horizontal_leaves = horizontal_leaves.frame;
horizontal_leaves(1,1:60) = 0; % remove direct signal
[~,horizontal_leaves_bin] = max(horizontal_leaves, [], 'all')

horizontal_empty_tof = (horizontal_empty_bin - horizontal_front_bin)*dt;
horizontal_leaves_tof = (horizontal_leaves_bin - horizontal_front_bin)*dt;

vertical_empty_tof = (vertical_emtpy_bin - vertical_front_bin)*dt;
vertical_leaves_tof = (vertical_leaves_bin - vertical_front_bin)*dt;

vertical_empty_depth = (vertical_empty_tof*30)/2
vertical_leaves_depth = (vertical_leaves_tof*(30/sqrt(2.5)))/2
horizontal_empty_depth = (horizontal_empty_tof*(30))/2
horizontal_leaves_depth = (horizontal_leaves_tof*(30/sqrt(2.5)))/2

plot(vertical_emtpy);
hold on;
plot(vertical_leaves);
legend('empty box', 'box with leaves')
hold off;

