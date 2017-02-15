clear all;
funcdir=getenv('DR_METABOMATCHING');
if ~isempty(funcdir)
    addpath(fullfile(funcdir,'func'));
else
    addpath('func');
end
dirs = dir;
dirs_source = {dirs(:).name};
dirs_source = dirs_source(strncmp(dirs_source,'ps.',3));
for i = 1:length(dirs_source)
    clear ps;
    dir_source = dirs_source{i};
    fprintf('+---------------------------------------\n')
    fprintf('|   %s\n+--\n',dir_source);
    ps=function_load_parameters(dir_source);
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
    save(fullfile(dir_source,'ps.mat'),'ps');
    fprintf(' done\n--- writing svg -------------------');
    vis_metabomatching(dir_source);
    fprintf(' done\n----------------------------------- ---+');
    fprintf('\n\n');
end