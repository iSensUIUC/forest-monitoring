%This file contains:
%1. heatmap for amplitude vs range vs timeframe
%2. autocorrelation between radar signal and square wave function  versus time

%the background subtaction method is always subtracting the first timeframe
clear
clc
close all;
range_to_cut = 0;

file_name = "VNA_data.mat";

load(file_name);
D = pdp_array';
bins = length(vRange_array);

fig=figure;
imagesc([1:size(D,2)], vRange_array, abs((D(range_to_cut+1:end,:))));
colorbar;
title([file_name ' amplitude with range versus timeframe after subtracting first frame '])
xlabel('Timeframe Number');
ylabel('Range (m)');
set(fig, 'Position', [100, 50, 700, 400]) % [left, bottom, width, height]
% % Save the plot to the 'plot' folder
% if ~exist('plot', 'dir')
%    mkdir('plot')
% end
% saveas(gcf, fullfile('plot', file_name + "heatmap after background subtraction.png"));

obj1 = pipelien_for_VNA(D, time_array, vRange_array, range_to_cut+1, bins, 1, (file_name));


