function [ J ] = queen( headers )
%queen(headers) I WANT IT ALL. AND I WANT IT NOW!
%   headers is a cell array, btw.
for i = 1:length(headers)
    J.(headers{i}) = i;
end
end

