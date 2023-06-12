import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

from numpy import genfromtxt


class pipeline:

    def __init__(self):

        self.finalVal = 0
        self.selR = 0
        self.normR2 = None

    def detect_tag(self, bscan_data, timestamps, from_, to, Tau, switchPer, plotTitle):
        bins, numCols = bscan_data.shape
        print(bins)
        print(numCols)
        NFFTVel = 512  # fft bin number
        modDuty = 50  # duty cycle
        modF = 1./(2*(switchPer))  # tag modulation frequency
        FrmMeasSiz = numCols  # size of the the vector

        expDopFinal = np.zeros((1, NFFTVel))
        sq_wav = np.squeeze(np.array([signal.square(2 * np.pi * modF * timestamps[i], modDuty)
                                      for i in range(len(timestamps))]))
        expdopt = np.abs(np.fft.fft(sq_wav, NFFTVel, axis=0))  # sinc function of the modulation
        timestamps = timestamps - timestamps[0] # convert from time since epoch to relative time
        timestamps = timestamps/1.0e9 # convert to seconds
        print(timestamps)
        t = 0
        dur = np.ceil(timestamps[-1] - timestamps[0])
        dur = int(dur/1.0e9)
        print(dur)
        T = np.zeros((dur, 1))
        i = 0
        # print("while loop")
        #while t < timestamps[-1]:
        #    a = np.logical_and(t >= timestamps, t < (timestamps + 1.0))
        #    print(a)
        #    T[i] = np.sum(a.astype(int))
        #    t += 1.0
        #    i += 1
        #print(T)
        #T = T[1:, :]
        #fps = np.mean(T)
        fps = 40.0
        tau = Tau / bins
        tof = np.arange(from_, to+1) * tau
        print("===============================")
        print(fps)
        print(NFFTVel)
        print(modF)
        print("===============================")
        tagFFT = np.round(((1 / fps) * NFFTVel) * modF)  # the first fft bin that tag sinc harmonic shows up
        ind = np.arange(1, round(NFFTVel / (tagFFT * 2)), 2)  # finding the harmonic of the tag based on the modulation frequency

        # only keep the harmonics of the sync function in the template
        fInd = tagFFT * ind + 1
        fIndL = NFFTVel - tagFFT * ind + 1
        ffInd = np.unique(np.concatenate([fInd, fIndL]))
        ffInd = ffInd[(ffInd < NFFTVel) & (ffInd > 1)]
        expDopFinal[:, ffInd] = expdopt[:, ffInd]

        # normalize the template
        expDopFinal = (expDopFinal - np.min(expDopFinal)) / (np.max(expDopFinal) - np.min(expDopFinal))

        H = np.fft.fft(bscan_data[from_:to+1, :], NFFTVel, axis=1)
        # plt.imshow(np.abs(H), aspect='auto')
        # plt.show()

        # normalize the signal
        sig = np.abs(H)
        normA = sig - np.min(sig)
        normSig = normA / np.max(normA)

        # calculate the autocorrelation
        normR2 = np.abs(np.sum(normSig * np.tile(expDopFinal, (normSig.shape[0], 1)), axis=1))
        # the autocorrelation results
        plt.plot(tof*15, normR2)
        plt.title(plotTitle + " correlation")
        plt.xlabel("Range (cm)")
        plt.show()

        # selR hold the range bin with max correlation
        self.finalVal = np.max(normR2)
        self.selR = np.argmax(normR2)
        self.normR2 = normR2


if __name__ == '__main__':
    # create an instance of the pipeline class
    my_pipeline = pipeline()
    # define the necessary input arguments
    data = genfromtxt('32cm_wood_36cm_tag_100ms.csv', delimiter=',')
    bg_data = genfromtxt('32cm_wood_36cm_tag_100ms_bg.csv', delimiter=',')
    bscan_data = data - bg_data.reshape((bg_data.size,1))

    timestamps = genfromtxt('32cm_wood_36cm_tag_100ms_timestamps.csv', delimiter=',')
    from_ = 0
    to = 800
    Tau = 1
    switchPer = 0.1
    plotTitle = "My Plot"
    modF = 1./(2*(switchPer))
#    aa = signal.square(2 * np.pi * modF * timestamps, 50)
#    plt.plot(timestamps, signal.square(2 * np.pi * 5 * timestamps))
#    plt.ylim(-2, 2)
#    plt.show()
    # call the detect_tag method
    print("here")
    my_pipeline.detect_tag(bscan_data, timestamps, from_, to, Tau, switchPer, plotTitle)
