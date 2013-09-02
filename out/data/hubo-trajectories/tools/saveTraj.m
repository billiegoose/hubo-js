function saveTraj( filename, data, joints )

n = length(joints);
fileID = fopen(filename,'w');
% Write header
for i = 1:n
    fprintf(fileID,'%-11s ',joints{i});
end
fprintf(fileID,'\n');
% Write data
format = [repmat('%-+11f ',1,n), '\n'];
fprintf(fileID,format,data');

end

