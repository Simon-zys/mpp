classdef UiModelTemplate < UiModel
    %  Example
    %
    %    I = imread('circuit.tif');
	%    range = RangeSlider([0 1]);
	%    sigma = SimpleSlider([0 10]);
    %
	%    sobel = ImCtrl(@edge, I, 'canny', range, sigma);
	%    Fig(I, sobel);
    %
    %  Project website: https://github.com/baidut/openvehiclevision
    %  Copyright 2016 Zhenqiang Ying [yingzhenqiang-at-gmail.com].
    %
    % See also Popupmenu, ImCtrl, RangeSlider.

    properties (GetAccess = public, SetAccess = private)
        string,prop
    end
    
    %% modify interface if needed
    methods (Access = protected)
        function Position(obj, pos)
        end
        function Callback(obj, func)
        end
    end
    
    methods (Access = protected)
        function h = Handle(obj)
        end
    end
    
    methods (Access = public)
        function obj = Checkbox(string, varargin)
        end
    end
    
    methods (Access = public)
        function obj = UiModelTemplate(span, varargin)
        end
        
        function value = getValue(obj,h)
        end
    end
    
end% classdef