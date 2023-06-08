# forest-monitoring
These scripts separate the data collection from analysis. To get started you can first run data_collection.m with one DAC max and min value and a 
duration of 32 so it collects the data quickly. Make sure to change the name to something you can remember. Then add the name of the file to
analyze_data_with_timestamps.m and run the pipeline. Modify these files to fit your experimental setup as it best works for you. For example, 
you might want to first collect a data frame of the background, and then press a key to continue collecting the rest of the frames when the tag is on. 

### Data collection

In data_collection.m you can see that you can define a set of DAC max and min values, downconversion enbaled or not, 
center frequencies (Tx3 and Tx4), and duration (number of radar frames you want to collect in total. You can also add different transmit power values
(check SensorLogic GitHub's MATLAB documentation to see what other parameters you can set).

### Data analysis 

You can use analyze_data_background_subtracted.m to detect the tag using background subtration. You need to either previously collect a background frame
with the tag turned off and then subtract that frame from the frames when the tag is on, or you can subtract the first radar frame from the rest of them
with the tag on. In the analyze_data_background_subtracted.m example, it uses the first method described above. In analyze_data_with_timestamps.m you can
see the most simple case for calling the pipeline. In whatever scenario you are working it is recommended that you do not use the whole radar frame (you should
cut the direct signal from the frame and also remove the bins that are past the known location of the tag plus the bin offset of the tag's cables).







