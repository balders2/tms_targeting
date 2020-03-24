function save_simnibs_file(expdir, subject, contrast, coil, simnibsfname)

[subdir, scrdir, logdir, resdir, stmdir, emgdir, matdir, fsrdir, mshdir, dtidir, snbdir] = setup_environment(expdir,subject);



load(strcat(resdir, '/template.simnibs.mat'));
hotspot = dlmread(strcat(subject, '.', contrast, '.1d'))';
hotspot(1:2) = hotspot(1:2)*-1;

ras2tkmrasxfrm = dlmread(strcat(subject, '.warp.1d'));
[warpoutcoords, iwarpoutcoords] = warp_coordinates(expdir, subject, ras2tkmrasxfrm , hotspot);




subid = subject;
subjectdir = strcat(subdir, '/', subject);
subpath = mshdir;
fnamehead = strcat(subdir, '/', subject, '/', subject, '.msh');
pathfem = snbdir;
eeg_cap = strcat(subjectdir, '/eeg_positions/EEG10-20_UI_Jurak_2007.csv');
fname_tensor = strcat(dtidir, '/dti_results_T1space/DTI_conf_tensor.nii.gz');
%%%%%%%%%%%add in coil name here
poslist{1}.fnamecoil = strcat(resdir, '/', coil);




poslist{1,1}.pos.matsimnibs(1:3,4) = warpoutcoords(1:3);

save(strcat(subjectdir, '/', simnibsfname), 'date', 'eeg_cap', 'fiducials', 'fields', 'fname_tensor', 'fnamehead', 'map_to_fsavg', 'map_to_MNI', 'map_to_surf', 'map_to_vol', 'pathfem', 'poslist', 'subjectdir', 'type', 'vol', 'volfn', '-v6');
%save(strcat(subjectdir, '/', simnibsfname), 'date', 'fiducials', 'fields', 'fname_tensor', 'fnamehead', 'map_to_fsavg', 'map_to_MNI', 'map_to_surf', 'map_to_vol', 'pathfem', 'poslist', 'subjectdir', 'type', 'vol', 'volfn', '-v6');



