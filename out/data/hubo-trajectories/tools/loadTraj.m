function [ data, joints ] = loadTraj( filename )

A = importdata(filename,' ',1);
data = A.data;
joints = A.colheaders;

end

