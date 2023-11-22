classdef pipeline < handle

properties
    finalVal = 0
    selR = 0
    normR2
end


methods
    function obj = pipeline(bscan_data, timestamps, from, to, Tau, switchPer, plotTitle)
                   
        [bins,numCols] = size(bscan_data);
        NFFTVel=512;%fft bin number
        
        modDuty=50; %duty cycle
        modF=1./(2*(switchPer)); %tag modulation frequency
        FrmMeasSiz= numCols; % size of the the vector 
       
       
        expDopFinal=zeros(1,NFFTVel);
        sq_wav=square(2*pi*(modF.').*timestamps,modDuty); %create a square function based on the modulation frequency
        expdopt=abs(fft(sq_wav,NFFTVel,1)); %sinc function of the modulation 
        
        t = timestamps(1);
        dur = ceil(timestamps(end) - timestamps(1));
        T = zeros(dur, 1);
        i = 1;
        while(t < timestamps(end))
             a = (t > timestamps & t <= (timestamps + 1.0));
             T(i) = sum(a);
             t = t + 1.0;
             i = i + 1;
        end    
        T = T(2:end,:); 
        fps = mean(T);
        
        tau = Tau/bins;
        tof = [from*tau:tau:to*tau];

        tagFFT=round(((1/fps)*NFFTVel)*modF); %the first fft bin that tag sinc harmonic shows up
        ind=1:2:round(NFFTVel/(tagFFT*2)); %finding the harmonic of the tag based on the modulation frequency
        
        % only keep the harmonics of the sync function in the template 
        fInd=tagFFT*ind+1;
        fIndL=NFFTVel-tagFFT*ind+1;
        ffInd=unique(sort([fInd,fIndL]));
        ffInd=ffInd(ffInd<NFFTVel & ffInd>1 );
        expDopFinal(ffInd)=expdopt(ffInd);
        
        
        %normalize the template
        expDopFinal=normalize(expDopFinal,2,'range');
        
        H = fft(bscan_data(from:to,:), NFFTVel, 2);

        %normalize the signal
        sig=squeeze(abs(H));
        normA = sig - min(sig(:));
        normSig = normA ./ max(normA(:));
        
        % calculate the autocorelation
        normR2=abs(sum(abs(normSig).*repmat(abs(expDopFinal),size(normSig,1),1),2));
        %the autocorrelation results

        fig=figure;
        plot(tof.*14.9896, normR2) % c = 14.9896 cm/ns
        title(plotTitle + " correlation with square wave");
        xlabel("Range (cm)")
        set(fig, 'Position', [100, 50, 700, 400]) % [left, bottom, width, height]
        % Save the plot to the 'plot' folder
        if ~exist('plot', 'dir')
           mkdir('plot')
        end
        saveas(gcf, fullfile('plot', plotTitle + " correlation with square wave.png"));


        %selR hold the range bin with max correlation
        [obj.finalVal, obj.selR] = max(normR2);
        obj.normR2 = normR2;
    end

end

end

    