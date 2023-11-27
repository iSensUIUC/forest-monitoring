import pyvisa
import matplotlib.pyplot as plt
import time
import numpy as np
from capture_rp import compute_pdp, get_avg_sparams
import csv
import scipy.signal


# Access this under "Instrument" -> "Setup" -> "System Setup" -> "Remote Interface..."
# then copy-paste the VISA address
VISA_ADDRESS = "TCPIP0::DESKTOP-A2MGT5U::hislip_PXI0_CHASSIS1_SLOT1_INDEX0::INSTR"

LOW_FREQ_GHZ = 2
HIGH_FREQ_GHZ = 5
SPARAM_POINTS = 1024

BACKGROUND_SUBTRACT = True

# Connect to the VNA
resourceManager = pyvisa.ResourceManager()
session = resourceManager.open_resource(VISA_ADDRESS)

# Command to preset the instrument and deletes the default trace, measurement, and window
session.write("SYST:FPR")

# Create and turn on window 1
session.write("DISP:WIND1:STAT ON")

# Get the list of available Calibrations
available_Cal_Set = session.query("CSET:CAT?")

Cal_info = session.query("CSET:PROP:CAT? \"CalSet_NOV20_fs2G_fe_5G_np1024_if_10k\"")

print("the Cal info is",Cal_info)

# # Set IF bandwidth
# session.write("SENS1:BAND 10000")

# Set sweep type to linear
session.write("SENS1:SWE:TYPE LIN")

# Set frequency range
# session.write("SENS1:FREQ:CENT %dghz" % (HIGH_FREQ_GHZ + LOW_FREQ_GHZ)/2)
# session.write("SENS1:FREQ:SPAN %dghz" % (HIGH_FREQ_GHZ - LOW_FREQ_GHZ))

# Create a S21 measurement
session.write("CALC1:MEAS1:DEF 'S21'")

# (Read-Write) Selects and applies a Cal Set to the specified channel
session.write("SENS1:CORR:CSET:ACT \"CalSet_NOV20_fs2G_fe_5G_np1024_if_10k\",1")
session.write("SENS2:CORR:CSET:ACT \"CalSet_NOV20_fs2G_fe_5G_np1024_if_10k\",1")

# session.write("SENSe1:FREQuency:CENTer 3.5ghz")
# session.write("SENSe1:FREQuency:SPAN 3ghz")
# session.write("SOUR:POW:LEV 10dBm")

# Displays measurement 1 in window 1 and assigns the next available trace number to the measurement
session.write("DISP:MEAS1:FEED 1")

# Set the active measurement to measurement 1
session.write("CALC1:PAR:MNUM 1")

# session.write("SENS:SWE:POIN %d" % SPARAM_POINTS)

# Set up continous plot
plt.ion()

fig = None
first_pdp = None

def get_range_profile(session, n_avg=1):
    avg_sparams = None
    for i in range(n_avg):
        # Perfoms a single sweep
        session.write("SENS1:SWE:MODE SING")
        session.query("*OPC?")
        # Get stimulus and formatted response data
        buf = session.query_ascii_values("CALC1:MEAS1:DATA:SDATA?", container=np.array)
        sparams = buf[::2] + 1j * buf[1::2]  # Interpret buffer as interleaved real and imaginary parts
        if avg_sparams is None:
            avg_sparams = sparams.copy()
        else:
            avg_sparams += sparams
        frequencies = session.query_ascii_values("CALC1:MEAS1:X:VAL?")

    return compute_pdp(avg_sparams/n_avg, frequencies)


first_pdp = None

def update_table(tab_ax, peaks, pdp, vRange):
    if len(peaks) == 0:
        return
    tab_ax.clear()
    tab_ax.axis('tight')
    tab_ax.axis('off')
    peak_powers = ['%.03f' % val for val in 20*np.log10(np.abs(pdp[peaks]))]
    peak_phases = ['%.03f' % val for val in np.angle(pdp[peaks])]
    cellText = [['%.03f' % vRange[peaks[i]], peaks[i], mag, phase] for i, (mag, phase) in enumerate(zip(peak_powers, peak_phases))]
    tab_ax.table(cellText=cellText, colLabels=["Distance", "Index", "Power (dB)", "Phase"], loc='center')

counter = 0

phases_at_tag = []

while counter < 100:    
    # Make plot if this is the first iteration
    if fig is None:
        fig = plt.figure()
        ax = fig.add_subplot(211)
        ax.set_title("Live Range Profile")
        ax.set_xlabel("Distance (m)")
        ax.set_ylabel("Amplitude")
        pdp, vRange = get_range_profile(session, n_avg=1)
        sparams, frequencies = get_avg_sparams(session, n_avg=1)

        lines, = ax.plot(vRange, np.angle(pdp))
        first_pdp = pdp.copy()
        first_sparams = sparams.copy()

        # Find top 5 peaks
        peaks, _ = scipy.signal.find_peaks(np.abs(pdp))
        peaks = sorted(peaks, key=lambda x: np.abs(pdp[x]), reverse=True)[:5]

        # Make table
        tab_ax = fig.add_subplot(212)
        update_table(tab_ax, peaks, pdp, vRange)

    # Push to plot and update screen
    sparams, frequencies = get_avg_sparams(session, n_avg=1)
    if BACKGROUND_SUBTRACT:
        sparams -= first_sparams
    pdp, vRange = compute_pdp(sparams, frequencies)
    # Update table
    peaks, _ = scipy.signal.find_peaks(np.abs(pdp))
    peaks = sorted(peaks, key=lambda x: np.abs(pdp[x]), reverse=True)[:5]
    update_table(tab_ax, peaks, pdp, vRange)
    # note down this time in the time array
    lines.set_xdata(vRange)
    lines.set_ydata(np.angle(pdp))
    fig.canvas.draw()
    fig.canvas.flush_events()
    counter += 1
    # record phase at index 262
    phases_at_tag.append(np.angle(pdp[44]))

plt.clf()
plt.title('Phase at index 44 of range profile (corresponding to tag)')
plt.xlabel('Frame #')
plt.ylabel('Phase (rad)')
plt.plot(phases_at_tag)
plt.show(block=True)

print('pause')