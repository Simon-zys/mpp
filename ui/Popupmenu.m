classdef Popupmenu < UiModel
    %  Example
    %
    %    I = imread('circuit.tif');
    %    direction = Popupmenu({'both','horizontal','vertical'});
    %    Sobel = ImCtrl(@edge, I, 'sobel', 0.1, direction);
    %    Fig(I, Sobel);
    %
    %  Project website: https://github.com/baidut/openvehiclevision
    %  Copyright 2016 Zhenqiang Ying [yingzhenqiang-at-gmail.com].
    %
    % See also Popupmenu, ImCtrl, RangeSlider.
    
    properties (GetAccess = public, SetAccess = private)
        menu
    end
    
    methods (Access = protected)
        function h = Handle(obj)
            h = uicontrol('style', 'popupmenu');
            h.String = obj.menu;
        end
    end
    
    methods (Access = public)
        function obj = Popupmenu(menu, varargin)
            obj = obj@UiModel(varargin{:});
            obj.menu = menu;
        end
    end
    
    methods (Static)
        %   val = Popmenu.getValue(h);
        function value = getValue(h)
            maps = h.String;
            value = maps{h.Value};
        end
    end
    
end% classdef