# tms_targeting
Scripts and matlab files to identify an optimal TMS target using fMRI data and e-field modelling. 


#########################
#Dependencies
#########################

1. AFNI (Version: AFNI_19.2.01+)
2. Simnibs (version: 2.1)
3. FreeSurfer (5.3.0+)
4. FSL (5.0.5+)
5. stlTools (version 1.1.0.0)
    https://www.mathworks.com/matlabcentral/fileexchange/51200-stltools
6. Patch Normals (version 1.0.0.0)
    https://www.mathworks.com/matlabcentral/fileexchange/24330-patch-normals
7. MNI template (MNI152_2009_template.nii.gz is included with afni distribution)
8. group mask in MNI space (included)
9. Coil file (included with simnibs distribution)
10. matfile in simnibs format to use as a template (included)
    Update if using a different simnibs distribution



#########################
#Usage
#########################

1. Install dependencies 1-4 by following directions included with software packages
2. Download and copy dependencies 5 and 6 into mfiles directory
3. Copy dependencies 7-10 to results directory
