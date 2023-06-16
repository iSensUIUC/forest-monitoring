% Define the file names
no_background_name = "10 cm sand with metal plate as reflector.mat";

name = no_background_name;
background_name= "background for "+name;
background_substracted="background subtraction result for "+name;
file_names = [name,background_name,background_substracted];

% Define the directory
dir_name = 'csv file';

% Check if the directory exists, if not, create it
if ~exist(dir_name, 'dir')
   mkdir(dir_name);
end

% Loop over all files
for i = 1:length(file_names)
    % Load the .mat file
    name = file_names(i);
    load(name);

    % Check the variables in the workspace
    whos

    % Keep only the real part of radar_frames
    radar_frames = real(radar_frames);

    % Take the average across columns
    avg_radar_frames = mean(radar_frames, 2);

    % Define the output file name
    [~, name, ~] = fileparts(name); 
    output_name = fullfile(dir_name, name + ".csv");

    % Export avg_radar_frames as a .csv file
    writematrix(avg_radar_frames, output_name);
end




