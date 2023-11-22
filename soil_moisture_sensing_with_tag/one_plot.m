% Initial settings
clear
clc
close all;

range_to_cut=1

tx=[3];
ddc_en=1;
dac_max=1100;
dac_min=949;
% names = ["oct28_5cm_soil_0cm_lateral_61pt25inch_height","oct28_5cm_soil_15cm_lateral_61pt25inch_height","oct28_5cm_soil_30cm_lateral_61pt25inch_height","oct28_5cm_soil_45cm_lateral_61pt25inch_height","oct28_5cm_soil_60cm_lateral_61pt25inch_height"];
% names = ["oct28_9cm_soil_0cm_lateral_61pt25inch_height","oct28_9cm_soil_15cm_lateral_61pt25inch_height","oct28_9cm_soil_30cm_lateral_61pt25inch_height","oct28_9cm_soil_45cm_lateral_61pt25inch_height","oct28_9cm_soil_60cm_lateral_61pt25inch_height"];
% names = ["oct28_no_soil_0m_lateral_61pt25_height","oct28_no_soil_15cm_lateral_61pt25inch_height","oct28_no_soil_30cm_lateral_61pt25inch_height","oct28_no_soil_45cm_lateral_61pt25inch_height","oct28_no_soil_60cm_lateral_61pt25inch_height"];

% names = ["oct30 without plant tag buried 15cm soil 0cm lateral displacement 151p8 cm height", "oct30 without plant tag buried 9cm soil 0cm lateral displacement 151p8 cm height","oct30 without plant tag buried 5cm soil 0cm lateral displacement 151p8 cm height","oct30 without plant tag buried 0cm soil 0cm lateral displacement 151p8 cm height"]
% names = ["oct28 with plant 0cm lateral 55p8 inch height","oct28 with plant 15cm lateral 55p8 inch height","oct28 with plant 30cm lateral 55p8 inch height","oct28 with plant 45cm lateral 55p8 inch height","oct28 with plant 60cm lateral 55p8 inch height"];
% names = ["oct30 without plant 15cm wood 0cm lateral 53 inch height", "oct30 without plant 12cm wood 0cm lateral 53 inch height","oct30 without plant 8cm wood 0cm lateral 53 inch height","oct30 without plant 3cm wood 0cm lateral 53 inch height","oct30 without plant no wood 0cm lateral 53 inch height"]

names = ["oct28 with plant with leaves front2 0cm lateral 55p8 inch height","oct28 with plant without leaves front2 0cm lateral 55p8 inch height"]

% names= ["oct30 with plant 3cm wood 0cm lateral 53 inch height","oct30 with plant no wood 0cm lateral 53 inch height"]
% names = ["oct28 without plant 0cm lateral 55p8 inch height","oct28 without plant 15cm lateral 55p8 inch height","oct28 without plant 30cm lateral 55p8 inch height","oct28 without plant 45cm lateral 55p8 inch height","oct28 without plant 60cm lateral 55p8 inch height"];

Tau = 65.84; %ns
T = Tau;

speed_of_light=14.9896229;%speed of light divided by 2 in cm/ns

% Prepare the figure for the plot
figure;
hold on;

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
        obj1.selR

    end
end

% Set the title, labels and legend for the figure
title("Combined correlation with square wave"+center_frequency);
xlabel("Range (cm)");
ylabel("Autocorrelation value");

for i = 1:numel(names)
    % Replace "_" with " " using strrep and store the result in modifiedStrArray
    names(i) = strrep(names(i), '_', ' ');
    names(i) = strrep(names(i), '55p8 inch', '141.7 cm');

end

legend(names, 'Location', 'best');
hold off;
