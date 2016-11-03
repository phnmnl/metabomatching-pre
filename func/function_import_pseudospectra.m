function ps=function_import_pseudospectra(ps)
% FUNCTION_IMPORT_PSEUDOSPECTRA Read pseudospectrum files
if exist(ps.param.dirSource,'dir')
    fil=dir(fullfile(ps.param.dirSource,'*.pseudospectrum.tsv'));
    if length(fil)>0
        for f={'beta','se','p','tagPseudo'}
            if isfield(ps,f{1});
                ps = rmfield(ps,f{1});
            end
        end
        for i = 1:length(fil)
            fi = fopen(fullfile(ps.param.dirSource,fil(i).name));
            lb = textscan(fi,'%s%s%s%s',1,'delimiter','\t');
            pr = textscan(fi,'%f%f%f%f','delimiter','\t');
            fclose(fi);
            for iField=1:length(lb)
                ps.(lb{iField}{1})(:,i)=pr{iField};
            end
            ps.tagPseudo{i,1} = strrep(fil(i).name,'.pseudospectrum.tsv','');
        end
        ps.shift = ps.shift(:,1);
        %ps.param.dirSource = dirSource;
        %
        if ismember(ps.param.variant,{'pm','pm1c','pm2c'})
            F=fieldnames(ps);
            nr = length(ps.tagPseudo);
            for jf = 1:length(F)
                f=F{jf};
                if ~ismember(f,{'param','shift'})
                    if ismember(f,{'beta','se','p'});
                        ps.(f)=[ps.(f),ps.(f)];
                    else
                        ps.(f)=[ps.(f);ps.(f)];
                    end
                end
            end
            for jr = 1:nr
                ps.tagPseudo{jr}=[ps.tagPseudo{jr},'pos'];
                se = ps.p(:,jr)<ps.param.pSuggestive & ps.beta(:,jr)<0;
                ps.beta(se,jr)=-1e-6;
                ps.pm{jr,1}='positive';
            end
            for jr = (nr+1):2*nr
                ps.tagPseudo{jr}=[ps.tagPseudo{jr},'neg'];
                se = ps.p(:,jr)<ps.param.pSuggestive & ps.beta(:,jr)>0;
                ps.beta(se,jr)=1e-6;
                ps.pm{jr,1}='negative';
            end
        end
        
    else
        error('metabomatching:noPS','No pseudospectrum files found (*.pseudospectrum.tsv)');
    end
else
    error('metabomatching:noDS','Source directory %s does not exist',ps.param.dirSource);
end
