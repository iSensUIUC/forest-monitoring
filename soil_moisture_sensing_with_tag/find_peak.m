clear
clc
close all;

tag_calibration=27.73;%in cm
from_tag_to_soil_bottom=30;%in cm

range_to_cut=0

tx=[3];
ddc_en=1;
dac_max=1100;
dac_min=949;
%5 cm depth of soil
% names = ["5 cm depth, 33 cm soil height, 83 cm total height","5 cm depth, 48 cm soil height, 98 cm total height","5 cm depth, 64 cm soil height, 114 cm total height","5 cm depth, 79 cm soil height, 129 cm total height"];

%10 cm depth of soil
% names= ["10 cm depth, 76 cm soil height, 123 cm total height","10 cm depth, 65 cm soil height, 110 cm total height","10 cm depth, 52 cm soil height, 98 cm total height","10 cm depth, 35 cm soil height, 82 cm total height"];

% 9 cm depth of soil
names= ["9 cm depth, 80 cm soil height, 127 cm total height","9 cm depth, 65 cm soil height, 113 cm total height","9 cm depth, 50 cm soil height, 98 cm total height","9 cm depth, 38 cm soil height, 86 cm total height"];

% 2 cm depth of soil
% names= ["2 cm depth, 87 cm soil height, 127 cm total height","2 cm depth, 72 cm soil height, 113 cm total height","2 cm depth, 57 cm soil height, 98 cm total height","2 cm depth, 45 cm soil height, 86 cm total height"];

Tau = 65.84; %ns
T = Tau;

speed_of_light=14.9896229;%speed of light divided by 2 in cm/ns

% Prepare the figure for the plot
figure;
hold on;

% Initialize empty array
selR_array = [];

% Iterate over each file
for n = 1:length(names)
    name = names(n);
    for i=1:size(tx,2)
        file_name = name + " tx " + tx(i) + " ddc " + ddc_en + " dac max " + dac_max + " dac min " + dac_min + " ";
        if tx(i) == 3
            center_frequency = '7.29 GHz';  % '7.29 GHz' as a string
        elseif tx(i) == 4
            center_frequency = '8.748 GHz';  % '8.748 GHz' as a string
        end
        B = matfile(file_name);
        [bins, samples] = size(B.radar_frames);
        A = B.radar_frames;
        
        tau = Tau/size(A,1);
        tof = [tau:tau:size(A,1)*tau]*speed_of_light;
        range=[tau:tau:size(A,1)*tau]*speed_of_light;

        D = bsxfun(@minus, A, A(:,1));  % Subtract the first column from all other columns
        % remember to comment the plot in pipeline.m
        obj1 = pipeline(D, B.timestamps, 1, bins, T, 0.1, regexprep(name+" pipeline result after subtracting first frame "+center_frequency, '_', ' '));

        % plot normR2 from the pipeline object
        plot(tof, obj1.normR2)

        % Append obj1.selR to selR_array
%         selR_array = [selR_array; obj1.selR*tau*speed_of_light];
        selR_array = [selR_array; obj1.selR];

    end
end

% Set the title, labels and legend for the figure
title("Combined correlation with square wave"+center_frequency);
xlabel("Range (cm)");
ylabel("Autocorrelation value");
legend(names, 'Location', 'best');
hold off;

%indicate location of tag
% disp(selR_array);
disp("the distance of tag");
disp(selR_array*tau*speed_of_light);

selR_array=selR_array';
% selR_array=[19,22,25,27];

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
% disp(subtract_result);

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



% %%%%%
disp("from soil surface to tag is ");

disp(-selected_numbers);

% Add the i-th number in selR_array to the i-th number in selected_numbers
soilSurfaceLocations = selected_numbers + selR_array;

% Display the resulting array
disp("from radar to soil surface");
disp(soilSurfaceLocations'+"cm");

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

disp("averaged___from soil surface to tag without offset is ");
disp(-mean(selected_numbers)+"cm");

average_from_soil_surface_to_tag=-mean(selected_numbers);
disp("soil depth without offset is ");
disp((-(selected_numbers)-from_tag_to_soil_bottom));

soil_depth=average_from_soil_surface_to_tag-tag_calibration-from_tag_to_soil_bottom;
disp("soil depth is "+soil_depth+"cm");



