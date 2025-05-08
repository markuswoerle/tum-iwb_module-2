% Technical University of Munich (TUM)
% TUM School of Engineering and Design
% Institute for Machine Tools and Industrial Management (iwb)
% Markus Woerle, M.Sc.

% Specifying the function to analyze the periodicity of a hydrogen demand profile
function [hydrogen_demand_profile_cycle_based,number_of_data_points_per_cycle] = periodicity(hydrogen_demand_profile,sampling_frequency)
    
    % Determining the number of data points in the hydrogen demand profile
    number_of_data_points = length(hydrogen_demand_profile);
    
    % Calculating the times
    times = linspace(0,(number_of_data_points/sampling_frequency)/86400,number_of_data_points); % in days
    
    % Calculating the frequencies
    frequencies = (0:(number_of_data_points))/number_of_data_points*sampling_frequency; % in Hz
    
    % Calculating the Fast Fourier Transform
    fourier_transform = fft(hydrogen_demand_profile);
    
    % Calculating the double-sided amplitude spectrum
    amplitudes_double_sided = abs(fourier_transform);
    
    % Calculating the normalized double-sided amplitude spectrum
    amplitudes_double_sided_normalized = amplitudes_double_sided/number_of_data_points;
    
    % Calculating the single-sided amplitude spectrum
    amplitudes_single_sided_normalized = amplitudes_double_sided_normalized(1:number_of_data_points/2+1);
    amplitudes_single_sided_normalized(2:end-1) = 2*amplitudes_single_sided_normalized(2:end-1);
    
    % Determining the index of the maximum amplitude
    [~,index_amplitude_max] = max(amplitudes_single_sided_normalized(2:end));
    
    % Determining the frequency of the maximum amplitude
    frequency_amplitude_max = index_amplitude_max/number_of_data_points*sampling_frequency; % in Hz
    
    % Calculating the corresponding cycle time
    cycle_time_amplitude_max = 1/frequency_amplitude_max; % in s
    
    % Rounding the cycle time to the closest integer number of days
    cycle_time_amplitude_max_rounded = round(cycle_time_amplitude_max/86400)*86400; % in s
    
    % Calculating the number of data points per cycle
    number_of_data_points_per_cycle = cycle_time_amplitude_max_rounded*sampling_frequency;
    
    % Calculating the times per cycle
    times_cycle = linspace(0,(number_of_data_points_per_cycle/sampling_frequency)/86400,number_of_data_points_per_cycle); % in days
    
    % Calculating the number of complete cycles in the hydrogen demand profile
    number_of_complete_cycles = floor(number_of_data_points/number_of_data_points_per_cycle);
    
    % Limiting the hydrogen demand profile to the complete cycles
    hydrogen_demand_profile_complete_cycles = hydrogen_demand_profile(1:number_of_complete_cycles*number_of_data_points_per_cycle);
    
    % Transforming the hydrogen demand profile into a matrix with the columns containing the cycle-specific hydrogen demand profiles
    hydrogen_demand_profile_individual_cycles = reshape(hydrogen_demand_profile_complete_cycles,number_of_data_points_per_cycle,number_of_complete_cycles);
    
    % Calculating the cycle-based hydrogen demand profile
    hydrogen_demand_profile_cycle_based = max(hydrogen_demand_profile_individual_cycles,[],2);
    % hydrogen_demand_profile_cycle_based = prctile(hydrogen_demand_profile_individual_cycles,90,2);
    
    % Plotting the hydrogen demand profile
    figure;
    plot(times,hydrogen_demand_profile);
    grid on;
    xlim([0 max(times)]);
    xlabel('Time / days \rightarrow');
    ylabel('Hydrogen demand / Nm^3/h \rightarrow');
    title('Hydrogen demand profile');
    
    % Plotting the single-sided amplitude spectrum of the hydrogen demand profile
    figure;
    plot(frequencies(1:number_of_data_points/2+1),amplitudes_single_sided_normalized);
    grid on;
    xlim([sampling_frequency/number_of_data_points max(frequencies(1:number_of_data_points/2+1))]);
    xlabel('Frequency / Hz \rightarrow');
    ylabel('Amplitude / Nm^3/h \rightarrow');
    title('Single-sided amplitude spectrum');
    
    % Plotting the cycle-based hydrogen demand profile and the individual hydrogen demand profiles
    figure;
    plot_cycles = plot(times_cycle,hydrogen_demand_profile_individual_cycles,'Color',"#98C6EA");
    hold on;
    plot_cycle = plot(times_cycle,hydrogen_demand_profile_cycle_based,'Color',"#3070B3");
    grid on;
    xlim([0 max(times_cycle)]);
    xlabel('Time / days \rightarrow');
    ylabel('Hydrogen demand / Nm^3/h \rightarrow');
    title('Comparison of the cycle-based hydrogen demand profile with the individual profiles');
    legend([plot_cycles(1),plot_cycle],{'Individual profiles','Cycle-based profile'});
    hold off;
    
end
