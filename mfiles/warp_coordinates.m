function [warpoutcoords, iwarpoutcoords] = warp_coordinates(expdir, subject, ras2tkmrasxfrm, hotspot)


[subdir, scrdir, logdir, resdir, stmdir, emgdir, matdir, fsrdir, mshdir, dtidir, snbdir] = setup_environment(expdir,subject);


if length(hotspot) < 4
hotspot(4) = 1;
end;



tkmras2surfrasxfrm = [1, 0, 0, 0; 0, 0, -1, 0; 0, 1, 0, 0; 0, 0, 0, 1];
cat = tkmras2surfrasxfrm * ras2tkmrasxfrm;
warpoutcoords = cat * hotspot;
%warpoutcoords = hotspot;



icat = inv(cat);
iwarpoutcoords = icat * hotspot;
%iwarpoutcoords = hotspot;




