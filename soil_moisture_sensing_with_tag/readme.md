code for SLMX4 UWB radar.

data_collection.m: run data_collection.m in matlab, this will output will be a 2-D array. Each column will be one radar frame, and each row will be different timestamps. When running this code, remember to change the com_port variable to the port in the computer.

pipeline.m: This function will generate autocorelation values versus different tof(or range).

findpeak.m: This file can be runned to find the location of soil surface. The input of this file are different radar frames when we increase the height of radar. We assume that only soil surface and location of tag will change the same amount when we raise the radar. It first gets the location of tag using pipeline, then it finds the peak that changes the closest amount as the radar heights.

amplitude_time_range_plot_tag.m: It calls pipeline.m to plot autorelation result. It also plots the heatmap of radar radar that collects in data_collection.m.

one_plot.m: it plots the pipeline result for multiple experiments and put the all the results in one figure, which makes it easier to do comparison between different experiments.
