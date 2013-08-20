function saveTraj( filename, data, cols )

n = length(cols);
fileID = fopen(filename,'w');
% Write header
for i = 1:n
    fprintf(fileID,'%-11s ',cols{i});
end
fprintf(fileID,'\n');
% Write data
format = [repmat('%-+11f ',1,n), '\n'];
fprintf(fileID,format,data');

end

