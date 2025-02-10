% Technical University of Munich (TUM)
% TUM School of Engineering and Design
% Institute for Machine Tools and Industrial Management (iwb)
% Markus Woerle, M.Sc.

% Specifying the function to calculate the necessary storage capacity for a given electrolyzer power
function storage_capacity = storage(electrolyzer_powers,hydrogen_demand_profile_cycle,number_of_data_points_per_cycle)
    
    % Calling the function to calculate the necessary storage levels
    states_of_charge = soc(electrolyzer_powers,hydrogen_demand_profile_cycle,number_of_data_points_per_cycle); % in Nm^3
    
    % Determining the maximum state of charge
    state_of_charge_max = max(states_of_charge); % in Nm^3
    
    % Determining the minimum state of charge
    state_of_charge_min = min(states_of_charge); % in Nm^3
    
    % Calculating the necessary storage_capacity
    storage_capacity = state_of_charge_max-state_of_charge_min; % in Nm^3
    
end