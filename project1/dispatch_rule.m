% 24 hour load profile for the commercial building in kWh
load_profile = [8 7 6 6 7 9 12 15 18 20 21 22 23 22 20 19 20 21 19 16 14 12 10 9]; 

% 24 hour PV generation profile for Abu Dhabi in kWh
pv_profile = [0 0 0 0 0 1 4 9 14 18 21 22 21 18 14 9 4 1 0 0 0 0 0 0]; 

% BESS settings
capacity  = 100;   % kWh
P_max     = 50;    % Maximum charge and discharge power in kW
eta       = 0.95;  % Round trip efficiency
SOC_min   = 0.20;  % Minimum SOC
SOC_max   = 0.90;  % Maximum SOC
SOC_init  = 0.50;  % Initial SOC


SOC = zeros(1,25); 
SOC(1) = SOC_init; 
P_charge = zeros(1,24); 
P_discharge = zeros(1,24); 
P_grid = zeros(1,24); 

for t = 1:24 
    net = pv_profile(t) - load_profile(t);  % Positive means extra PV
    
    if net > 0 
        % Charge the battery when there is extra PV
        headroom = (SOC_max - SOC(t)) * capacity; 
        P_charge(t) = min([net, P_max, headroom]); 
    else 
        % Use the battery when PV is less than the load
        available = (SOC(t) - SOC_min) * capacity; 
        P_discharge(t) = min([-net, P_max, available]); 
    end 
    
    P_grid(t) = load_profile(t) - pv_profile(t) + P_charge(t) - P_discharge(t); 
    SOC(t+1) = SOC(t) + (sqrt(eta)*P_charge(t) - P_discharge(t)/sqrt(eta)) / capacity; 
end


hours = 1:24;

figure;
subplot(3,1,1);
plot(hours, load_profile, 'b-', hours, pv_profile, 'r--');
title('Load vs PV Generation');
xlabel('Hour'); ylabel('kWh');
legend('Load','PV'); grid on;

subplot(3,1,2);
bar(hours, P_grid);
title('Grid Import (kW)');
xlabel('Hour'); ylabel('kW'); grid on;

subplot(3,1,3);
plot(1:25, SOC*100);
title('BESS State of Charge (%)');
xlabel('Hour'); ylabel('%');
ylim([0 100]); grid on;
