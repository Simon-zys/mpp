classdef Fig < handle% matlab.ui.Figure is sealed thus cannot be extend
    %Fig Do more than built-in figure with less code.
    %
    % Use Fig.handle to set and get properties.
    %
    % * figure(F.handle); % set to current figure:
    % * close(F.handle) % close it
    %
    %        MyFigure = Fig(Cameraman, Peppers),
    %        MyFigure.setAxesTitle({'A Cameraman', 'Some Peppers'});
    %        MyFigure.save(); 
    %        % input 'MyFigure.' and press tab to see available methods. 
    %
    %        layout = [ 1 2 2;
    %                   1 2 2;       
    %                   3 3 4];
    %        Fig(Peppers, Cameraman, Football, Peppers).setLayout(layout),
    
    % Note layout cannot overlap or the axes with bigger number will clear
    % the old one. Here, the 2 will be clear when 3 shows
    % to solve the problem, use Montage instead.
    %        layout = [ 2 2 2;
    %                   3 2 2;       
    %                   1 1 1];
    %        Fig(Peppers, Cameraman, Football, Peppers).setLayout(layout),
  
    properties (GetAccess = public, SetAccess = private)
        handle % Set and get figure properties.
        data
        
        layout
    end
    
    methods (Static)
        function demo
            Fig('peppers.png', 'cameraman.tif', 'football.jpg'),
            %Fig(eachfile('*.jpg'));
            title('INPUTS can be image filenames');
            pause;
            Peppers = imread('peppers.png');
            Cameraman = imread('cameraman.tif');
            Football = imread('football.jpg');
            Fig(Peppers, Cameraman, Football),
            
            Fig(Cameraman, Football).setTitle('My Figure').fullscreen,
            pause;close all;
        end
    end
    
% name value pair --> field and value?    
    
%     properties (GetAccess = private, SetAccess = private)
%         % data % private data storing contents to show
%     end

    methods (Access = public)
        function f = Fig(varargin)
            % Figure(varargin) Construct a figure.
            
            %f.data = args;
            if nargin == 1 && isfield(varargin{1}, 'name')
                f.data = varargin{1};
            else
                
                if ~isempty(get(groot,'CurrentFigure')) && ishold
                    % Note ishold will new a figure if there is no figure
                    f.handle = gcf;
                else
                    f.handle = figure();
                end
                
                varargin2args;
                f.data =args;
                
            end
        end
        
        function disp(f)
            args = f.data;
            mat = f.layout;
            
            %figure(f.handle);
            set(0, 'CurrentFigure', f.handle);
            
            narg = numel(args);
            if ~isempty(mat)
                [r, c] = size(mat); vec = mat'; vec = vec(:); % convert to a vector
            else
                r = floor(sqrt(narg)); c = ceil(narg/r);
            end
            for n = 1:narg
                if ~isempty(mat)
                    pStart = find( vec==n, 1, 'first'); 
                    pEnd =  find( vec==n, 1, 'last');
                    subplot(r, c, [pStart pEnd]); 
                else
                    subplot(r, c, n);
                end
                
                val = args(n).value;
                
                if ~isempty(val)
                    imshow(val);
                    % add default axes title
                    title(sprintf('%s <%s>',...
                        args(n).name,class(val)), 'Interpreter','none');
%                     title(sprintf('%s\\color{blue}<%s>',...
%                         args(n).name,class(val)));
                end%if
            end%for
        end
        
        function f = setTitle(f, string, removeNumberTitle)
            % setTitle(f, string, removeNumberTitle)
            
            if nargin < 3
                removeNumberTitle = false;
            end
            
            if ~removeNumberTitle
                string = sprintf('Figure %d <%s>', f.handle.Number, string);
            end
            f.handle.NumberTitle = 'off';
            f.handle.Name = string;
        end
        
        function f = setAxesTitle(f, titleString, varargin)
            N = numel(f.handle.Children);
            for n = 1:numel(titleString)
                t = titleString{n};
                if ~isempty(t)
                    title(f.handle.Children(N-n+1), t, varargin{:});
                end
            end
        end
        
        function f = setLayout(f, mat)
            assert(ismatrix(mat));
            mat = int8(mat);
            assert(max(mat(:)) <= numel(f.data));
            f.layout = mat;
        end
        
        function f = fullscreen(f)
            % no title bar or bottom bar or dock
            f.handle.Position = get(0,'ScreenSize');
        end
        
        %TODO: maxmize minimize, restore
        function f = maxmize(f)
            set(f.handle, 'units','normalized','outerposition',[0 0 1 1]);
        end
        
        function save(f, filename)
            % save(f, filename)
            
            if nargin < 2
                if isempty(f.handle.Name)
                    filename = [inputname(1),'.jpg'];
                else
                    filename = [f.handle.Name,'.jpg'];
                end
            end
            
            [~,~,ext] = fileparts(filename);
            fmt = lower(ext);
            switch fmt
                case {'', '.jpeg','.jpg'}
                    print(f.handle, filename, '-djpeg');
                case '.eps'
                    print(f.handle, filename,'-depsc');
                case '.pdf'
                    print(f.handle, filename,'-dpdf');
                otherwise
                    error('Unsupported File Format.');
            end
            
            fprintf('Figure saved --> %s\n', filename);
        end
        
        function figure(f)
            try
                figure(f.handle);
            catch
                error('Figure has been closed!');
            end
        end
    end
end% classdef

