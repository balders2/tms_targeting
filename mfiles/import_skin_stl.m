function skin=import_skin_stl(skinfname);




[fv.vertices, fv.faces, fv.n, fv.name] = stlReadAscii(skinfname);
fv.patchn=patchnormals(fv);

skin = [fv.vertices, fv.patchn];
clear fv
