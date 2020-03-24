function save_vectors(expdir, subject, simnibsfname, coil, increment, shiftint)

% save skin.xyz from meshlab with normals to m2m directory
% save center.1d from simnibs as comma separated file to simnibs directory
% be sure that center.1d is projected onto the cortex

[subdir, scrdir, logdir, resdir, stmdir, emgdir, matdir, fsrdir, mshdir, dtidir, snbdir] = setup_environment(expdir,subject);
skinfname = strcat(mshdir, '/', 'skin.stl');

skin=import_skin_stl(skinfname);
simnibsfile = load(simnibsfname);


ctxcenter = simnibsfile.poslist{1,1}.pos(1).matsimnibs(1:3,4)';

ras2tkmrasxfrm = dlmread(strcat(subject, '.warp.1d'));


if nargin < 5
increment = 15;
end;

if nargin < 6
shiftint = 10;
end;


% Creating the tangent plane
[index d] = knnsearch(skin(:,1:3),ctxcenter);
normal = skin(index,:);


%this defines the z vector as the point perpendicular to the 
%scalp at the point on the scalp closest to the hotspot
zvect = normal(4:6);

%this would define the zvector as the shortest distance between 
%the hotspot and the skin
%zvect = (ctxcenter - center)/norm(ctxcenter - center);

%this creates the scalp point, accounting for the default 4mm gap  
%between the coil and the scalp
center = normal(1:3) + zvect*4;

%vector0 is used to create the 2 vectors orthogonal to zvect
%vectors 1 and 2 are orthogonal to zvect and used as a basis
%for the coil placement. 
vector0 = [zvect(1), zvect(3), zvect(2)*-1];
vector1 = cross(zvect,vector0);
vector2 = cross(zvect,vector1);

%these lines just verify that zvect, vector1, and vector2
%are all orthogonal 
atan2d(norm(cross(zvect,vector1)),dot(zvect,vector1))
atan2d(norm(cross(zvect,vector2)),dot(zvect,vector2))
atan2d(norm(cross(vector1,vector2)),dot(vector1,vector2))




%these create directions around the tangent plane of the scalp
%so that you can define coil handle orientations along this plane 
xorient = 0:increment:360;
yorient = xorient + 90;
yind = find(yorient >= 360);

for y=1:length(yind)
    yorient(yind(y)) = yorient(yind(y)) - 360;
end;
xorient(end) = [];
yorient(end) = [];
xvect = [];
xvect = [];

orientsimnibsout = [];
vectarray = [-3, -2, -1, 0, 1, 2];

for m = 1:length(xorient)
    orientsimnibsout = [];
    orientsimnibsout = simnibsfile;
    orientsimnibsout.poslist{1,1}.pos(1).matsimnibs(1:3,4) = center;
    orientsimnibsout.pathfem = strcat(simnibsfile.pathfem, '_', coil, '_', 'vector_', num2str(m));
    orientsimnibsoutfname = strcat(orientsimnibsout.pathfem, '/', simnibsfname(1:length(simnibsfname)-4), '_vector_', num2str(m), '.mat');
    orienttargetcoordsfname = strcat(orientsimnibsout.pathfem, '/', simnibsfname(1:length(simnibsfname)-4), '_vector_', num2str(m), 'target_coords.1d');
    orientvectorcoordsfname = strcat(orientsimnibsout.pathfem, '/', simnibsfname(1:length(simnibsfname)-4), '_vector_', num2str(m), 'vector_coords.1d');
    
    mkdir(orientsimnibsout.pathfem);
    
	%yvect is the vector corresponding to the orientation of the 
	%coil handle
	%xvect is perpendicular to yvect, and is used to define the 
	%orientation of the coil in the other plane
    xvect = (cosd(xorient(m))*vector1 + sind(xorient(m))*vector2);
    yvect = (cosd(yorient(m))*vector1 + sind(yorient(m))*vector2);

    %target coords and vector coords need to be shifted back to 
	%scanner space (RAS vs surface RAS, I think)
    target_coords = orientsimnibsout.poslist{1,1}.pos(1).matsimnibs(1:3,4);
    [warpoutcoords, iwarpoutcoords] = warp_coordinates(expdir, subject, ras2tkmrasxfrm , target_coords);
	iwarpoutcoords(1:2) = iwarpoutcoords(1:2)*-1;
    csvwrite(orienttargetcoordsfname ,iwarpoutcoords(1:3)');
    
    vector_coords = orientsimnibsout.poslist{1,1}.pos(1).matsimnibs(1:3,4) + yvect(1:3)'*shiftint;
    [warpoutcoords, iwarpoutcoords] = warp_coordinates(expdir, subject, ras2tkmrasxfrm , vector_coords);
	iwarpoutcoords(1:2) = iwarpoutcoords(1:2)*-1;
    csvwrite(orientvectorcoordsfname ,iwarpoutcoords(1:3)');
	
	%this loop basically identifies several points along yvect
	%these points can be used to draw spheres in volume space
	%these spheres can then be reconstructed as a surface,
	%which shows up as a line in brainsight. 
    for v = 1:length(vectarray)
        vector_coords = orientsimnibsout.poslist{1,1}.pos(1).matsimnibs(1:3,4) + yvect(1:3)'*shiftint*vectarray(v);
        [warpoutcoords, iwarpoutcoords] = warp_coordinates(expdir, subject, ras2tkmrasxfrm , vector_coords);
		iwarpoutcoords(1:2) = iwarpoutcoords(1:2)*-1;
        orientvectorcoordsfname = strcat(orientsimnibsout.pathfem, '/', simnibsfname(1:length(simnibsfname)-4), '_vector_', num2str(m), '.', num2str(vectarray(v)), '_coords.1d');
        csvwrite(orientvectorcoordsfname ,iwarpoutcoords(1:3)');
    end
    
    
    
    orientsimnibsout.poslist{1,1}.pos(1).matsimnibs(1:3,1) = xvect(1:3);
    orientsimnibsout.poslist{1,1}.pos(1).matsimnibs(1:3,2) = yvect(1:3);
    orientsimnibsout.poslist{1,1}.pos(1).matsimnibs(1:3,3) = zvect(1:3);
    save(orientsimnibsoutfname, '-struct', 'orientsimnibsout', '-v6')

end
