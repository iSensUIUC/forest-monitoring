import pyvisa
import matplotlib.pyplot as plt
import time
from capture_rp import compute_pdp
import numpy as np

VISA_ADDRESS = "TCPIP0::DESKTOP-A2MGT5U::hislip_PXI0_CHASSIS1_SLOT1_INDEX0::INSTR"

# Connect to the VNA
resourceManager = pyvisa.ResourceManager()
session = resourceManager.open_resource(VISA_ADDRESS)

# Command to preset the instrument and deletes the default trace, measurement, and window
session.write("SYST:FPR")

# Set frequency range
session.write("SENS1:FREQ:STAR 2GHz")
session.write("SENS1:FREQ:STOP 5GHz")

# Create and turn on window 1
session.write("DISP:WIND1:STAT ON")

# Create a S21 measurement
session.write("CALC1:MEAS1:DEF 'S21'")

# Displays measurement 1 in window 1 and assigns the next available trace number to the measurement
session.write("DISP:MEAS1:FEED 1")

# Set the active measurement to measurement 1
session.write("CALC1:PAR:MNUM 1")

# Set sweep type to linear
session.write("SENS1:SWE:TYPE LIN")

xaxis = None
sweeps = []
tstart = time.time()
for i in range(10):
    # Perfoms a single sweep
    session.write("SENS1:SWE:MODE SING")
    opcCode = session.query("*OPC?")
    # Get stimulus and formatted response data
    sweeps.append(session.query_ascii_values("CALC1:MEAS1:DATA:FDATA?"))
    xValues = session.query_ascii_values("CALC1:MEAS1:X:VAL?")
tend = time.time()

session.close()

print("Time taken: " + str(tend - tstart))

for i in range(5):
    plt.plot(xValues, sweeps[i])
plt.ylabel("dB")
plt.xlabel("Frequency")
plt.show()