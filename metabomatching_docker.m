clear all;
warning('off','all');
addpath('func');
dirs = dir('/mm-ps/');
k=0;
dirsSource={};
for i = 1:length(dirs)
    if strncmp(dirs(i).name,'ps.',3) && dirs(i).isdir
        k=k+1;
        dirsSource{k,1} = dirs(i).name;
    end
end
if isempty(dirsSource)
    mkdir('/mm-ps/ps.test/');
    copyfile('/mm-tp/ps.test/*','/mm-ps/ps.test/');
    dirsSource={'ps.test/'};
end
for i = 1:length(dirsSource)
    clear ps;
    dirSource = ['/mm-ps/',dirsSource{i}];
    fprintf('+---------------------------------------\n')
    fprintf('|   %s\n+--\n',dirSource);
    ps=function_load_parameters(dirSource);
    fprintf('--- loading data ------------------');
    ps=build_spectrum_database(ps);
    ps=function_import_correlation(ps);
    ps=function_import_pseudospectra(ps);
    ps=function_build_mim(ps);
    fprintf(' done\n--- building transition matrix ----');
    ps=function_metabomatching_core(ps);
    fprintf(' done\n--- metabomatching ----------------');
    fprintf(' done\n--- writing scores ----------------');
    function_write_scores(ps);
    save(fullfile(dirSource,'ps.mat'),'ps');
    fprintf(' done\n--- writing svg -------------------');
    vis_metabomatching(dirSource);
    fprintf(' done\n----------------------------------- ---+');
    fprintf('\n\n');
end
fprintf('+---------------------------------------\n')
fprintf('--- converting svg to pdf ---------');
system('find /mm-ps -name "*.svg" -type f | while read file; do inkscape "${file}" --export-pdf="${file%.svg}.pdf"; done');
fprintf(' done\n----------------------------------- ---+');
fprintf('\n\n');
