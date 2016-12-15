function ps = function_load_parameters(dir_source)
% FUNCTION_LOAD_PARAMETERS Read parameter file
ps.param.dirSource=dir_source;
fn = fullfile(ps.param.dirSource,'parameters.in.tsv');
numberFields = {'nShow','dsh','decorrLambda','snp','pSignificant','pSuggestive'};
if exist(fn,'file');
    fi = fopen(fn);
    pr = textscan(fi,'%s%s','delimiter','\t');
    fclose(fi);
    for j = 1:length(pr{1})
        if ismember(pr{1}{j},numberFields)
            ps.param.(pr{1}{j})=str2double(pr{2}{j});
        else
            ps.param.(pr{1}{j})=pr{2}{j};
        end
    end
end
%
%
% ##### ASSIGN DEFAULTS #####
if ~isfield(ps.param,'variant')
    ps.param.variant='1c';
end
if ~isfield(ps.param,'mode')
    ps.param.mode='peak';
end
if ~isfield(ps.param,'dsh')
    if strcmp(ps.param.mode,'peak');
        ps.param.dsh=0.025;
    else
        ps.param.dsh=0.010;
    end
end
if ~isfield(ps.param,'scoring')
    ps.param.scoring='chisq';
end
if ~isfield(ps.param,'reference')
    ps.param.reference='hmdb';
end
if ~isfield(ps.param,'decorrLambda')
    ps.param.decorrLambda=1;
end
if ~isfield(ps.param,'nShow');
    ps.param.nShow=8;
end
if ~isfield(ps.param,'pSignificant');
    ps.param.pSignificant=5e-8;
end
if ismember(ps.param.variant,{'pm','pm1c','pm2c'}) && ...
        ~isfield(ps.param,'pSuggestive')
    ps.param.pSuggestive=1e-4;
end