% Technical University of Munich (TUM)
% TUM School of Engineering and Design
% Institute for Machine Tools and Industrial Management (iwb)
% Markus Woerle, M.Sc.

% Specifying the function to calculate the constraints for the optimization
function [inequality_constraints,equality_constraint] = constraints(electrolyzer_powers,hydrogen_demand_profile_cycle,number_of_data_points_per_cycle,sampling_frequency)
    
    % Specifying the maximum load gradient
    load_gradient_max = 40; % in kW/s
    
    % Specifying the load gradient constraint
    load_gradient_constraint = abs(diff(electrolyzer_powers))*sampling_frequency-load_gradient_max;
    
    % Specifying the partial load capability
    gamma = 0.25;  % // Configurations: 0, 0.25, 0.5
    electrolyzer_power_max = max(electrolyzer_powers);

    % Specifying the partial load constraint
    partial_load_constraint = gamma*electrolyzer_power_max-electrolyzer_powers;
    
    % Specifying the inequality constraints
    inequality_constraints = [load_gradient_constraint;partial_load_constraint];
    
    % Calling the function to calculate the necessary storage levels
    states_of_charge = soc(electrolyzer_powers,hydrogen_demand_profile_cycle,number_of_data_points_per_cycle);
    
    % Specifying the equality constraint
    equality_constraint = states_of_charge(end)-states_of_charge(1);

end