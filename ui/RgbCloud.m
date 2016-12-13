%{
image = ImCtrl(@imread, FilePick(cd));
rgbCloud = ImCtrl(@RgbCloud, PixelPick(image, 'freehand')) % Line

Fig(image, rgbCloud)
set(gca,'zTick',[0:10:255]/255);
set(gca,'xTick',[0:10:255]/255);
set(gca,'yTick',[0:10:255]/255);
grid on;

% TODO: add dofitting
%}
classdef RgbCloud
    properties (GetAccess = public, SetAccess = public)
        R,G,B
    end
    
    methods (Access = public)
        function this = RgbCloud(pixels, dofitting)
            if isempty(pixels)
                return;
            end
            if nargin < 2
                dofitting = false;
            end
            this.R = pixels(:,1);
            this.G = pixels(:,2);
            this.B = pixels(:,3);
            
            %this.
        end
        
        function imshow(this,varargin)
            hold on;
            vis.rgbspace(this.R, this.G, this.B, []);
        end
    end
    
    methods (Static)
    end
end% classdef
