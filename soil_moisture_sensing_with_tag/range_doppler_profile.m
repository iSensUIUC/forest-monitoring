%This file contains:
% run range doppler for different files and save them

%the background subtaction method is always subtracting the first timeframe
clear
clc
close all;

range_to_cut=0

tx=[3];
ddc_en=1;
dac_max=1100;
dac_min=949;
names = ["5cm soil", "6cm soil", "7cm soil", "8cm soil", "9cm soil", "10cm soil", "11cm soil", "12cm soil","15cm soil"];
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
        
        Tau = 65.84
        T = 65.84; %ns
        
        speed_of_light=14.9896229;%speed of light divided by 2 in cm/ns
        tau = Tau/size(A,1);
        tof = [tau:tau:size(A,1)*tau];
        range=[tau:tau:size(A,1)*tau]*speed_of_light;
        

        
        
        D = bsxfun(@minus, A, A(:,1));  % Subtract the first column from all other columns

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
    
        fig=figure;
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

        if ~exist('plot_hh', 'dir')
           mkdir('plot_hh')
        end
        saveas(gcf, fullfile('plot_hh', plot_name+".png"));
    end
end