function [ delTimeRise, delTimeFall, R_time, R_voltage, F_time, F_voltage ] = GetSlowScan( filename )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

%% Choose Data
% %Oscilloscope file location and name
% foldername = 'C:\Users\HR\Desktop\project_new\Tiff Scripts';
% fileheader = 'frm2_604_';
% filename = [foldername, '/', fileheader, 'ch3','.csv'];
% importfile
[sdata.x,sdata.val,sdata.start,sdata.inc] = importfile(filename, 2);
sdata.x(1) = [];  sdata.val(1) = [];
sx = str2double(cell2mat(sdata.inc))*(sdata.x);
sy = smooth(sdata.val);

%% Plot & Crop scope data
figure;
plot(sx,sy,'.'); title('SELECT AND DRAG RECTANGLE containg one sawtooth - 2 maximas and one minima');
ylabel('Voltage [V]'); xlabel('time [sec]');
%user selected data rectangle
ax = gca;
rect_pos = getrect(ax);
% get data only frome rect
time = sx((sx>=rect_pos(1))&(sx<=(rect_pos(1)+rect_pos(3))));
voltage = sy((sx>=rect_pos(1))&(sx<=(rect_pos(1)+rect_pos(3))));
close;
% find the peaks
[max_pks,max_locs] = findpeaks(voltage);                       %find maximas
[min_pks,min_locs] = findpeaks(-voltage); min_pks = -min_pks;  %find minimas
% crop data to rising and falling dataset
F_voltage = voltage(max_locs(1):min_locs(1));   % Rising segment
F_time = time(max_locs(1):min_locs(1));         % Rising segment
R_voltage = voltage(min_locs(1):max_locs(2));   % Falling segment
R_time = time(min_locs(1):max_locs(2));         % Falling segment       

% % plot segments
% figure;
% plot(R_time,R_voltage,'.r', F_time,F_voltage,'.b');

% total time
delTimeRise = R_time(end)-R_time(1);
delTimeFall = F_time(end)-F_time(1);


end

