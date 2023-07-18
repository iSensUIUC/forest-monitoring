clear
clc
close all;

range_to_cut=0

tx=[3];
ddc_en=1;
dac_max=1100;
dac_min=949;
names = ["5 cm depth, 33 cm soil height, 83 cm total height","5 cm depth, 48 cm soil height, 98 cm total height","5 cm depth, 64 cm soil height, 114 cm total height","5 cm depth, 79 cm soil height, 129 cm total height"];

selR_array=[19,22,25,27];

% initialize the peakLocations array
peakLocations = cell(length(names), 1);

for n = 1:length(names)
    name=names(n);
    for i=1:size(tx,2)
        file_name = name + " tx " + tx(i) + " ddc " + ddc_en + " dac max " + dac_max + " dac min " + dac_min + " ";

        B = matfile(file_name);
        [bins, samples] = size(B.radar_frames);
        
        A = B.radar_frames;
        A = bsxfun(@minus, A, A(:,1));  % Subtract the first column from all other columns
        Tau = 65.84;
        T = 65.84; %ns
        
        speed_of_light=14.9896229;%speed of light divided by 2 in cm/ns
        tau = Tau/size(A,1);
        tof = [tau:tau:size(A,1)*tau];
        range=[tau:tau:size(A,1)*tau]*speed_of_light;
        
        % Compute the average across columns
        A_avg = mean(A, 2);            
       
        % Find the peak locations
        [pks,locs] = findpeaks(abs(real(A_avg(range_to_cut+1:end))));
        locs = locs(locs < selR_array(n));

        % Store the peak locations in the n-th row of the peakLocations array
        peakLocations{n} = locs;
    end
end


% Multiply elements of selR_array by tau*speed_of_light
for i = 1:length(selR_array)
    selR_array(i) = selR_array(i) * tau * speed_of_light;
end

% Multiply elements of each cell in peakLocations by tau*speed_of_light
for i = 1:length(peakLocations)
    peakLocations{i} = peakLocations{i} * tau * speed_of_light;
end

% Display each element of peakLocations
for i = 1:length(peakLocations)
    disp(['Peak Locations for iteration ', num2str(i), ':'])
    disp(peakLocations{i})
end
% Initialize cell array to store subtracted results
subtract_result = cell(length(names), 1);

% Loop through each experiment
for i = 1:length(names)
    % Subtract i-th element of selR_array from each element of i-th array of peakLocations
    subtract_result{i} = peakLocations{i} - selR_array(i);
end

disp(subtract_result);

%%%%%%
%find the numbers that form a line with slope 0

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



%%%%%
disp(selected_numbers);

% Add the i-th number in selR_array to the i-th number in selected_numbers
soilSurfaceLocations = selected_numbers + selR_array;

% Display the resulting array
disp(soilSurfaceLocations);

fig=figure;
hold on;

colors = lines(length(names)); % Generate a color map with as many colors as names
h = zeros(length(names), 1); % Initialize an array of handles for the legend

for n = 1:length(names)
    name=names(n);
    for i=1:size(tx,2)
        file_name = name + " tx " + tx(i) + " ddc " + ddc_en + " dac max " + dac_max + " dac min " + dac_min + " ";
        B = matfile(file_name);
        [bins, samples] = size(B.radar_frames);
        
        A = B.radar_frames;
        A = bsxfun(@minus, A, A(:,1));  
        Tau = 65.84;
        T = 65.84; %ns
        
        speed_of_light=14.9896229;
        tau = Tau/size(A,1);
        tof = [tau:tau:size(A,1)*tau];
        range=[tau:tau:size(A,1)*tau]*speed_of_light;
        
        A_avg = mean(A, 2);            

        % Save the handle for the line plot
        h(n) = plot(range(range_to_cut+1:end), abs(real(A_avg(range_to_cut+1:end))));
        
        % Plot the circle without saving the handle
        plot(soilSurfaceLocations(n), abs(real(A_avg(round(soilSurfaceLocations(n)/(tau*speed_of_light))))), 'o', 'MarkerSize', 10, 'Color', colors(n,:));
    end
end

title(" amplitude of signal averaged across timeframe");
xlabel("Range (cm)");
ylabel("Average Amplitude");
legend(h, names, 'Location', 'best');  % Use the handles for the legend
hold off;





