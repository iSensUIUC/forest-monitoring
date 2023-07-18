%This file contains:
%1. heatmap for amplitude vs range vs timeframe
%2. autocorrelation between radar signal and square wave function  versus time

clear
clc
close all;

range_to_cut=0

tx=[3];
ddc_en=1;
dac_max=1100;
dac_min=949;
name = "5 cm depth, 79 cm soil height, 129 cm total height";
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
    A = bsxfun(@minus, A, A(:,1));  % Subtract the first column from all other columns
    Tau = 65.84
    T = 65.84; %ns
    
    speed_of_light=14.9896229;%speed of light divided by 2 in cm/ns
    tau = Tau/size(A,1);
    tof = [tau:tau:size(A,1)*tau];
    range=[tau:tau:size(A,1)*tau]*speed_of_light;
    
    % Compute the average across columns
    A_avg = mean(A, 2);    

    fig=figure;
    plot(range(range_to_cut+1:end), abs(real(A_avg(range_to_cut+1:end))));
    title(name+" amplitude of signal averaged across timeframe");
    xlabel("Range (cm)");
    ylabel("Average Amplitude");
    set(fig, 'Position', [100, 50, 700, 400]) % [left, bottom, width, height]

end
