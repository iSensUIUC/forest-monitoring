clear
clc
close all;

range_to_cut=0

tx=[3];
ddc_en=1;
dac_max=1100;
dac_min=949;
names = ["5 cm depth, 33 cm soil height, 83 cm total height","5 cm depth, 48 cm soil height, 98 cm total height","5 cm depth, 64 cm soil height, 114 cm total height","5 cm depth, 79 cm soil height, 129 cm total height"];

fig=figure;  % Initialize a new figure


selR_array=[19,22,25,27];
soilSurfaceLocations=[6,8,12,15]

for i=1:size(names,2)
    name = names(i);
    file_name = name + " tx " + tx + " ddc " + ddc_en + " dac max " + dac_max + " dac min " + dac_min + " ";
    center_frequency = '7.29 GHz';  % '7.29 GHz' as a string

    B = matfile(file_name);
    [bins, samples] = size(B.radar_frames);

    A = B.radar_frames;

    Tau = 65.84;
    speed_of_light=14.9896229;%speed of light divided by 2 in cm/ns
    tau = Tau/size(A,1);
    tof = [tau:tau:size(A,1)*tau];
    range=[tau:tau:size(A,1)*tau]*speed_of_light;

    D = bsxfun(@minus, A, A(:,1));  % Subtract the first column from all other columns
    subplot(1, size(names,2), i); % Arrange subplots horizontally
    imagesc([1:size(D,2)], range(range_to_cut+1:end), abs((D(range_to_cut+1:end,:))));
    colorbar;
    name_parts = strsplit(name, ", ");
    title(name_parts, 'FontSize', 10);
    xlabel('Timeframe Number');
    ylabel('Range (cm)');
    selR_index = selR_array(i);
soilSurface_index = soilSurfaceLocations(i);

    hold on;
    % Plotting selR_index as a red line
    plot([1:size(D,2)], range(selR_index)*ones(1, size(D,2)), 'r', 'LineWidth', 1);
    
    % Plotting soilSurface_index as a blue line
    plot([1:size(D,2)], range(soilSurface_index)*ones(1, size(D,2)), 'g', 'LineWidth', 1);
    hold off;
    

end

    set(fig, 'Position', [100, 50, 1500, 600]) % [left, bottom, width, height]

    % Add legend
% Add legend
legend('tag location', 'soil surface', 'Location', 'northeast');
