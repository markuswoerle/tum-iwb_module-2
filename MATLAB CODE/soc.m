% Technical University of Munich (TUM)
% TUM School of Engineering and Design
% Institute for Machine Tools and Industrial Management (iwb)
% Markus Woerle, M.Sc.

% Specifying the function to calculate the necessary storage levels for a given electrolyzer power
function states_of_charge = soc(electrolyzer_powers,hydrogen_demand_profile_cycle_mean,number_of_data_points_per_cycle)
    
    % Specifying relevant technology parameters
    lower_heating_value_hydrogen = 3; % in kWh/Nm^3
    degree_of_efficiency_electrolysis = 0.62;
    
    % Initializing relevant variables
    state_of_charge_current = 0; % in Nm^3
    states_of_charge = zeros(number_of_data_points_per_cycle,1); % in Nm^3
    
    % Calculating the state of charge per time step
    for i = 1:number_of_data_points_per_cycle
        hydrogen_production_per_time_step = electrolyzer_powers(i)*degree_of_efficiency_electrolysis*0.25/lower_heating_value_hydrogen; % in Nm^3
        state_of_charge_difference = hydrogen_production_per_time_step-hydrogen_demand_profile_cycle_mean(i)*0.25; % in Nm^3
        state_of_charge_current = state_of_charge_current+state_of_charge_difference; % in Nm^3
        states_of_charge(i) = state_of_charge_current; % in Nm^3
    end
    
end