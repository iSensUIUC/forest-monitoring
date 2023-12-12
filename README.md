The folder VNA contains code for using VNA as SFCW radar to detect backscatter tag.
The folder soil_moisture_sensing_with_tag contains code for using UWB radar to detect backscatter tag. 
The folder anechoic chamber contains data for SLMX4 UWB radar in anechoic chamber room.
The folder soil_moisture_sensing_without_tag contains data for placing a metal plate under SLMX4 UWB radar, this folder is for Ishfaq's experiment in 2023 summer.

Sensor-logic and walabot is written by Diego:
# forest-monitoring
We worked with the UWB radar from sensor logic and the FMCW radar from Walabot. You can find the code for each radar
in the sensor-logic and walabot folders. In sensor-logic/python-code, you can find the Python connector
for the MATLAB firmware. Depending on what OS you are using, you will have to adjust the port in the __init__ method.
For the Walabot radar, you just need to run the script, there is no need to adjust anything. Also, note that the walabot/pipeline.py
script needs work as of 6/9/2023. You should update the paths to the data you want to use and then the error messages will give you
a clear idea of what's left to do.

In the folders sensor-logic/matlab-code and sensor-logic/python-code you can find the MATLAB and Python scripts for collecting and analysing data with the sensor logic radar. There 
is no MATLAB code for working with the Walabot. 

