function outstruct=catstruct(varargin);


outstruct=[];
for v=1:length(varargin);
    
    tmp=varargin{v};
    if v==1;
        fn=fieldnames(tmp);
        for f=1:length(fn);
            outstruct=setfield(outstruct,fn{f},[]);
        end
    end
    
    for f=1:length(fn);
        try       
        eval(['outstruct.',fn{f},'=[outstruct.',fn{f},' tmp.',fn{f},'];']);
        catch
         disp(['could not append ',fn{f},' for variable ',num2str(v)]);
         eval(['outstruct = rmfield(outstruct,''',fn{f},''')']);
        end
    end
end

    