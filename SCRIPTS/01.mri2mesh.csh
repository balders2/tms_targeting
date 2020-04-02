#!/bin/tcsh

setenv expdir `dirname $PWD`
setenv subdir ${expdir}/data
setenv scrdir ${expdir}/SCRIPTS
setenv stmdir ${expdir}/stimtimes
setenv resdir ${expdir}/results
setenv SUBJECTS_DIR ${expdir}/anat
setenv outfile `basename $0`
setenv subs `ls ${subdir}`


foreach subject (${subs})

setenv logdir ${subdir}/${subject}/code
setenv swarmfile ${scrdir}/rm.${outfile}.swarm
setenv logfile ${logdir}/${outfile}.${subject}
setenv infile ${logdir}/00.tar.csh.${subject}

if (-e ${logfile}) then 
	echo "this script has been run for subject $subject"
else

cd ${subdir}/${subject}
setenv t1 `ls anat_T1w.nii* | head -n1`
setenv t2 `ls anat_T2w.nii* | head -n1`

setenv dti `ls dwi_*98*_dir-ap.nii | head -n1`
setenv bvals `ls dwi_*98*_dir-ap.bval | head -n1`
setenv bvecs `ls dwi_*98*_dir-ap.bvec | head -n1`

#####start of here file
cat > ${logfile} <<End-of-message-fool
#!/bin/bash
source ~/.bashrc
module load freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh > /dev/null

##fsl
module load fsl/5.0.11
whereis mri2mesh

cd ${subdir}/${subject}
mkdir simnibs_${subject}


mri2mesh \
--all \
${subject} \
$t1 \
$t2


dwi2cond \
--all \
${subject} \
${dti} \
${bvals} \
${bvecs}

@SUMA_Make_Spec_FS \
-sid ${subject} \
-fspath ${subdir}/${subject}/fs_${subject}
-final NN


@SUMA_AlignToExperiment \
-exp_anat ${subject}_T1fs_conform.nii.gz \
-surf_anat fs_${subject}/SUMA/${subject}_SurfVol+orig \
-prefix ${subject}_SurfVol_aligned



3dAllineate \
-NN \
-master ${subject}_T1fs_conform.nii.gz \
-1Dmatrix_apply ${subject}_SurfVol_aligned.A2E.1D \
-input fs_${subject}/SUMA/aparc.a2009s+aseg.nii \
-prefix ${subject}.fs_aparc.a2009s+aseg.nii

3dAllineate \
-NN \
-master ${subject}_T1fs_conform.nii.gz \
-1Dmatrix_apply ${subject}_SurfVol_aligned.A2E.1D \
-input fs_${subject}/SUMA/aparc.a2009s+aseg_REN_gm.nii.gz \
-prefix ${subject}.fs_aparc.a2009s+aseg_REN_gm.nii



3dmask_tool \
-dilate_input 1 \
-input ${subject}.fs_aparc.a2009s+aseg_REN_gm.3mm.nii \
-prefix ${subject}.fs_aparc.a2009s+aseg_REN_gm.3mm.dilate.nii


3dmask_tool \
-dilate_input 6 -6 \
-input ${subject}.fs_aparc.a2009s+aseg.nii \
-prefix ${subject}.fs_aparc.a2009s+aseg.mask.nii

3dcalc \
-a ${subject}_T1fs_conform.nii.gz \
-b ${subject}.fs_aparc.a2009s+aseg.mask.nii \
-expr "a*step(b)" \
-prefix ${subject}.anat.aparc_ss

3dQwarp \
-allineate \
-blur 2 2 \
-iwarp \
-base ${resdir}/MNI152_2009_template.nii.gz \
-source ${subject}.anat.aparc_ss+orig \
-prefix ${subject}.anat.aparc_ss

3dNwarpApply \
-nwarp "${subject}.anat.aparc_ss_WARPINV+tlrc" \
-dxyz 2 \
-master ${subject}.anat.aparc_ss+orig \
-source ${resdir}/rdlpfc.fmask.nii \
-prefix $subject.rdlpfc.fmask.nii 


#####end of here file
End-of-message-fool

chmod a+rwx ${logfile}
${logfile}

endif
end

