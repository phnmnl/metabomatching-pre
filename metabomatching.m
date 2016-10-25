clear all
addpath('func');
dirs = dir;
dirsSource = {dirs(:).name};
dirsSource = dirsSource(strncmp(dirsSource,'ps.',3));
for i = 1:length(dirsSource)
    clear ps;
    dirSource = dirsSource{i};
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
