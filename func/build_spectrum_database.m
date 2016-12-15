function ps = build_spectrum_database(ps)
% BUILD_SPECTRUM_DATABASE  Read spectrum database file(s)
type = ['slo',ps.param.mode(1)];
mmdb = ps.param.reference;
dirSource=ps.param.dirSource;
scriptdir=getenv('METABOMATCHING_SCRIPTDIR');
if ~isempty(scriptdir)
	datadir=fullfile(scriptdir, 'data');
else
	datadir='data';
end

if strcmp(ps.param.reference,'existing')

    fil = dir(fullfile(dirSource,['*.',type]));
    if isempty(fil)
        tst.failed = true;
    end
    
else
    
    fil = dir(fullfile(dirSource,[ps.param.reference,'*',type]));
    if isempty(fil)
		copyfile(fullfile(datadir, [ps.param.reference,'*',type]),dirSource);
    end
    fil = dir(fullfile(dirSource,[ps.param.reference,'*',type]));
    
end

if strcmp(type,'slop')
    for iFil = 1:length(fil);
        fi = fopen(fullfile(dirSource,fil(iFil).name));
        pr = textscan(fi,'%s%f%f%f','delimiter','\t');
        [~,reo] = unique(pr{4});
        metdb.cas = pr{1}(reo);
        metdb.sid = pr{4}(reo);
        for iCas = 1:length(metdb.cas)
            sl = find(strcmp(metdb.cas{iCas},pr{1}));
            metdb.pos{iCas,1} = pr{2}(sl);
            metdb.hnh{iCas,1} = pr{3}(sl);
        end
    end
    
elseif strcmp(type,'slom')
    for iFil = 1:length(fil)
        fi = fopen(fullfile(dirSource,fil(iFil).name));
        pr = textscan(fi,'%s%f%f%f%f','delimiter','\t');
        [~,reo] = unique(pr{5});
        metdb.cas = pr{1}(reo);
        metdb.sid = pr{5}(reo);
        for iCas = 1:length(metdb.cas)
            sl = find(strcmp(metdb.cas{iCas},pr{1}));
            metdb.pos{iCas,1}(:,1) = pr{2}(sl);
            metdb.pos{iCas,1}(:,2) = pr{3}(sl);
            metdb.hnh{iCas,1} = pr{4}(sl);
        end
    end
end
% CAS2Name file
for i = 1:length(metdb.cas)
    metdb.name{i,1}='unnamed';
end
if strcmp(ps.param.reference,'existing')
    fil = dir(fullfile(dirSource,'*.casname'));
else
    fil = dir(fullfile(dirSource,'zzz*casname'));
    if isempty(fil)
        copyfile(fullfile(datadir,'zzz*casname'),ps.param.dirSource);
    end
    fil = dir(fullfile(datadir,'*.casname'));
end
if ~isempty(fil)
    for iFil = 1:length(fil)
        fi=fopen(fullfile(dirSource,fil(iFil).name));
        pr=textscan(fi,'%s%s','delimiter','\t');
        fclose(fi);
        se = find(strcmp(metdb.name,'unnamed'));
        [ism,loc]=ismember(metdb.cas(se),pr{1});
        metdb.name(se(ism))=pr{2}(loc(ism));
    end
end
save(fullfile(dirSource,'metdb.mat'),'metdb');
