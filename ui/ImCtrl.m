classdef ImCtrl<UiModel
    %% Controller
    properties (GetAccess = public, SetAccess = private)
        func,args
        h_axes, imshow_args
        value_last % remember last value
    end
   %% UiModel
    methods (Access = protected)
        function h = Handle(obj)
            % TODO: change watch axes
            h = uicontrol('style','text');
            %h = obj.h_axes;
        end
        
        function Callback(~, ~) % uicontrol cannot trigger an update
        end
    end
    
    methods (Access = public)
        function value = getValue(obj,~)
            value = getimage(obj.h_axes); % obj.h_axes == h
        end
        
        function obj = ImCtrl(func, varargin)
            obj = obj@UiModel();
            varargin2args;
            
            obj.func = func;
            obj.args = args;
            obj.setSingleton;
        end
        
        function imshow(obj,varargin)
            text_width = 60;
            
            hold off
            obj.imshow_args = varargin;
            cnt = 0;
            
            for n = 1:numel(obj.args)
                arg = obj.args(n);
                
                if isobject(arg.value) %&& superclass(arg)
                    %TODO: if Position is not set
                    %TODO: panel or child figure
                    %NOTE: Axes cannot be a parent.
                    f = gcf; a = gca;
                    
                    % put uicontrol on the downside of axes
                    height = 20; width = 180; % height = 20; width = 180;
                    
                    cnt = cnt + 1;
                    % relative xy to axis
                    pos = a.Position .* [f.Position(3:4) 0 0] + [-100 50 0 0];
                    % move down and add width height
                    pos = pos + [120 -height*cnt width height];
                    
                    h = arg.value.plot();
                    
                    arg.value.setPosition(pos);
                    arg.value.setCallback(@(~,~)obj.update(n));
                    
                    %add inputname text to the left of uicontrol
                    if isempty(arg.name)
                        arg.name = class(arg.value);
                    end
                    uicontrol('style','text',...
                        'position', pos.*[1 1 0 1] + [-text_width 0 text_width 0],...
                        'units', 'normalized', ...
                        'string',arg.name);
                    
                    % register handle
                    obj.args(n).handle = h;
                end
            end
            
            obj.h_axes = gca;
            obj.update(); % call once
        end
        
        function update(obj, number)
            % number - current caller
            % We turn the interface off for processing.
            %             InterfaceObj=findobj(obj.h_axes,'Enable','on');
            %             set(InterfaceObj,'Enable','off');
            
            % arg/args: read the uicontrol values
            
            % load args value
            if isempty( obj.value_last)
                values = cell(1,numel(obj.args));
            
                for n = 1:numel(obj.args)
                    arg = obj.args(n); % a copy

                    % get value of uicontrols
                    if isobject(arg.value) %&& superclass(arg)
                        values{n} = arg.value.getValue(arg.handle);
                    else
                        values{n} = arg.value;
                    end
                end
            else
                values = obj.value_last;
                arg = obj.args(number);
                values{number} = arg.value.getValue(arg.handle);
            end
            
            obj.value_last = values;
            
            % print string
            fprintf(char(obj.func));
            for n = 1:numel(obj.args)
                if n == 1
                    fprintf('(');
                else
                    fprintf(',');
                end
                
                str = tostring(values{n});
                
                if isempty(str)
                    fprintf('%s',obj.args(n).name);
                else
                    fprintf('%s',str);
                end
            end%for
            fprintf(');\n');
            
            %holdstat = ishold; hold on;
            hold on;
            
            % clear
            % cla(obj.h_axes); cla after source image changed, see
            % ImCtrl.val()
            
            image = obj.func(values{:});
            imshow(image, 'Parent',obj.h_axes,  obj.imshow_args{:});
            
            %if ~holdstat, hold off; end
            
            notify(obj,'Update');
            
            % We turn back on the interface
            % set(InterfaceObj,'Enable','on');
        end
        
        %% override function
        function imwrite(obj, varargin)
            imwrite(+obj, varargin{:});
        end
        
        function data = uplus(obj)
            data = obj.getValue();
        end
        
        function data = im2double(obj)
            data = im2double(obj.getValue());
        end
    end% methods
end% classdef