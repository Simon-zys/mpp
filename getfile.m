function files = getfile(database, cmd)
%GETFILE return one file

%TODO 
% list all available database
% multiple file

if nargin == 0 
    files = uigetfile; return;
end

if nargin < 2
    cmd = ':';
end

files = eachfile(database);

switch lower(cmd)
    case {'all' ':'}
        % do nothing
    case 'random'
        index = randi(numel(files)); % random i \in 1-N
        files = files{index};
    otherwise
        error unkown_cmd
end

fprintf('Random selected: %s\n', files);

end