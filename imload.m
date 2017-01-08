function I = imload(I, varargin)
%IMLOAD Load an image.

if nargin == 0
    imgFile = 'cameraman.tif';
    raw = imread(imgFile);
    bigger = imload(imgFile, 'minSize', 1280);
    smaller = imload(imgFile, 'maxSize', 50);
    subplot(221); imagesc(raw);       title('Raw Image (uint8)');
    subplot(222); imagesc(bigger);    title('Set minSize to 1280');
    subplot(223); imagesc(smaller);   title('Set maxSize to 50');
    return;
end

default.maxSize = globalVar('imload_maxSize', 480);
default.minSize = globalVar('imload_minSize', 0);
default.gpu = false;
param = loaddefault(varargin, default);

if ischar(I)
    globalVar('fileName', I);
    I = imread(I); 
end

%% Gpu Speedup
if param.gpu
    I = gpuArray(I);
    disp('gpu on.');
end

%% Preprocessing
% denoise

%% Resizing
% It will be too time-consuming to process a large image, so resize it first.
assert(param.maxSize>=0);
if param.maxSize
    len = max(size(I));% length
    if len > param.maxSize
        I = imresize(I, param.maxSize./len);
    end
    [nRow, nCol, ~] = size(I);
    fprintf('image resized to (%dx%d) for saving speed.\n',nRow, nCol);
end
assert(param.minSize>=0);
if param.minSize
    len = max(size(I));% length
    if len < param.minSize
        I = imresize(I, len./param.minSize);
    end
    [nRow, nCol, ~] = size(I);
    fprintf('image resized to (%dx%d) for saving speed.\n',nRow, nCol);
end

%% Normalization
I = max(I, 0);      % avoid resulting complex value when sqrt
I = im2double(I);   % normalized to [0 1]
I = I + eps;        % avoid resulting Inf value when log(I) or []./I

end