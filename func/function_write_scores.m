function function_write_scores(ps)

for i = 1:size(ps.score,2);
    fn=fullfile(ps.param.dirSource,[ps.tagPseudo{i},'.scores.tsv']);
    fi=fopen(fn,'w');
    for j = 1:size(ps.sid,1)
        if ismember(ps.param.variant,{'pm2c','2c'})
            fprintf(fi,'%s\t%d\t%s\t%d\t%.4f\n',...
                ps.cas{j,1},ps.sid(j,1),...
                ps.cas{j,2},ps.sid(j,2),ps.score(j,i));
        else
            fprintf(fi,'%s\t%d\t%.4f\n',ps.cas{j},ps.sid(j),ps.score(j,i));
        end
    end
    fclose(fi);
end

numberFields = {'nShow','dsh','decorrLambda','snp','pSignificant'};
fi=fopen(fullfile(ps.param.dirSource,'parameters.out.tsv'),'w');
F=fieldnames(ps.param);
for iField = 1:length(F)
    f=F{iField};
    if ismember(f,numberFields)
        format = '%.4g';
    else
        format = '%s';
    end
    fprintf(fi,['%s\t',format,'\n'],f,ps.param.(f));
end
fclose(fi);