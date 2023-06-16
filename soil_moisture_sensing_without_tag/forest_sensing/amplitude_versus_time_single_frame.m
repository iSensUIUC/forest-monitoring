clear
clc
close all;

%1 for with obj; 0 for background
obj=0
no_background_name = "10 cm sand with metal plate as reflector.mat";


range_to_cut=0
background_name= "background for "+no_background_name;


% Check the value of no_background_name
if obj == 1
    name = no_background_name;
elseif obj == 0
    name = background_name;
else
    disp('Invalid value for no_background_name');
end

B = matfile(name);
[bins, samples] = size(B.radar_frames);

A = real(B.radar_frames);

Tau = 65.84;
T = 65.84; %ns

tau = Tau/size(A,1);
range = [tau:tau:size(A,1)*tau]*15;

% Compute the average across columns
A_avg = mean(A, 2);

figure
plot(range(range_to_cut+1:end), A_avg(range_to_cut+1:end))
title(name);
xlabel("Range (cm)")
ylabel("Average Amplitude")
% Prepare the name variable for inclusion in the filename
name_no_spaces = replace(name, " ", "_");  % replace spaces with underscores
name_no_ext = extractBefore(name_no_spaces, ".");  % remove extension

% Save the plot to the 'plot' folder
if ~exist('plot', 'dir')
   mkdir('plot')
end
saveas(gcf, fullfile('plot', name_no_ext + "_Range_Plot.png"))

tof=[tau:tau:size(A,1)*tau]
figure
plot(tof(range_to_cut+1:end), A_avg(range_to_cut+1:end))
title(name);
xlabel("time of flight (ns)")
ylabel("Average Amplitude")
% Save the plot to the 'plot' folder
if ~exist('plot', 'dir')
   mkdir('plot')
end
saveas(gcf, fullfile('plot', name_no_ext + "_TOF_Plot.png"))
