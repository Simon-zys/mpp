function varargout = eachchn(rgb, func)
%EACHCHN Execure function independently for each channel of an input image.

% test cases
if nargin == 0
    rgb = im2double(imread('peppers.png'));
    
    title('Histogram Equalization');
    he = eachchn(rgb, @histeq); imshow(Ax(rgb, he)); pause;
    
    title('Color Normalization');
    norm = eachchn(rgb, @(x)(x./sum(rgb, 3))); imshow(Ax(rgb, norm)); pause;
    
    title('Extract R, G, B channels');
    [r,g,b] = eachchn(rgb); hold off; imshow(Ax(rgb, r, g, b));
    
    return;
end

% check inputs
assert( ndims(rgb) == 3 , 'Input must be a 3-dim tensor');
if ~exist('func', 'var'), func = @(x)x; end

% apply function for each channel
nChn = size(rgb, 3); varargout = cell(1, nChn);
for iChn = 1:nChn, varargout{iChn} = func(rgb(:,:,iChn)); end

% reconstruct image
if nargout == 1, varargout = {cat(3, varargout{:})}; end 