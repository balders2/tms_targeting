function vect_target_wrapper(expdir, subject, contrast, coil)


[subdir, scrdir, logdir, resdir, stmdir, emgdir, matdir, fsrdir, mshdir, dtidir, snbdir] = setup_environment(expdir,subject);


simnibsfname = strcat(subject, '.', contrast, '.', coil, '.simnibs.mat');
save_simnibs_file(expdir, subject, contrast, coil, simnibsfname);
save_vectors(expdir, subject, simnibsfname, coil);


exit

%save_alttargets(expdir, subject, simnibsfname);
%cd(strcat(subdir, '/', subject));
%fnames = 'alt_target';
%files = dir(strcat('*', fnames, '*mat'));

%for f=1:length(files)
%  simnibsfname = files(f).name
%  save_vectors(expdir, subject, simnibsfname);
%end;


