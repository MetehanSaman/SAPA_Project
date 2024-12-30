s = serialport('COM3', 115200);
heart_data = zeros(1, 20); % Pre-allocate heart_data array
lung_data = zeros(1, 20); % Pre-allocate lung_data array

for i = 1:1000
    data = read(s,5,"uint8");
    data = char(data);
    data = char(data(1:3));
    bits = zeros(3, 8);
    disp(data)
    for byte = 1:3
        bits(byte, 1:8) = arrayfun(@str2double, dec2bin(double(data(byte)), 8));
    end
end

clear s