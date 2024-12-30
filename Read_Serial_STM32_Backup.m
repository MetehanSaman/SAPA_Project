s = serialport('COM7', 250000);
configureTerminator(s, "CR/LF"); % LF=Line Feed, CR=Carriage Return
HeartRaw = plot(0, 0, 'r');  % Initialize plot with dummy data
while true
    data = read(s, 500, "uint8");
    data = data(data ~= 10 & data ~= 13);
    num_groups = floor(length(data) / 3);

    if num_groups > 0
        first_12bit = zeros(1, num_groups);
        second_12bit = zeros(1, num_groups);
                        
        % Process data in groups of 3 bytes
        for i = 1:(num_groups)
        % Extract current group of 3 bytes
        idx = (i - 1) * 3 + 1;
        byte1 = data(idx);
        byte2 = data(idx + 1);
        byte3 = data(idx + 2);
                            
        % First 12-bit number: 8 bits from byte1 and 4 bits from byte2
        first_12bit(i) = bitshift(uint16(byte1), 4) + bitshift(bitand(uint16(byte2), 240), -4);
                            
        % Second 12-bit number: 4 bits from byte2 and 8 bits from byte3
        second_12bit(i) = bitshift(bitand(uint16(byte2), 15), 8) + uint16(byte3);
        end
    end
    ylim([0,4096])
    time_vector = linspace(0,num_groups,num_groups);
    set(HeartRaw, 'XData', time_vector, 'YData', second_12bit);
    drawnow;
end