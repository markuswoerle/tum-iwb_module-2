% Technical University of Munich (TUM)
% TUM School of Engineering and Design
% Institute for Machine Tools and Industrial Management (iwb)
% Markus Woerle, M.Sc.

% Specifying the function to calculate the system costs
function system_costs = costs(electrolyzer_powers,hydrogen_demand_profile_cycle_representative,number_of_data_points_per_cycle)
    
    % Specifying relevant cost parameters
    specific_electrolyzer_capex = 500; % in EUR/kW // Configurations: 500, 1000, 1500
    specific_electrolyzer_opex = 0.03; % in %/a
    specific_storage_capex = 100; % in EUR/Nm^3
    specific_storage_opex = 0.015; % in %/a
    service_life = 10; % in a
    
    % Calling the function to calculate the necessary storage capacity for a given electrolyzer power
    storage_capacity = storage(electrolyzer_powers,hydrogen_demand_profile_cycle_representative,number_of_data_points_per_cycle); % in Nm^3
    
    % Calculating the investment costs
    electrolyzer_capex = specific_electrolyzer_capex*max(electrolyzer_powers); % in EUR
    storage_capex = specific_storage_capex*storage_capacity; % in EUR
    
    % Calculating the operational costs
    electrolyzer_opex = electrolyzer_capex*specific_electrolyzer_opex*service_life; % in EUR
    storage_opex = storage_capex*specific_storage_opex*service_life; % in EUR 
    
    % Calculating the system costs
    system_costs = electrolyzer_capex+storage_capex+electrolyzer_opex+storage_opex; % in EUR

end
