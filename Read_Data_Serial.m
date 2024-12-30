% Create a serial port object
device = serialport("COM3", 9600);

% Set a timeout for the serial communication
device.Timeout = 10;


% Number of bits to read (example: 24 bits)
numBits = 40;
bitsReceived = [];  % To store the bits

while true
    try
        % Read 3 bytes (24 bits)
        rawData = read(device, 5, "uint8");  % Read 3 bytes (24 bits)
        disp(rawData)
    
        % Extract bits from each byte
        for i = 1:length(rawData)
            byte = rawData(i);
            for bitPos = 1:8
                % Extract each bit from the byte
                bitValue = bitget(byte, bitPos);  % bitget returns 0 or 1
                bitsReceived = [bitsReceived, bitValue];  % Append the bit to the array
            end
            bin2dec(strrep((num2str(bits_12(1,:))),' ',''))
        end
        
        % Display the first 24 bits
        disp("Received Bits:");
        disp(bitsReceived(1:8));
        disp(bitsReceived(9:16));
        disp(bitsReceived(17:24));
        disp(bitsReceived(25:32));
        disp(bitsReceived(33:40));
    
        % Pause for clarity in display (adjust or remove as needed)
        pause(1);
    catch
        disp("Break")
        clear device;
        break;
    end
end
% Set the terminator for reading data
%device.Terminator = "CR/LF";  % Set to either "LF", "CR", or "CR/LF"