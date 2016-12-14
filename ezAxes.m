function ax = ezAxes(varargin)

if nargin == 0
%% EXAMPLE
	ezAxes('peppers.png', 'cameraman.tif', 'football.jpg');
    % ezAxes peppers.png cameraman.tif football.jpg
    figure;
    cfg.layout = [1 1 0;2 2 3;4 4 4];
    ezAxes(cfg, 'peppers.png', 'cameraman.tif', 'pout.tif', 'football.jpg');
    return;
end

varargin2args

cfg = varargin{1};
if isstruct(cfg)
    args = args(2:end);
end

for n = 1:numel(args)
    if ischar(args(n).value), args(n).value = imread(args(n).value); end
end

ax = Ax(args);

if isstruct(cfg)
    if isfield(cfg, 'layout')
        ax.setLayout(cfg.layout);
    end
end

if nargout == 0
    imshow(ax);
end