classdef SimpleSlider < UiModel
    %  Example
    %
    %    I = imread('circuit.tif');
    %    thresh = SimpleSlider([0,0.2], 'Value', 0.08);
    %    Sobel = ImCtrl(@edge, I, 'sobel', thresh);
    %    imshow(Sobel); % Fig(I, Sobel)
    %
    %    I = imread('circuit.tif');
    %    thresh = SimpleSlider([0,0.2], 'Value', 0.08);
    %    Sobel = ImCtrl(@edge, I, 'sobel', thresh);
    %    Prewitt = ImCtrl(@edge, I, 'prewitt', thresh);
    %    Canny = ImCtrl(@edge, I, 'canny', thresh);
    %    thresh.setSingleton();
    %    Fig(I, Sobel, Prewitt, Canny)
    %
    %  Project website: https://github.com/baidut/openvehiclevision
    %  Copyright 2016 Zhenqiang Ying [yingzhenqiang-at-gmail.com].
    %
    % See also Popupmenu, ImCtrl, RangeSlider.
    
    
    %TODO: check int* support
    
    %% Properties
    properties (GetAccess = public, SetAccess = private)
        span % min and max value
    end
    
    methods (Access = public)
        function obj = SimpleSlider(span, varargin)
        % Slider([min max],Name,Value ...)
            obj = obj@UiModel(varargin{:});
            obj.span = span; % span [min minorstep majorstep max]
        end
        
    end
    
    methods (Access = protected)
        function h = Handle(obj)
            h = uicontrol('style', 'slider', ...
                'min', obj.span(1), ...
                'max', obj.span(2), ...
                'value', mean([obj.span(1),obj.span(2)]));  % Note: 'value', ( obj.span(1) + obj.span(2) )/2 may change value type, eg. uint8 -> double
        end
        
    end
    
    methods (Access = public)
        function value = getValue(obj,h)
            value = cast(h.Value, 'like', obj.span);
        end
        
    end
end% classdef