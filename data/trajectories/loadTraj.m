function [ data, cols ] = loadTraj( filename )

A = importdata(filename,' ',1);
data = A.data;
cols = A.colheaders;

end

