classdef UiModel < handle
    
    properties (GetAccess = protected, SetAccess = private)
        handle
        singleton
        prop % additional properties
    end
    
    events
        Update
    end
    
    methods (Access = public)
        
        function obj = UiModel(varargin)
            obj.singleton = false;
            obj.handle = [];
            obj.prop = varargin;
        end
        
    end
    
    methods (Access = protected)
        %% Interface
        function Callback(obj, func)
            obj.handle.Callback = func;
        end
        
        function Position(obj, pos)
            obj.handle.Position = pos;
            obj.handle.Units = 'normalized';
        end
        
        function h = Handle(~)
            h = uicontrol('style','text','string','UiModel');
        end
    end
    
    methods (Access = public)
        %% Basic Usage
        function obj = setPosition(obj, pos)
            assert(~isempty(obj.handle));
            obj.Position(pos);
        end
        
        function obj = setCallback(obj, func)
            assert(~isempty(obj.handle));
            
            if obj.singleton
                obj.addlistener('Update',func);
            else
                obj.Callback(func);
            end
        end
        
        function value = getValue(obj, handle)
            if nargin < 2, handle = obj.handle;
            end
            
            assert(handle);
            value = handle.Value;
        end
        
        %% Advanced Usage
        function obj = setSingleton(obj)
            obj.singleton = true;
        end
        
        function h = plot(obj, varargin)
            if obj.singleton && ~isempty(obj.handle)
                h = obj.handle;
            else
                h = obj.Handle;
                if numel(obj.prop), set(h, obj.prop{:}); end
                
                obj.handle = h;
                
                if obj.singleton
                    obj.Callback(@(~,~)notify(obj,'Update'));
                end
            end
        end
        
    end% methods
end% classdef