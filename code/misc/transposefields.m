function data=transposefields(data)

for fn=fieldnames(data);
    
    for f=1:length(fn)
        
        %eval(['if size(data.',fn{f},',1)>size(data.',fn{f},',2); data.',fn{f},'=transpose(data.',fn{f},');end;']);
        try
        eval(['data.',fn{f},'=transpose(data.',fn{f},');']);
        %disp(['if size(data.',fn{f},',1)>size(data.',fn{f},',2); data.',fn{f},'=transpose(data.',fn{f},');end;']);
        end
    end
end

