function [MD,Gamma,RHOB,SP,XNPHIS,PEF,RD,RS] = importStandardLogs(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [MD,GAMMA,RHOB,SP,XNPHIS,PEF,RD,RS] = IMPORTFILE(FILENAME) Reads data
%   from text file FILENAME for the default selection.
%
%   [MD,GAMMA,RHOB,SP,XNPHIS,PEF,RD,RS] = IMPORTFILE(FILENAME, STARTROW,
%   ENDROW) Reads data from rows STARTROW through ENDROW of text file
%   FILENAME.
%
% Example:
%   [MD,Gamma,RHOB,SP,XNPHIS,PEF,RD,RS] =
%   importfile('BasicLogInputs.txt',2, 29982);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2015/02/19 11:07:37

%% Initialize variables.
delimiter = '\t';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: text (%s)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%s%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
MD = dataArray{:, 1};
Gamma = dataArray{:, 2};
RHOB = dataArray{:, 3};
SP = dataArray{:, 4};
XNPHIS = dataArray{:, 5};
PEF = dataArray{:, 6};
RD = dataArray{:, 7};
RS = dataArray{:, 8};

