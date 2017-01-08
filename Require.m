classdef Require < handle
    %REQUIRE manage dependency.
    % Instead of using:
    %
    %     required = {'path1', 'path2', 'path3'};
    %     addpath(required{:});
    %     % do something
    %     rmpath(required{:});
    %
    % Just use single line:
    %     
    %     r = Require('path1', 'path2', 'path3');
    % Or
    %     Require('path1', 'path2', 'path3');
    %
    % The required path will be removed automatically.
    % To remove the path mannully:
    %
    %    clear r;
    %
    % If you wana add path permenately, use `addpath` and `savepath`
    % instead.
    
    properties
        path
    end
    methods
        function this = Require(varargin)
            disp('Add requirement')
            this.path = varargin;
            addpath(this.path{:});
        end
        function delete(this)
            disp('Remove requirement');
            rmpath(this.path{:});
        end
    end
end