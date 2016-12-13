classdef Checkbox < UiModel
    %
    %  Project website: https://github.com/baidut/openvehiclevision
    %  Copyright 2016 Zhenqiang Ying [yingzhenqiang-at-gmail.com].
    %
    % See also Popupmenu, ImCtrl, RangeSlider.

    properties (GetAccess = public, SetAccess = private)
        string
    end
    
    methods (Access = protected)
        function h = Handle(obj)
            h = uicontrol('Style','checkbox',...
                'String',obj.string,...
                'Value',false);
        end
    end
    
    methods (Access = public)
        function obj = Checkbox(string, varargin)
            obj = obj@UiModel(varargin{:});
            obj.string = string;
        end
    end
    
    methods (Static)
        function value = getValue(h)
            % True(Selected) or false
            value = (get(h,'Value') == get(h,'Max'));
        end
    end
    
end% classdef