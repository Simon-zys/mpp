function value = globalVar(key, value)
global globalVar__;

if isempty(globalVar__) || ~isfield(globalVar__, key) || isempty(globalVar__.(key))
    % init value
    if ~exist('value', 'var')
        value = [];
    end
    globalVar__.(key) = value; % init done
else
    if nargout == 0
        % set value
        globalVar__.(key) = value;
    else
        % get value
        value = globalVar__.(key);
    end
end