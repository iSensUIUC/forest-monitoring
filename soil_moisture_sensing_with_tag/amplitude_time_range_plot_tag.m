%This file contains:
%1. heatmap for amplitude vs range vs timeframe
%2. autocorrelation between radar signal and square wave function  versus time

%the background subtaction method is always subtracting the first timeframe
clear
clc
close all;

range_to_cut=0

tx=[3];
ddc_en=1;
dac_max=1100;
dac_min=949;
name = "no soil";
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
    
    Tau = 65.84
    T = 65.84; %ns
    
    speed_of_light=14.9896229;%speed of light divided by 2 in cm/ns
    tau = Tau/size(A,1);
    tof = [tau:tau:size(A,1)*tau];
    range=[tau:tau:size(A,1)*tau]*speed_of_light;
    
    %plot without background subtraction
%     figure;
%     imagesc([1:size(A,2)], range(range_to_cut+1:end), abs(A(range_to_cut+1:end,:)));
%     colorbar;
%     title(['with tag amplitude with range versus timeframe before subtraction ' center_frequency])
%     xlabel('Timeframe Number');
%     ylabel('Range (cm)');

    % do pipeline before background subtraction
    % obj = pipeline(B.radar_frames, B.timestamps, range_to_cut, bins, T, 0.1, regexprep("pipeline_result_with_background", '_', ' '));
    
    
    D = bsxfun(@minus, A, A(:,1));  % Subtract the first column from all other columns
    fig=figure;
    imagesc([1:size(D,2)], range(range_to_cut+1:end), abs((D(range_to_cut+1:end,:))));
    colorbar;
    title([name ' amplitude with range versus timeframe after subtracting first frame ' center_frequency])
    xlabel('Timeframe Number');
    ylabel('Range (cm)');
    set(fig, 'Position', [100, 50, 700, 400]) % [left, bottom, width, height]
    % Save the plot to the 'plot' folder
    if ~exist('plot', 'dir')
       mkdir('plot')
    end
    saveas(gcf, fullfile('plot', file_name + "heatmap after background subtraction.png"));
    
%     obj1 = pipeline(D, B.timestamps, range_to_cut+1, bins, T, 0.1, regexprep(name+" pipeline result after subtracting first frame "+center_frequency, '_', ' '));
    
    bscan_data=abs(D);
    from=range_to_cut+1;
    to=bins;
    NFFTVel=512;
    H = fft(bscan_data(from:to,:), NFFTVel, 2);

    figure;
    speed_of_light=14.9896229;%speed of light divided by 2 in cm/ns
    
    Fs = 32;  % Tau is converted from ns to s
%     frequencies = (-Fs/2 : Fs/NFFTVel : Fs/2-Fs/NFFTVel);
%     imagesc(frequencies, range, fftshift(abs(H)));
    frequencies = (0 : Fs/NFFTVel : Fs/2-Fs/NFFTVel);
    H_positive = H(:,1:NFFTVel/2);  % This gets the first half of H, corresponding to the positive frequencies
    imagesc(frequencies, range, abs(H_positive));

    plot_name = replace(file_name, "_", " ");  % replace spaces with underscores
    colorbar;
    plot_name=plot_name+" range doppler profile "+center_frequency;

    title(plot_name);
    xlabel("Frequency (Hz)");
    ylabel("Range (cm)");
    set(fig, 'Position', [100, 50, 800, 400]) % [left, bottom, width, height]
    if ~exist('plot', 'dir')
       mkdir('plot')
    end
    saveas(gcf, fullfile('plot', plot_name+".png"));


end
