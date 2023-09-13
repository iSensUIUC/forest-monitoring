close all;
clear;
clc;
name = "name_test";


com_port = 'COM9'; % adjust for *your* COM port!
r = vcom_xep_radar_connector(com_port);
r.Open('X4');

fprintf('Connector version = %s\n', r.ConnectorVersion());

%DAC range
dac_min = 949;
dac_max = 1100;

%sampling parameter
%number of pulses integrated per DAC step	
pps = 30;
%iterations
iterations = 32;
new_num_samples = 800;

fprintf('Initial num_samples: %f', r.Item('num_samples'));
r.TryUpdateChip('num_samples', new_num_samples);
fprintf('Changed num_samples: %f', r.Item('num_samples'));
r.TryUpdateChip('iterations', iterations);

vars = r.ListVariables();
for i=1:length(vars)
    fprintf('%s %s\n', vars{i}, string(r.Item(vars{i})));
end

r.Item('prf')
frame_start = r.Item('frame_start');
frame_end = r.Item('frame_end');
fprintf('Frame area is %f to %f\n', frame_start, frame_end);