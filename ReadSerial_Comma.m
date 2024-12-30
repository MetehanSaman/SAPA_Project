s = serialport("COM7", 250000);

% Configure figure for real-time plotting
figure('Name', 'Heart and Lung Data Monitor');
subplot(2,1,1);
h1 = animatedline('Color', 'red', 'LineWidth', 1.5);
title('Heart Data');
ylabel('Value');
xlabel('Time (s)');
ylim([0 4096]);
grid on;

subplot(2,1,2);
h2 = animatedline('Color', 'blue', 'LineWidth', 1.5);
title('Lung Data');
ylabel('Value');
xlabel('Time (s)');
ylim([0 4096]);
grid on;

% Initialize time
t = 0;
tic;
try
    while true
        % Read data from serial port
        data = readline(s);
        
        % Split the string at comma
        values = str2double(split(data, ','));
        
        % Check if we received valid data
        if length(values) == 2 && all(~isnan(values))
            % Get current time
            t = toc;
            
            % Add points to the animated lines
            addpoints(h1, t, values(1));
            addpoints(h2, t, values(2));
            
            % Update axes limits
            subplot(2,1,1);
            xlim([max(0, t-10) t+0.1]);
            
            subplot(2,1,2);
            xlim([max(0, t-10) t+0.1]);
            
            % Update display
            drawnow;
        end
    end
catch ME
    % Close serial port in case of error
    clear s;
    rethrow(ME);
end
% Cleanup
clear s;