classdef PixelPick < UiModel
    properties (GetAccess = public, SetAccess = public)
        imageSrc
        pickWay
        watchObj
    end
    
    methods (Access = protected)
        function h = Handle(obj)
            h = uicontrol('Style', 'pushbutton', 'String', 'Pick Pixel...');
            %h.Position= obj.Position .* [1 1 0.3 1];
        end
    end
    
    methods (Access = public)
        function this = PixelPick(imageSrc, pickWay, watchObj)
            % impoint (axes )
            % 54re
            this.imageSrc = imageSrc;
            this.pickWay = lower(pickWay);
            
            if nargin < 3
                this.watchObj = imageSrc;
            else
                this.watchObj = watchObj; % where to pick pixels
            end
            
            %disp(watchObj)
        end
        
        function value = getValue(this,~)
            if isempty(this.watchObj.h_axes)
               value = []; return; 
            end
            
            %a = gca;
            axes(this.watchObj.h_axes);
            
            func = ['im', this.pickWay];
            h = feval(func);%, this.axes, []);
            position = wait(h); % NOTE: use double click to finish choosing
            
            %axes(a);
            
            x = position(:,1);
            y = position(:,2);
            
            % line need to be extended to rect, or no pixel will be
            % selected
            
            image = im2double(this.imageSrc); 
            
            bw = roipoly(image, x, y);
            if size(image,3) == 3
                r = image(:,:,1);
                g = image(:,:,2);
                b = image(:,:,3);
                value = cat(2, r(bw), g(bw), b(bw));
            else
                value = image(bw);
            end
        end
    end
end% classdef