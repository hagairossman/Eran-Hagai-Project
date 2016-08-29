function [ CSVfilename ] = LoadCsvFile( )
%LOADIMAGEFILE Summary of this function goes here
%   Detailed explanation goes here

%default file location and name
parentpath = cd(cd('..'));
defaultFileName = [parentpath, '\Data\GalvoCSV\', strrep('5.04', '.', '_'), '.csv'];

% load csv
[filename, pathname] = uigetfile({'*.csv'},'Select csv file', defaultFileName);
  if isequal(filename,0)
      CSVfilename = '0';
  else
      CSVfilename = fullfile(pathname, filename);
  end
end

