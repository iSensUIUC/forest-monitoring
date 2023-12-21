##### VNA s parameter meausrements - instructions with software

The download instruction can be found under group wiki under VNA folder. 

Software instructions: 
1. open the Network Analyzer application.
2. Do calibration using VNA kit. First connect VNA cable with VNA port 1 and VNA port 2, then connect the other sides of cable with calibration kit. Then in the VNA software, on the right menu, click "Cal", then under "Cal Sets & Cal kits", select ECal. Finish the procedure in Ecal.
3. On the menu, click "Freq" to specify "Start" to be the beginning frequency of frequency sweep, stop to be end frequency of sweep. The bandwidth will affect the range resolution of radar. Specify number of points, which will affect the maximum range. Under "Sweep", Set the "Sweep type" to be linear frequency. Click "Power", under "Power Level", which can specify the output power level. Under "Meas", select the s-parameters to measure. For example, if port 1 is used as transmitter and port 2 is receiver, s12 means signal coming out from port 1 divided by signal in port 2.
4. Under the "Utility menu on the top, select "Save > Save data" to save the data for a single sweep.

##### VNA python based instructions
Run vna_sweep_continuous.py to get a 2-D array for VNA data. It outputs the data as 2-D array, where row is radar timeframe and column is signal in different range bins for signle timeframe. The output of this file can be feed as input to pipeline_for_VNA.m under the UWB_radar/pipeline_for_VNA.m to get the pipeline result.
