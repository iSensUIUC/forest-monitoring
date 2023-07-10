% Initial settings
clear
clc
close all;

range_to_cut=1

tx=[3];
ddc_en=1;
dac_max=1100;
dac_min=949;
names = ["5cm soil", "6cm soil", "7cm soil", "8cm soil", "9cm soil", "10cm soil", "11cm soil", "12cm soil","15cm soil"];

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

    end
end

% Set the title, labels and legend for the figure
title("Combined correlation with square wave"+center_frequency);
xlabel("Range (cm)");
ylabel("Autocorrelation value");
legend(names, 'Location', 'best');
hold off;
