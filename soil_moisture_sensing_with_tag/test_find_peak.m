clear
clc
close all;
% Given subtract_result cell array
subtract_result = {[1, 2, 3, 4], [2, 3, 4, 5], [3, 4, 5, 6]};

% Initialize variables
n = numel(subtract_result);
combinations = cell(1, n);

% Generate all possible combinations
combinations = cell(1, n);
[combinations{1:n}] = ndgrid(subtract_result{1:n});
combinations = cellfun(@(x) x(:), combinations, 'UniformOutput', false);
combinations = cat(2, combinations{:});

% Calculate the standard deviation for each combination
std_values = std(combinations, 0, 2);

% Find the combination with the minimum standard deviation
[~, index] = min(std_values);
selected_numbers = combinations(index, :);

% Display the combination with minimum standard deviation
disp(selected_numbers);
