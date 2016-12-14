function ezTitle(varargin)

if nargin == 0
%% EXAMPLE
	ezFig('peppers.png', 'cameraman.tif', 'football.jpg'),
    ezTitle 'Command like usage: Peppers' Cameraman football
    pause
    ezTitle({'Function'; 'like'}, 'usage:');
    pause
    cfg.Color = 'b';
    ezTitle(cfg, 'Add', 'some', 'configuration');
    pause
    ezTitle('change', [], 'title');
    return;
end

if isstruct(varargin{1})
    % struct to cell string of param value 
    s = varargin{1};
    paramValuePairs = [fieldnames(s) struct2cell(s)]';

    titleString = varargin(2:end);
else
    paramValuePairs = {};
    titleString = varargin;
end

f = gcf;
N = numel(f.Children);
for n = 1:numel(titleString)
    t = titleString{n};
    if ~isempty(t)
        title(f.Children(N-n+1), t, paramValuePairs{:});
    end
end