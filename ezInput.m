function varargout = ezInput(varargin)
%EZINPUT parse varargin
%USAGE
% [opt1, opt2, ... , input, varargin] = ezInput(cfg, varargin, default1, default2, ..., 'param1', value1, 'parm2', value2, ...);
% [opt1, opt2, opt3] = ezInput(varargin, default1, default2, default3);
% input = ezInput(varargin, 'param1', value1, 'parm2', value2);
%
%EXAMPLE
%
% inputs = {1, 'param1', 1, 'param2', 2, 'param3', 3};
% [opt1, opt2, opt3, input, varargin] = ezInput(inputs, 100, 200, 300, 'param1', 100, 'param2', 200, 'param4', 400)
%
%COPYRIGHT Zhenqiang Ying <yingzhenqiang-at-gmail-dot-com>

if nargin == 0
    %help ezInput ezHelp ezInput ezDump ezFig
    % seeAlso
    %inputs = {1,'2',3, 'param1', 1, 'param2', 2, 'param3', 3};
    inputs = {1, 'param1', 1, 'param2', 2, 'param3', 3};
    [opt1, opt2, opt3, input, varargin] = ezInput(inputs, 100, 200, 300, 'param1', 100, 'param2', 200, 'param4', 400)
    %[opt1, opt2, opt3, input] = ezInput(inputs, 100, 200, 300, 'param1', 100, 'param2', 200, 'param4', 400)
    %[opt1, opt2, opt3] = ezInput({1}, 100, 200, 300)
    %input = ezInput({'param1', 1}, 'param1', 100, 'param2', 200, 'param3', 300)
    return;
end

% [opt, param] = argparts(0, 1,'2',3, '4', 5, 'param1', 1, 'param2', 2, 'param3', 3)
% return;

if isstruct(varargin{1})
    cfg = varargin{1}; varargin = varargin(2:end);
else
    cfg = [];
end

[defaultOpt, defaultParam] = argparts(varargin{2:end});                     % load default param-value
[varargout{1:numel(defaultOpt)}] = defaultOpt{:};                           % load default optional
[opt, param] = argparts(varargin{1}{:});                                    % parse function inputs % vararg = varargin{1};
[varargout{1:numel(opt)}] = opt{:};                                         % overwrite optional
[varargout{numel(defaultOpt)+(1:2)}] = loaddefault(param, defaultParam);    % overwrite param-value
end

function [opt, param] = argparts(varargin) % split opt and param-value
% init opt and param
param = struct;  % in case of skiping next loop (no param)
if mod(nargin,2) % in case of not breaking in next loop (no opt)
    opt = varargin(1);
else
    opt = {};
end

for n = nargin-1:-2:1
    name = varargin{n};
    if isvarname(name)
        param.(name) = varargin{n+1};
    else
        opt = varargin(1:(n+1));
        break;
    end
end
end

function [param, unknown] = loaddefault(inputParam, defaultParam, caseSensitive)
% param - load defaultParam value when it is not specified in param
% unknown - param that not in the set of defaultParam
if nargin < 3
    caseSensitive = true;
end

defaultFields = fieldnames(defaultParam);
inputFields = fieldnames(inputParam);

if ~caseSensitive
    defaultFields = lower(defaultFields);
    inputFields = lower(inputFields);
end

% note that we overwrite the specified param instead of loading default value to inputParam,
% since the fieldname in inputParam is not reliable if case-insensitive
isSpecified = ismember(defaultFields, inputFields);

% defaultParam <-- inputParam
param = loadfiled(defaultParam, inputParam, defaultFields(isSpecified));

% note we do not append unknown parameters to param since when
% we use the parameter, we assert that it has default value if not
% specified
if nargout > 1
    isKnown = ismember(inputFields, defaultFields);
    unknown = loadfiled(struct, inputParam, inputFields(~isKnown));
    % convert struct to cell
    unknown = convertToCell(unknown);
end
end

function s1 = loadfiled(s1, s2, fields)
for n = 1:numel(fields)
    s1.(fields{n}) = s2.(fields{n});
end
end

function c = convertToCell(s)
twoRow = [fieldnames(s), struct2cell(s)]';
c = twoRow(:)';
end

%TODO
% struct union
% merge struct recursively
% compare time with inputParser