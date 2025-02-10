% Technical University of Munich (TUM)
% TUM School of Engineering and Design
% Institute for Machine Tools and Industrial Management (iwb)
% Markus Woerle, M.Sc.

% Closing all figures, clearing all variables, and clearing the command window
close all;
clear variables;
clc;

% Loading the hydrogen demand profile
hydrogen_demand_profile = readmatrix('hydrogen_demand_profile.csv');

% Specifying the required user input data
resolution = 15; % in min

% Calculating the sampling frequency of the hydrogen demand profile
sampling_frequency = 1/(resolution*60); % in Hz

% Calling the function to analyze the periodicity of the hydrogen demand profile
[hydrogen_demand_profile_cycle,number_of_data_points_per_cycle] = periodicity(hydrogen_demand_profile,sampling_frequency);

% Calling the function to dimension the electrolyzer and the storage
[electrolyzer_power_opt,storage_capacity_opt,costs_opt] = dimensioning(hydrogen_demand_profile_cycle,number_of_data_points_per_cycle,sampling_frequency);