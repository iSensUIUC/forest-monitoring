close all;
clear;
clc;
name = "two frequency";
% name = "background";



com_port = 'COM4'; % adjust for *your* COM port!
r = vcom_xep_radar_connector(com_port);
r.Open('X4');

fprintf('Connector version = %s\n', r.ConnectorVersion());

%DAC range
dac_min = 949;
dac_max = 1100;

%sampling parameter
%number of pulses integrated per DAC step	
pps = 50;
%iterations
iterations = 32;

r.TryUpdateChip('pps', pps);
r.TryUpdateChip('iterations', iterations);


r.Item('prf')
frame_start = r.Item('frame_start');
frame_end = r.Item('frame_end');
fprintf('Frame area is %f to %f\n', frame_start, frame_end);


max_fps = (15187500/(iterations*pps*(dac_max-dac_min+1)))*0.95;

% fps = 35; % we get around 35 fps
% t = 12; % in seconds

duration = 128;

% distance = "background_140cm"
tag = "100ms"

% tx = [3];   
tx = [3 4];
% tx = [4];   

ddc_en = [0 1];
% dac_vals = [20z47 1896; 1895 1744; 1743 1592; 1591 1440; 1439 1288; 1287 1136; 1135 984; 983 832; 831 680; 679 528; 527 376; 375 224; 223 72; 2047 0; 2047 1896; 1895 1744; 1743 1592; 1591 1440; 1439 1288; 1287 1136; 1135 984; 983 832; 831 680; 679 528; 527 376; 375 224; 223 72; 2047 0];
dac_vals = [1100 949;];

% dac_vals = readtable('dac_vals.csv');
% dac_vals = dac_vals{:,:};

for p=1:size(dac_vals, 1)
    dac_val = dac_vals(p,:);
    dac_min = dac_val(2);
    dac_max = dac_val(1);
    r.TryUpdateChip('dac_min', dac_min);
    r.TryUpdateChip('dac_max', dac_max);
    for i=1:size(tx,2)
       %radar center frequency, Tx3 = 7.29 GHz, Tx4 = 8.748 GHz
       r.TryUpdateChip('tx_region', tx(i));
       for j=1:size(ddc_en,2)
           %digital down conversion enable for IQ data
           r.TryUpdateChip('ddc_en', ddc_en(j));
           %number of samples per frame
           bins = r.Item('num_samples');
           radar_frames = zeros(bins, duration);
           timestamps = zeros(duration,1);
           for k=1:duration
               %frame = r.GetFrameRawDouble;
%                frame = abs(r.GetFrameNormalizedDouble);
               frame = (r.GetFrameNormalizedDouble);
               T = datestr(now, 'HH:MM:SS.FFF');
               T = str2double(split(T, ':'));
               timestamps(k,:) = T(1)*3600.0 + T(2)*60.0 + T(3); % did not test for edge cases like data collection at midnight
               radar_frames(:,k) = frame;
           end
           file_name = name + " tx " + tx(i) + " ddc " + ddc_en(j) + " dac max " + dac_max + " dac min " + dac_min + ".mat";

           save(file_name, 'radar_frames', 'timestamps', 'dac_val');
       end 
    end
end
beep
r.Close();