% load and solar data for 24 hours
load_profile = [8 7 6 6 7 9 12 15 18 20 21 22 23 22 20 19 20 21 19 16 14 12 10 9];
pv_profile =   [0 0 0 0 0 1 4 9 14 18 21 22 21 18 14 9 4 1 0 0 0 0 0 0];

% battery settings
capacity = 100;  % kwh
P_max = 50;      % max power in or out
eta = 0.95;      % efficiency
SOC_min = 0.20;
SOC_max = 0.90;
SOC(1) = 0.50;   % start at 50%

% initialize
SOC = zeros(1,25);
SOC(1) = 0.50;
P_charge = zeros(1,24);
P_discharge = zeros(1,24);
P_grid = zeros(1,24);

for t = 1:24
    net = pv_profile(t) - load_profile(t);

    if net > 0
        % extra solar available, charge
        headroom = (SOC_max - SOC(t)) * capacity;
        P_charge(t) = min([net, P_max, headroom]);
    else
        % not enough solar, use battery
        available = (SOC(t) - SOC_min) * capacity;
        P_discharge(t) = min([-net, P_max, available]);
    end

    % whatever battery cant cover, grid supplies
    P_grid(t) = load_profile(t) - pv_profile(t) + P_charge(t) - P_discharge(t);
    SOC(t+1) = SOC(t) + (sqrt(eta)*P_charge(t) - P_discharge(t)/sqrt(eta)) / capacity;
end

% plots
figure;
subplot(3,1,1);
plot(1:24, load_profile, 'b', 1:24, pv_profile, 'r--');
legend('load','solar'); title('load vs solar'); grid on;

subplot(3,1,2);
bar(1:24, P_grid);
title('grid import'); ylabel('kw'); grid on;

subplot(3,1,3);
plot(1:25, SOC*100);
title('battery soc %'); ylim([0 100]); grid on;
