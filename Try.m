s = serialport('COM3', 250000);
configureTerminator(s, "CR/LF"); %LF=Line Return, CR=Carrier Return 

for i = 1:100
    data = readline(s);
    data = char(data);
end
disp(data)