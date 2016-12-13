%{
% TODO:
% Done:
% - remember opened folder last time
File = FilePick();
Image = ImCtrl(@imread, File);
Fig(Image);
.demo
%}
classdef FilePick < UiModel
    properties (GetAccess = public, SetAccess = public)
        uigetfile_params
    end
    
    methods (Access = protected)
        function h = Handle(obj)
            % h can be a panel
            % uicontrol('Style', 'pushbutton', 'String', 'Prev');
            % uicontrol('Style', 'pushbutton', 'String', 'Next');
            
            h = uicontrol('Style', 'pushbutton', 'String', 'Choose...');
            %h.Position= obj.Position .* [1 1 0.3 1];
        end
    end
    
    methods (Access = public)
        function obj = FilePick(varargin)
            %% optargs = {DefaultName,FilterSpec,DialogTitle};
            numvarargs = numel(varargin);
            FilterSpec = {'*.j*pg;*.tif*;*.png;*.gif;*.bmp;*.pgm;','All Image Files';...
                    '*.*','All Files' };
            DialogTitle = 'Choose an image';
            DefaultName = fullfile(matlabroot,'toolbox\images\imdata');
            optargs = {DefaultName,FilterSpec,DialogTitle};
            
            if numvarargs > numel(optargs)
                error('myfuns:somefun2Alt:TooManyInputs', ...
                    'requires at most %d optional inputs',numel(optargs));
            end
            
            optargs(1:numvarargs) = varargin;

            obj.uigetfile_params = optargs([2 3 1]);
        end
        
        function v = getValue(obj,~)
            persistent value
            persistent pathName
            [fileName,pathName,~] = uigetfile(obj.uigetfile_params{:});
            % when cancel % cancel at first time?
            if ~isempty(fileName)
                value = fullfile(pathName, fileName);
                obj.uigetfile_params{3} = pathName;
            end
            v = value;
            % keep last value? 'lena' 
            
            %cla all children
%             f = gcf;
%             for n = 1:numel(f.Children)
%              a = f.Children(n); %axes
%              reset(a.Children); %reset Image
%              %cla(f.Children(n), '');
%             end
        end
    end
    
    methods (Static)
        function fullname = one(varargin) 
        % pick one file
            [FileName,PathName,~] = uigetfile(varargin{:});
            fullname = fullfile(PathName, FileName);
        end
    end
end% classdef