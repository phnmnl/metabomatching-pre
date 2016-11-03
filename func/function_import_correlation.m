function ps = function_import_correlation(ps)
% FUNCTION_IMPORT_CORRELATION  Import feature-feature correlation matrix

if ps.param.decorrLambda<1
    try 
        ps.correlation=csvread(fullfile(ps.param.dirSource,'correlation.csv'));        
    catch
        error('metabomatching:importCorrelation','correlation file %s not found',...
            fullfile(ps.param.dirSource,'correlation.csv'));
    end
end