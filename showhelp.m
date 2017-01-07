function showhelp(funcName)
%SHOWHELP Display document (help xxx) and example code
%USAGE 
%    showhelp
%EXAMPLE
%     function b = plus1(a)
%     %PLUS1(a) return b = a + 1;
%     %USAGE b = plus1(a)
%
%     if nargin == 0      % example
%         showhelp        
%         a = 3;
%         b = plus1(a),
%         return         % end example
%     end
%     
%     b = a + 1;
%     end
%     
%     >> plus1
%     PLUS1(a) return b = a + 1;
%     USAGE b = plus1(a)
%     EXAMPLE
%         a = 3;
%         b = plus1(a),
%     Press any key to execute the example or Ctrl+C to quit.
%     b = 
%        4

keyword = mfilename;

if nargin == 0
    try
        ST = dbstack;
        funcName = ST(2).name;
    catch
        help(mfilename);
        return;
    end
end

help(funcName);

s = evalc(['type ' funcName]);
idx = regexp(s,keyword); idxStart = idx(1);
idx = regexp(s(idxStart:end),'return'); idxEnd = idxStart + idx(1) - 2;

exampleCode = s(idxStart+numel(keyword):idxEnd);
if ~isempty(strtrim(exampleCode))
    disp EXAMPLE
    disp(exampleCode);
    disp '>> EXAMPLE';
end


