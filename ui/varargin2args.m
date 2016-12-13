%function args = NameValuePair(varargin)
%NameValuePair Build a struct with fields of name and value from varargin.
% a = 1; b = [2 3]; c = {4 5 6};
% abc = NameValuePair(a, b, c);
% disp(abc(2)); % => name: 'b' value: [2 3]

narg = numel(varargin);
args = repmat(struct('name',[],'value',[]),[1 narg]);

for n = 1 : narg
    var = varargin{n};
    varname = inputname(n+nargin-narg);
    if isempty(varname) && ischar(var)
        varname = var;
    end
    
    % imshow('peppers.png');title(['line1';'line2'])
    
    args(n).name = varname;
    args(n).value = var;
end

clear narg n varname var