classdef RangeSlider < UiModel
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
    
    %% Properties
    properties (GetAccess = public, SetAccess = private)
        span
    end
    
    methods (Access = protected)
        function h = Handle(~)
            jRangeSlider = com.jidesoft.swing.RangeSlider(0,20,6,12);  % min,max,low,high
            [h.jhSlider, h.hContainer] = javacomponent(jRangeSlider);
            % set(jRangeSlider, 'MajorTickSpacing',25, 'MinorTickSpacing',5);
            % set(jRangeSlider, 'MajorTickSpacing',25, 'MinorTickSpacing',5, 'PaintTicks',true, 'PaintLabels',true, ...
            % 'Background',java.awt.Color.white);
            % javahandle_withcallbacks.com.jidesoft.swing.RangeSlider
        end
        
        function Callback(obj, func)
            set(obj.handle.jhSlider,'StateChangedCallback',func);
        end
        
        function Position(obj, pos)
            set(obj.handle.hContainer,'Position',pos);
            set(obj.handle.hContainer,'units','normalized');
        end
    end
    
    methods (Access = public)
        function obj = RangeSlider(span, varargin)
            obj = obj@UiModel(varargin{:});
            obj.span = span;
        end
        
        function value = getValue(obj,h)
            % note jRangeSlider can only parse int.
            value = double([h.jhSlider.getLowValue h.jhSlider.getHighValue])/20*double(obj.span(2)-obj.span(1));
            % keep data type
            value = cast(value,'like',obj.span);
        end
    end
end% classdef

% References
% http://undocumentedmatlab.com/blog/sliders-in-matlab-gui