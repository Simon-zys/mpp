classdef Ax < handle
    %Ax Do more than built-in axis/axes with less code.
    %
    %   Examples
    %   --------
    %
    %       %
    %       football = imread('football.jpg');
    %       peppers = imread('peppers.png');
    %       cameraman = imread('cameraman.tif');
    %       road = imread('um_000017.png');
    %       imshow(Ax(road,peppers,cameraman,road));
    %
    %       ax = Ax(road,peppers,cameraman,road)
    %       ax.setLayout([1 1 1;2 2 3;4 4 4]);
    %       imshow(ax);
    %
    %       imshow(Ax(road,road,road,road,road,road, road,road,road,road,road));
    
    % for montage
    %¡¡FILENAMES must contain images that are the same size.
    properties (GetAccess = public, SetAccess = private)
        handle
        config
        layout
        data
        hText
        hFig
    end
    
    methods (Access = public)
        function a = Ax(varargin)
            varargin2args;
            a.data =args;
            %default layout
        end
        
        function a = setLayout(a, mat)
            assert(ismatrix(mat));
            mat = int8(mat);
            assert(max(mat(:)) <= numel(a.data));
            a.layout = mat;
        end
        
        function setText(a, string)
            assert(~isempty(a.hText)); % please use ax.setText after imshow(ax)
            %if isempty(a.hText), a.hText = string; end
            for n = 1:numel(string)
                a.hText{n}.String = string(n);
            end
        end
        
        function h = imshow(a, varargin)
            h = gca; % varargin:parent
            imshow_args = varargin;
            defaultCfg.imageStyle = 'resize';%'leftTop'; %'resize';%
            defaultCfg.textStyle = 'leftTop';
            cfg = loaddefault(a.config, defaultCfg);
            
            if isempty(a.layout)
                nBlock = numel(a.data);
                nRow = zeros(1,nBlock);
                nCol = zeros(1,nBlock);
                nDim = zeros(1,nBlock);
                for n = 1:nBlock
                    [nRow(n), nCol(n), nDim(n)] = size(a.data(n).value);
                end
                blockSize = [max(nRow(:)), max(nCol(:))];
                rc = Ax.bestLayoutRC(nBlock, blockSize);
                mat = zeros(rc)';
                mat(1:nBlock) = 1:nBlock;
                mat = mat';
                mat
                %remove empty row
                % group rows to make rows approx cols may produce empty space
                % try imshow(Ax(road, road, road, road, road, road)) 
                % | road | road |
                % | road | road |
                % | ---- | ---- |
                % | road | road |
                % | XXXX | XXXX | <-- remove it
                p = find(mat(:,1)~=0, 1, 'last');
                a.layout = mat(1:p,:);
            end
            
            disp layout:
            disp(a.layout);
            
            rooms = Ax.buildRooms(a.layout, {a.data.value}, {a.data.name});
            unitSize = Ax.bestUnitSize(rooms);
            
%             xlim([0 unitSize(1)*size(a.layout,2)]);
%             ylim([0 unitSize(2)*size(a.layout,1)]);

            % plot boundary first so that layout can keep no change.
            %axis([0 unitSize(1)*size(a.layout,2) 0 unitSize(2)*size(a.layout,1)]);
            imshow(zeros([unitSize(2)*size(a.layout,1), unitSize(1)*size(a.layout,2)]));
            hold on;
            N = numel(rooms);
            a.hFig = cell(1,N); a.hText = cell(1,N); 
            for n = 1:N
                [a.hFig{n}, a.hText{n}] = Ax.dispRoom(rooms(n), unitSize, cfg.imageStyle, cfg.textStyle, imshow_args{:});
            end
            %rectangle('Position',[10 10 unitSize(2)*size(a.layout,1)-10 unitSize(1)*size(a.layout,2)-10],'EdgeColor','b','LineWidth',5);
        end
    end
    
    methods (Static, Access = public) % public
        function sz = bestUnitSize(rooms)
            N = numel(rooms);
            sizes = zeros([N,2]);
            for n = 1:N
                % note x-column y-row
                sizes(n,2) = size(rooms(N).image,1) / rooms(N).size(2);
                sizes(n,1) = size(rooms(N).image,2) / rooms(N).size(1);
            end
            sz = max(sizes); 
        end
        
        function rc = bestLayoutRC(nBlock, blockSize)
            if nargin < 2
                r = max(1, floor(sqrt(nBlock)));
                c = max(1, ceil(nBlock/r));
                rc = [r,c];
            else
                %% best arragement  r x c
                % Considering the size of image
                % K-image will be arrange in a group if width to height
                % is K
                N = nBlock;
                N_ROW = blockSize(1);
                N_COL = blockSize(2);
                
                % group rows to make rows approx cols may produce empty space
                % try imshow(Ax(road, road, road, road, road, road)) 
                % | road | road |
                % | road | road |
                % | ---- | ---- |
                % | road | road |
                % | XXXX | XXXX |
                if N_COL > N_ROW
                   nGroup = round(N_COL/N_ROW);
                   rc = [nGroup 1] .* Ax.bestLayoutRC( ceil(N/nGroup) ); % ceil
                else
                   nGroup = round(N_ROW/N_COL);
                   rc = [1 nGroup] .* Ax.bestLayoutRC( ceil(N/nGroup) ); % ceil
                end
            end
        end
        
        function [hFig, hText] = dispRoom(room, unitSize, imageStyle, textStyle, varargin)
            
             imgXYSize = [size(room.image,2), size(room.image,1)];
             
            %TODO: custom dispRoom method
            
            % textMode
            % imshow_args, text_args
            switch lower(imageStyle)
                case 'resize'
                    xydata = [room.location.*unitSize; (room.location+room.size).*unitSize];
%                         'YData', [room.size(1) room.location(1)*unitSize(1)],...
%                         'XData', [room.size(2) room.location(2)*unitSize(2)]...
                case 'lefttop'
                    xydata = [room.location.*unitSize; room.location.*unitSize+imgXYSize];
%                         'YData', [room.location(1)*unitSize(1)  size(room.image,1)],...
%                         'XData', [room.location(2)*unitSize(2)  size(room.image,2)]...
                case 'center'
                    xydata = [room.location.*unitSize+imgXYSize/2; room.location.*unitSize+imgXYSize];
%                         'YData', [room.location(1)*unitSize(1)+size(room.image,1)/2  size(room.image,1)],...
%                         'XData', [room.location(2)*unitSize(2)+size(room.image,2)/2  size(room.image,2)]...
                otherwise
                    error('unkown imageStyle');
            end
%             xydata
            hFig = imshow(room.image, 'XData', xydata(:,1), 'YData', xydata(:,2));
%             
%             hold on;
            if~isempty(varargin), set(hFig,varargin{:}); end 
            
            fontSize = 20;
            offset = 7;
            % location (x y) position (x y w h)
            switch lower(textStyle)
                case 'lefttop'
                    hText = text('string',room.title,...
                         'pos', room.location.*unitSize + [offset offset+fontSize]); % + cfg.TextOffset
                case 'righttop'
                    hText = text('string',room.title,...
                         'pos', room.location.*unitSize + [offset offset+fontSize] + [0 size(room.image,2)]); % + cfg.TextOffset
                otherwise
                    error('unkown DisplayMode');
            end
            
            set(hText, 'FontSize',fontSize, 'BackgroundColor','white','interpreter','latex');
        end
        
        function rooms = buildRooms(mat, images, titles)
            N = numel(images);
            rooms = repmat(struct, [1 N]);
            idx = 0;
            for n = 1:N
                %% TODO r c find max min is better
                [rStart, cStart] = find( mat==n, 1, 'first');
                if isempty(rStart)
                    continue;
                else
                    idx = idx + 1; % alloc room
                end
                [rEnd, cEnd] =  find( mat==n, 1, 'last');
                % note x-column y-row
                rooms(idx).size = [cEnd-cStart+1, rEnd-rStart+1];
                % [rEnd - rStart +1, cEnd - cStart +1]; => [rEnd - rStart, +1, cEnd - cStart, +1]
                rooms(idx).location = [cStart-1, rStart-1]; 
                rooms(idx).image = images{n};
                rooms(idx).title = titles{n};
            end
            
            rooms(idx+1:end) = []; % remove empty rooms
        end
    end
    
end