import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import scipy.constants

def compute_pdp(s_params, frequencies, n=1024):
    """
    Returns PDP and range bins. PDP is power delay profile and is the inverse fourier transform of the s-parameters. 
    This is also called range profile.
    """
    pdp = np.fft.ifft(s_params, n=n)
    delta_f = float(frequencies[1]) - float(frequencies[0])
    Rmax = scipy.constants.c/(2*delta_f)
    vRange = np.arange(len(pdp)) * Rmax/len(pdp)
    return pdp, vRange

def get_avg_sparams(session, n_avg=1):
    """
    Returns the S-parameters and sampled frequencies
    """
    avg_sparams = None
    for _ in range(n_avg):
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

    return avg_sparams/n_avg, frequencies