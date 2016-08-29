function [R_time, R_voltage, F_time, F_voltage ] = ScanningMirrorFunctionExtractor( )
%SCANNINGMIRRORFUNCTIONEXTRACTOR Summary of this function goes here
%   Detailed explanation goes here

% Get Scan Data
[ filename ] = LoadCsvFile( );
[ ~, ~, R_time, R_voltage, F_time, F_voltage ] = GetFastScan( filename );

end

