% Initialize serial port
s = serialport('COM7', 250000);
configureTerminator(s, "CR/LF"); % LF=Line Feed, CR=Carriage Return

while true
    % Read data from serial port
    data = read(s, 5000, 'uint8');
    
    % Remove CR/LF characters
    newdata = data(data ~= 10 & data ~= 13);
    
    % Check if we have complete groups of 3 bytes
    num_groups = floor(length(newdata) / 3);
    
    if num_groups > 0
        % Preallocate separate vectors for first and second 12-bit numbers
        first_12bit = zeros(1, num_groups);
        second_12bit = zeros(1, num_groups);
        
        % Process data in groups of 3 bytes
        for i = 1:num_groups
            % Extract current group of 3 bytes
            idx = (i - 1) * 3 + 1;
            byte1 = newdata(idx);
            byte2 = newdata(idx + 1);
            byte3 = newdata(idx + 2);
            
            % First 12-bit number: 8 bits from byte1 and 4 bits from byte2
            first_12bit(i) = bitshift(uint16(byte1), 4) + bitshift(bitand(uint16(byte2), 240), -4);
            
            % Second 12-bit number: 4 bits from byte2 and 8 bits from byte3
            second_12bit(i) = bitshift(bitand(uint16(byte2), 15), 8) + uint16(byte3);
        end
        
        % Display results
        disp('First 12-bit numbers:');
        disp(first_12bit');
        %disp('Second 12-bit numbers:');
        %disp(second_12bit);
    end
end