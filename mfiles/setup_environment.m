function [subdir, scrdir, logdir, resdir, stmdir, emgdir, matdir, fsrdir, mshdir, dtidir, snbdir] = setup_environment(expdir,subject);



%%
% This function sets up the environment for your script
%%


%% setup experiment environment
subdir = strcat(expdir, '/data');
scrdir = strcat(expdir, '/SCRIPTS');
logdir = strcat(expdir, '/logs');
resdir = strcat(expdir, '/results');
stmdir = strcat(expdir, '/stimtimes');
emgdir = strcat(expdir, '/startle');
matdir = strcat(expdir, '/mfiles');
%%

addpath(matdir);
addpath(strcat(matdir, '/stlTools'));
addpath(strcat(matdir, '/patch_normals'));


%% setup subject data environment
if nargin < 2
    fsrdir = [];
    mshdir = [];
    dtidir = [];
    snbdir = [];
    
else
    
    if isnumeric(subject)
        subject = num2str(subject);
    end;
    
    subpath = strcat(subdir, '/', subject);
    cd(subpath);
    
    try
        fsrdir = strcat(subpath, '/', 'fs_', subject);
    catch
        mkdir(fsdir)
        fsrdir = strcat(subpath, '/', 'fs_', subject);
    end
    
    try
        mshdir = strcat(subpath, '/', 'm2m_', subject);
    catch
        mkdir(mshdir)
        mshdir = strcat(subpath, '/', 'm2m_', subject);
    end
    
    try
        dtidir = strcat(subpath, '/', 'd2c_', subject);
    catch
        mkdir(dtidir)
        dtidir = strcat(subpath, '/', 'd2c_', subject);
    end
    
    try
        snbdir = strcat(subpath, '/', 'simnibs_', subject);
    catch
        mkdir(dtidir)
        snbdir = strcat(subpath, '/', 'simnibs_', subject);
    end
    
    
    
end;
%%

