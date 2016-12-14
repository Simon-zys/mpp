function ezDump(varargin)
% save image data as file.
% the output file is located in '%dump' path by default.

if nargin == 0
%% EXAMPLE
    raw = imread('peppers.png');
    gray = rgb2gray(raw);
    bw = im2bw(raw);
    fig = ezFig(raw,gray);
    ezDump raw gray bw fig
    %ezDump(raw,gray,bw)
    return;
end

if iscellstr(varargin) % all inputs are char -- command-like usage
    for n = 1:numel(varargin)
        args{n}= evalin('caller', varargin{n}); % 'caller' 'base'
    end
else
    args = varargin;
end

%DUMP
% cfg
% .name - format string (%s for varname)
%
%EXAMPLE
%
% peppers = imread('peppers.png');
% cameraman = imread('cameraman.tif');
% 
% dump(peppers, cameraman, fig)
%
% 
%FEATURES
% level support
%
%TODO
% mkdir

%% default settings
defaultCfg.name = '%s'; % add path here
%defaultCfg.ext = ''; % adaptive
defaultCfg.mat2gray = false; %true;
defaultCfg.level = 1; % must be dump

cfg = args{1};
if isstruct(cfg)
    todump = args(2:end);
    nfixarg = 1;
else
    todump = args; %{cfg, varargin{:}};
    cfg = [];
    nfixarg = 0;
end

mkdir('%dump');

cfg = loaddefault(cfg, defaultCfg);

[path, name, ext] = fileparts(cfg.name);

if isempty(path)
    path = globalcfg.dumpPath;
end

%% suppress dumping
if cfg.level > globalcfg.dumpLevel
    return;
end

%% dump one by one
for n = 1:numel(todump)
    arg = todump{n};
    
    %% filename without extension
    varname = inputname(n+nfixarg);
    if isempty(varname)
        varname = num2str(n);
    end
    
    filename = sprintf(name, varname);
    filename = fullfile(path, filename);
    
    %% object
    if isobject(arg)
        switch class(arg)
            case {'matlab.ui.Figure', 'Fig'};
                if isempty(ext), t_ext = '.jpg';
                else t_ext = ext;
                end
                
                file = [filename, t_ext];
                figure(arg);
                switch(t_ext)
                    case '.jpg'
                        print(file, '-djpeg'); % print(arg, file, '-djpeg');
                    case '.eps'
                        print(file, '-depsc'); % print(arg, file, '-depsc');
                    otherwise
                        error('unsupport ext');
                end
                continue; % dump next
            otherwise
                arg = arg.data;
        end
    end
    
    t_ext = ext;
    if isempty(t_ext)
        if ismatrix(arg)
            t_ext = '.png';
            if cfg.mat2gray, arg = mat2gray(arg); end
        elseif ndims(arg)== 3
            t_ext = '.jpg';
        else error('cannnot determine file extension');
        end
    end
    
    imwrite(arg, [filename, t_ext]);
end

end