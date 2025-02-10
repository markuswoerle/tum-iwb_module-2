% Technical University of Munich (TUM)
% TUM School of Engineering and Design
% Institute for Machine Tools and Industrial Management (iwb)
% Markus Woerle, M.Sc.

% Specifying the function to dimension the electrolyzer and the storage
function [electrolyzer_power_opt,storage_capacity_opt,system_costs_opt] = dimensioning(hydrogen_demand_profile_cycle,number_of_data_points_per_cycle,sampling_frequency)
    
    % Specifying relevant technology parameters
    lower_heating_value_hydrogen = 3; % in kWh/Nm^3
    degree_of_efficiency_electrolysis = 0.62;
    
    % Initializing the initial electrolyzer power vector for the optimization
    electrolyzer_powers_initial = zeros(number_of_data_points_per_cycle,1); % in kW
    
    % Calculating the initial electrolyzer power values for the optimization
    for i = 1:number_of_data_points_per_cycle
        electrolyzer_powers_initial(i) = hydrogen_demand_profile_cycle(i)*lower_heating_value_hydrogen/degree_of_efficiency_electrolysis-50; % in kW
    end
    
    % Specifying the minimum electrolyzer power
    electrolyzer_power_min = 0; % in kW
    
    % Specifying the maximum electrolyzer power
    electrolyzer_power_max = Inf; % in kW
    
    % Specifying the lower and the upper boundary for the optimization
    lower_boundary = electrolyzer_power_min*ones(number_of_data_points_per_cycle,1); % in kW
    upper_boundary = electrolyzer_power_max*ones(number_of_data_points_per_cycle,1); % in kW
    
    % Specifying the options for the optimization
    options = optimoptions('fmincon', ...
        'Algorithm','sqp', ...
        'Display','iter', ...
        'UseParallel',true, ...
        'MaxFunctionEvaluations',1e9, ...
        'StepTolerance',1e-10, ...
        'MaxIterations',1e4);

    % Calling the function to perform the optimization
    [electrolyzer_powers_opt,system_costs_opt] = fmincon( ...
        @(electrolyzer_powers) costs(electrolyzer_powers,hydrogen_demand_profile_cycle,number_of_data_points_per_cycle), ...
        electrolyzer_powers_initial, ...
        [],[],[],[], ...
        lower_boundary, ...
        upper_boundary, ...
        @(electrolyzer_powers) constraints(electrolyzer_powers,hydrogen_demand_profile_cycle,number_of_data_points_per_cycle,sampling_frequency), ...
        options);

    % Calculating the optimized storage capacity based on the optimized electrolyzer power
    storage_capacity_opt = storage(electrolyzer_powers_opt,hydrogen_demand_profile_cycle,number_of_data_points_per_cycle); % in Nm^3
    
    % Calculating the optimized electrolyzer power
    electrolyzer_power_opt = max(electrolyzer_powers_opt); % in kW
    
    % Calculating the storage levels
    states_of_charge = soc(electrolyzer_powers_opt,hydrogen_demand_profile_cycle,number_of_data_points_per_cycle); % in Nm^3
    state_of_charge_min = min(states_of_charge); % in Nm^3
    states_of_charge = states_of_charge+abs(state_of_charge_min); % in Nm^3
    
    % Plotting the electrolyzer power
    figure;
    plot(linspace(0,(number_of_data_points_per_cycle/(1/(15*60)))/86400,number_of_data_points_per_cycle),electrolyzer_powers_opt);
    grid on;
    xlim([0 (number_of_data_points_per_cycle/(1/(15*60)))/86400]);
    xlabel('Time / days \rightarrow');
    ylabel('Power / kW \rightarrow');
    title('Electrolyzer power');
    
    % Plotting the storage levels
    figure;
    plot(linspace(0,(number_of_data_points_per_cycle/(1/(15*60)))/86400,number_of_data_points_per_cycle),states_of_charge);
    xlim([0 (number_of_data_points_per_cycle/(1/(15*60)))/86400]);
    grid on;
    xlabel('Time / days \rightarrow');
    ylabel('Storage level / Nm^3 \rightarrow');
    title('Storage levels');
    
end