function [ output ] = simpleTabImport( fileName )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
fid = fopen(fileName, 'r');
temp1 = textscan(fid,'%s', 'Delimiter','\n'); 
temp1 = temp1{1,1};
[a,~] = size(temp1);
first = true;

for x = 1:a
    temp2 = textscan(temp1{x,1},'%s', 'Delimiter','\t');
    temp2 = temp2{1,1};
    [b,~] = size(temp2);
    if first
        
        output = cell(a,b);
        first = false;
    end
    for y = 1:b
        output(x,y) = temp2(y,1);
    end
end


end

