# forest-monitoring
We worked with the UWB radar from sensor logic and the FMCW radar from Walabot. You can find the code for each radar
in the sensor-logic and walabot folders. In sensor-logic/python-code, you can find the Python connector
for the MATLAB firmware. Depending on what OS you are using, you will have to adjust the port in the __init__ method.
For the Walabot radar, you just need to run the script, there is no need to adjust anything. Also, note that the walabot/pipeline.py
script needs work as of 6/9/2023. You should update the paths to the data you want to use and then the error messages will give you
a clear idea of what's left to do.

In the folders sensor-logic/matlab-code and sensor-logic/python-code you can find the MATLAB and Python scripts for collecting and analysing data with the sensor logic radar. There 
is no MATLAB code for working with the Walabot. 