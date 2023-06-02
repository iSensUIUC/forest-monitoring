clear
clc
close all;

file_names = ["aluminum_plate_104cm_no_soil_3_ddc_1_dac_max_1100_dac_min_949" "white_plate_104cm_no_soil_3_ddc_1_dac_max_1100_dac_min_949"];

for i=1 : length(file_names)
    A = matfile(file_names(i));
    A = A.radar_frames;
    
    Tau = 65.84;
    tau = Tau/size(A,1);
    tof = [1*tau:tau:size(A,1)*tau];
    x = tof;
    xx = tau:tau/10:size(A,1)*tau;
    y = abs(A(:,1));
    yy = spline(x, y, xx);
    
    TF = islocalmax(yy);
    
    % figure
    % colorbar;
    % imagesc(abs(A));
    if i == 1
        figure
    end
    subplot(2,1,i)
    % plot(tof.*15, abs(A(:,1)))
    plot(xx.*15, yy, xx(TF).*15, yy(TF), 'r*')
%     plot(xx.*15, yy, xx(TF).*15, yy(TF), 'r*', x.*15, y, 'go')
    title(extractBefore(file_names(i), '3_'));
    xlabel("Range (cm)")
    ylabel("Amplitude")
    xlim([0 200])
    ylim([0 12])
    legend('interpolated data','local maxima')
%     legend('interpolated data','local maxima', 'original data')
end

% file_name = '82cm_2_full_bottles_water_soil_84cm_plate_3_ddc_1_dac_max_1100_dac_min_949.mat';
% 
% A = matfile(file_name);
% A = A.radar_frames;
% 
% Tau = 65.84
% tau = Tau/size(A,1);
% tof = [1*tau:tau:size(A,1)*tau];
% 
% % figure
% % colorbar;
% % imagesc(abs(A));
% 
% % figure
% subplot(2,1,2)
% plot(tof.*15, abs(A(:,1)))
% title(extractBefore(file_name, '3_'));
% xlabel("Range (cm)")
% ylabel("Amplitude")
% xlim([0 200])
% ylim([0 12])
% 
% 
% file_name = '82cm_3_full_bottles_water_soil_84cm_plate_3_ddc_1_dac_max_1100_dac_min_949.mat';
% 
% A = matfile(file_name);
% A = A.radar_frames;
% 
% Tau = 65.84
% tau = Tau/size(A,1);
% tof = [1*tau:tau:size(A,1)*tau];
% 
% % figure
% % colorbar;
% % imagesc(abs(A));
% 
% % figure
% subplot(2,2,3)
% plot(tof.*15, abs(A(:,1)))
% title(extractBefore(file_name, 'soil'));
% xlabel("Range (cm)")
% ylabel("Amplitude")
% xlim([0 200])
% ylim([0 12])
% 
% 
% file_name = '82cm_4_full_bottles_water_soil_84cm_plate_3_ddc_1_dac_max_1100_dac_min_949.mat';
% 
% A = matfile(file_name);
% A = A.radar_frames;
% 
% Tau = 65.84
% tau = Tau/size(A,1);
% tof = [1*tau:tau:size(A,1)*tau];
% 
% % figure
% % colorbar;
% % imagesc(abs(A));
% 
% % figure
% subplot(2,2,4)
% plot(tof.*15, abs(A(:,1)))
% title(extractBefore(file_name, 'soil'));
% xlabel("Range (cm)")
% ylabel("Amplitude")
% xlim([0 200])
% ylim([0 10])