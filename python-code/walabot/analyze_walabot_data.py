import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import make_axes_locatable
import numpy as np
from scipy import constants
from scipy.signal import find_peaks, hilbert
from sklearn.preprocessing import normalize
import math
import pandas as pd


def gain(x):
    i = 0
    x1 = np.zeros(x.size)
    for i in range(0, x.size):
    # for xg in x:
        # x1[i] = xg*math.exp(0.2*(i*1.953125e-11))
        x1[i] = x[i]*math.exp(0.5*(i*1.953125e-11))
        # x[i] = i
        # i = i+1
    return x1

def exponential_gain(xg,alpha,dt=1.953125e-2):
  n = xg.size
  t = np.arange(n)*dt
  x_n = xg * np.exp(alpha*t)

  return x_n

def plot_same_setup():
        data = np.genfromtxt('36cm_tag_100ms.csv', delimiter=',')
        data = data/(data.max(axis=0) + np.spacing(0))

        bg_data = np.genfromtxt('36cm_tag_100ms_bg.csv', delimiter=',')
        bg_data = bg_data/(bg_data.max(axis=0) + np.spacing(0))

        bscan_data = data - bg_data.reshape((bg_data.size,1))
        # bscan_data = bscan_data/(bscan_data.max(axis=0) + np.spacing(0))
        bscan_data1 = bscan_data[:1500,:]
        bscan_data2 = bscan_data[:1500,:]
        bscan_data1 = np.apply_along_axis(gain, axis=0, arr=bscan_data1)
        data = data[:1500,:]
        max = bscan_data.argmax(axis=0)
        unique, counts = np.unique(max, return_counts=True)
        print(max)
        d = dict(zip(unique, counts))
        d = {k: v for k, v in sorted(d.items(), key=lambda item: item[1])}
        print(d)
        # do background subtraction
        # convert x axis to distance
        #ax = plt.subplot()
        #bscan_data = np.fft(bscan_data)
        ax = plt.subplot(1, 2, 1)
        im = ax.imshow(bscan_data1)
        plt.title('Gain')
        plt.ylabel('range bins')
        plt.xlabel('radar frame')
        # create an Axes on the right side of ax. The width of cax will be 5%
        # of ax and the padding between cax and ax will be fixed at 0.05 inch.
        divider = make_axes_locatable(ax)
        cax = divider.append_axes("right", size="5%", pad=0.05)

        plt.colorbar(im, cax=cax)
        ax2= plt.subplot(1, 2, 2)
        im = ax2.imshow(bscan_data2)
        plt.title('no gain')
        plt.ylabel('range bins')
        plt.xlabel('radar frame')
        # create an Axes on the right side of ax. The width of cax will be 5%
        # of ax and the padding between cax and ax will be fixed at 0.05 inch.
        divider = make_axes_locatable(ax2)
        cax2 = divider.append_axes("right", size="5%", pad=0.05)

        plt.colorbar(im, cax=cax2)

        plt.show()
        print('end')


def plot_wood():
        tag_data = np.genfromtxt('36cm_tag_100ms.csv', delimiter=',')
        tag_data = tag_data[:500,:]
        wood_data = np.genfromtxt('32cm_wood_36cm_tag_100ms.csv', delimiter=',')
        wood_data = wood_data[:500,:]

        wood = wood_data - tag_data
        # do background subtraction
        # convert x axis to distance
        #ax = plt.subplot()
        #bscan_data = np.fft(bscan_data)
        ax = plt.subplot(1, 2, 1)
        im = ax.imshow(wood_data)
        plt.title('32cm wood data')
        plt.ylabel('range bins')
        plt.xlabel('radar frame')
        # create an Axes on the right side of ax. The width of cax will be 5%
        # of ax and the padding between cax and ax will be fixed at 0.05 inch.
        divider = make_axes_locatable(ax)
        cax = divider.append_axes("right", size="5%", pad=0.05)

        plt.colorbar(im, cax=cax)

        ax2= plt.subplot(1, 2, 2)
        im = ax2.imshow(wood)
        plt.title('Wood and tag radar frames subtracted')
        plt.ylabel('range bins')
        plt.xlabel('radar frame')
        # create an Axes on the right side of ax. The width of cax will be 5%
        # of ax and the padding between cax and ax will be fixed at 0.05 inch.
        divider = make_axes_locatable(ax2)
        cax2 = divider.append_axes("right", size="5%", pad=0.05)

        plt.colorbar(im, cax=cax2)

        max = wood.argmax(axis=0)
        print(max)
        plt.show()
        print('end')


def zero_time_correction(data):
    # time 0 correction
    # first peak is new 0 and then correct with 3 bins
    peaks, _ = find_peaks(data, height=0.003)
    print(peaks)
    first_peak = peaks[0]
    w30 = data[first_peak:-1]


def get_top_wood_reflection():
        c = constants.speed_of_light

        wood_28_bg = np.genfromtxt('28cm_wood_bg.csv', delimiter=',')
        wood_28 = np.genfromtxt('28cm_wood.csv', delimiter=',')
        # zero_time_correction(wood_28)
        wood_28 = wood_28 - wood_28_bg
        wood_28_max = np.argmax(wood_28)
        wood_28_range = wood_28_max*1.953125e-11*c/2
        print(f"28cm wood estimate is: {wood_28_range}")

        wood_47_bg = np.genfromtxt('47cm_wood_bg.csv', delimiter=',')
        wood_47 = np.genfromtxt('47cm_wood.csv', delimiter=',')
        wood_47 = wood_47 - wood_47_bg
        wood_47_max = np.argmax(wood_47)
        wood_47_range = wood_47_max*1.953125e-11*c/2
        print(f"47cm wood estimate is: {wood_47_range}")

        wood_62_bg = np.genfromtxt('62cm_wood_bg.csv', delimiter=',')
        #wood_62_bg = np.mean(wood_62_bg, axis=1)
        wood_62 = np.genfromtxt('62cm_wood.csv', delimiter=',')
        #wood_62 = np.mean(wood_62, axis=1)
        wood_62_bg_sub = wood_62 - wood_62_bg
        wood_62_max = np.argmax(wood_62_bg_sub)
        wood_62_range = wood_62_max*1.953125e-11*c/2
        print(f"62cm wood estimate is: {wood_62_range}")
        analytical_wood_62_bg_sub =  np.absolute(hilbert(wood_62_bg_sub))
        analytical_wood_62_max = np.argmax(analytical_wood_62_bg_sub)
        analytical_wood_62_range = analytical_wood_62_max*1.953125e-11*c/2
        print(f"analytical 62cm wood estimate is: {analytical_wood_62_range}m")

        wood_86_bg = np.genfromtxt('86cm_wood_bg.csv', delimiter=',')
        wood_86 = np.genfromtxt('86cm_wood.csv', delimiter=',')
        wood_86 = wood_86 - wood_86_bg
        wood_86_max = np.argmax(wood_86)
        wood_86_range = wood_86_max*1.953125e-11*c/2
        print(f"86cm wood estimate is: {wood_86_range}")

        wood_105_bg = np.genfromtxt('105cm_wood_bg.csv', delimiter=',')
        wood_105 = np.genfromtxt('105cm_wood.csv', delimiter=',')
        wood_105 = wood_105 - wood_105_bg
        wood_105_max = np.argmax(wood_105)
        wood_105_range = wood_105_max*1.953125e-11*c/2
        print(f"105cm wood estimate is: {wood_105_range}")

        wood_130_bg = np.genfromtxt('130cm_wood_bg.csv', delimiter=',')
        wood_130 = np.genfromtxt('130cm_wood.csv', delimiter=',')
        #zero_time_correction(wood_130)
        wood_130 = wood_130 - wood_130_bg
        wood_130_max = np.argmax(wood_130)
        wood_130_range = wood_130_max*1.953125e-11*c/2
        print(f"130cm wood estimate is: {wood_130_range}")

        # print(np.array_equal(wood_28_bg, wood_28))
        # print(np.array_equal(wood_47_bg, wood_47))
        # print(np.array_equal(wood_62_bg, wood_62))
        # print(np.array_equal(wood_86_bg, wood_86))
        # print(np.array_equal(wood_105_bg, wood_105))
        # print(np.array_equal(wood_130_bg, wood_130))


        tau = 1.953125e-11
        Tau = 7.998046875e-08
        t = np.arange(0, 1.953125e-11*4096*c/2, 1.953125e-11*c/2)

        # plt.plot(t, wood_130, label="130cm wood")
        # plt.plot(wood_105)
        # plt.plot(wood_86)
        plt.plot(t, wood_62, label="62cm wood")
        #plt.plot(t, wood_62_bg, label="background")
        plt.plot(t, analytical_wood_62_bg_sub, label="analytical 62cm wood bg subtracted")
        plt.plot(t, wood_62_bg_sub, label="62cm wood with background subtracted")
        plt.axvline(x=0.62, label="expected wood reflection", color='r')
        # plt.plot(wood_47)
        # plt.plot(t, wood_28, label="28cm wood")

        plt.xlabel("Distance (in meters)")
        plt.ylabel("Amplitude")
        plt.title("Wood at 62 cm")
        plt.legend(loc="upper right")
        plt.savefig('foo.png')
        plt.show()

def analyze_wood_files(wood, background, measured_distance_to_wood):
        c = constants.speed_of_light
        wood[:60] = 0
        wood = wood[:700]
        background[:60] = 0
        background = background[:700]

        analytical_bg =  np.absolute(hilbert(background))

        #wood_62_bg = np.mean(wood_62_bg, axis=1)
        #wood_62 = np.mean(wood_62, axis=1)
        wood_bg_sub = wood - background
        wood_max = np.argmax(wood_bg_sub)
        wood_range = wood_max*1.953125e-11*c/2
        print(f"{distance_to_wood}m wood estimate is: {wood_bg_sub}m")

        analytical_wood =  np.absolute(hilbert(wood))
        analytical_wood_max = np.argmax(analytical_wood)
        analytical_wood_range = analytical_wood_max*1.953125e-11*c/2
        print(f"analytical {distance_to_wood}m wood estimate is: {analytical_wood_range}m")

        analytical_wood_bg_sub =  np.absolute(hilbert(wood_bg_sub))
        analytical_wood_bg_sub_max = np.argmax(analytical_wood_bg_sub)
        analytical_wood_bg_sub_range = analytical_wood_bg_sub_max*1.953125e-11*c/2
        print(f"analytical w/ bg subtracted {distance_to_wood}m wood estimate is: {analytical_wood_bg_sub_range}m")

        tau = 1.953125e-11
        Tau = 7.998046875e-08
        t = np.arange(0, 1.953125e-11*700*c/2, 1.953125e-11*c/2)

        #plt.plot(t, wood, label=(str(distance_to_wood) + "m wood"))
        plt.plot(t, analytical_wood, label=("analytical wood"))
        plt.plot(t, analytical_wood_bg_sub, label=("analytical wood w/ bg subtracted"))
        plt.plot(t, analytical_bg, label=("analytical bg"))
        #plt.plot(t, wood_bg_sub, label=(str(distance_to_wood) + "m wood w/ bg subtracted"))
        plt.axvline(x=distance_to_wood, label="expected wood reflection", color='r')
        # plt.plot(wood_47)
        # plt.plot(t, wood_28, label="28cm wood")

        plt.text(analytical_wood_range, 0.0002 + analytical_wood[analytical_wood_max], f"{analytical_wood_range:.2f}m")
        plt.text(analytical_wood_bg_sub_range, 0.0002 + analytical_wood_bg_sub[analytical_wood_bg_sub_max], f"{analytical_wood_bg_sub_range:.2f}m")
        plt.plot(analytical_wood_range, analytical_wood[analytical_wood_max], marker = 'x')
        plt.plot(analytical_wood_bg_sub_range, analytical_wood_bg_sub[analytical_wood_bg_sub_max], marker = 'x')
        plt.xlabel("Distance (in meters)")
        plt.ylabel("Amplitude")
        plt.title(f"Wood at {distance_to_wood}m")
        plt.legend(loc="upper right")
        plt.xlim(0, 2)
        plt.savefig(f"{distance_to_wood}m_wood.png")
        plt.show()

if __name__ == "__main__":
    wood = np.genfromtxt('86cm_wood_bg.csv', delimiter=',')
    #wood_62_bg = np.mean(wood_62_bg, axis=1)
    bg = np.genfromtxt('86cm_wood.csv', delimiter=',')
    analyze_wood_files(wood, bg, 0.86)




    # c = constants.speed_of_light
    # print(c*(125*1.953125e-11)/2)
    # plot_same_setup()
    #plot_wood()
    # wood detected at bin 135
    # tag detected at bin 398 with wood
    # tag detected at bin 391 without wood
    # total timestamps for single radar frame 7.998046875e-08
    # tau is 1.953125e-11

# def gain():
#     df_1 = pd.read_csv("48cm_wood_52cm_tag_100ms.csv",header=None)
#     df_1n = df_1.apply(lambda x: exponential_gain(x,0.2))
#     df = df_1n.values
#     bscan_data = df_1.values
#     ax = plt.subplot(1, 2, 1)
#     im = ax.imshow(df)
#     plt.title('Gain')
#     plt.ylabel('range bins')
#     plt.xlabel('radar frame')
#     # create an Axes on the right side of ax. The width of cax will be 5%
#     # of ax and the padding between cax and ax will be fixed at 0.05 inch.
#     divider = make_axes_locatable(ax)
#     cax = divider.append_axes("right", size="5%", pad=0.05)
#
#     plt.colorbar(im, cax=cax)
#
#     ax2= plt.subplot(1, 2, 2)
#     im = ax2.imshow(bscan_data)
#     plt.title('No gain')
#     plt.ylabel('range bins')
#     plt.xlabel('radar frame')
#     # create an Axes on the right side of ax. The width of cax will be 5%
#     # of ax and the padding between cax and ax will be fixed at 0.05 inch.
#     divider = make_axes_locatable(ax2)
#     cax2 = divider.append_axes("right", size="5%", pad=0.05)
#
#     plt.colorbar(im, cax=cax2)
#
#     plt.show()
#
# def ppd():
#     c = constants.speed_of_light
#     t = np.genfromtxt("radar_frame_timestamps.csv", delimiter=',')
#
#
#     #print(t)
#     print(f"d to tag: {constants.speed_of_light*(t[395])/2}")
#     #print(constants.speed_of_light*(t[398])/2)
#     # Using equations
#     # lambda = d/tau*f
#     l = 0.04/(t[7]* 6.65e9)
#     l_air = 0.045
#     f = 6.65e9
#     d = l*f*t[7]
#     em = (l_air/l)**2
#     print(f"estimated depth of wood: {d}")
#     print(f"estimated permittivity of wood: {em}")
#     # t1 = t[120]/2
#     # t2 = t[127]/2
#     # t3 = (t[135] - (t[398]-2e-9))/2
#     # d1 = t1*c
#     # d2 = t2*c
#     # d = d2 - d1
#     # print(f"d1: {d1}")
#     # print(f"d2: {d2}")
#     # print(f"d: {d}")
#     # f = 6.65e9
#     # wavelength = d/(t2*f)
#     # print(wavelength)
#     # d = wavelength*f*(t[7]/2)
#     # print(d)
#     #
#     # d = c*(t[398]/2 - 4e-9)
#     # print(f"hehehehe {t[7]*c/2}")
#     # # Estimate depth
#     # depth_est = d2-d1
#     # print(depth_est)
#     # error_1 = ((0.04*100-depth_est)/(0.04*100))*100
#     # print(f'Estimated depth is {depth_est:.3f} m ', f'with an error {error_1:.2f} %')
#     # # Estimate permittivity
#     # em = (t3/(t1-t2))**2
#     # print(em)
#     # error_2 = (5-em)/5*100
#     # print(f'Estimated permittivity {em:.3f}', f'with an error {error_2:.2f} %')
