#!/bin/tcsh

setenv expdir `dirname $PWD`
setenv subdir ${expdir}/data
setenv scrdir ${expdir}/SCRIPTS
setenv resdir ${expdir}/results
setenv outfile `basename $0`
setenv subs `ls ${subdir}`
setenv functag task-cog


foreach subject (${subs})

setenv logdir ${subdir}/${subject}/code
setenv tsvdir events
setenv logfile ${logdir}/${outfile}.${subject}

if (-e ${logfile}) then 
	echo "this script has been run for subject $subject"
else

cd ${subdir}/${subject}








setenv t1 `find ${subdir}/${subject} -name "${subject}_T1fs_conform.nii*" | head -n1`
setenv epi `ls func_${functag}_run-0?_bold_dir-ap.nii`





setenv buttontime `find ${tsvdir} -name "*${functag}*1d" | grep button`
setenv nobuttontimes `find ${tsvdir} -name "*${functag}*1d" | grep -v button`
setenv stimtimes "${buttontime} ${nobuttontimes}"
setenv stimlabels `echo $stimtimes | tr " " "\n" | cut -d"_" -f2 | cut -d"." -f1`

setenv numbutton `echo ${buttontime} | wc -w`
setenv numnobuttons `echo ${nobuttontimes} | wc -w`
setenv numstims `echo ${stimtimes} | wc -w`

setenv buttontype `yes times | head -n${numbutton}`
setenv nobuttontypes `yes AM1 | head -n${numnobuttons}`
setenv stimtypes "${buttontype} ${nobuttontypes}"

setenv buttonmodel `yes "'BLOCK(1,1)'" | head -n${numbutton}`
setenv nobuttonmodels `yes "'dmBLOCK(1,1)'" | head -n${numnobuttons}`
setenv stimmodels "${buttonmodel} ${nobuttonmodels}"




































#####start of here file
cat > ${logfile} <<End-of-message-fool

cd ${subdir}/${subject}

afni_proc.py \
-subj_id ${subject} \
-script code/proc.${subject}.${functag}.csh \
-scr_overwrite \
-out_dir ${subject}.${functag}_proc \
-copy_anat ${t1} \
-dsets ${epi} \
-blocks tshift align tlrc volreg blur mask scale regress \
-align_opts_aea \
-giant_move \
-cost lpc+ZZ \
-tlrc_base MNI152_T1_2009c+tlrc \
-tlrc_NL_warp \
-volreg_align_to MIN_OUTLIER \
-volreg_align_e2a \
-mask_epi_anat yes \
-blur_in_mask yes \
-blur_size 2 \
-regress_stim_times ${stimtimes} \
-regress_stim_labels ${stimlabels} \
-regress_stim_types ${stimtypes} \
-regress_basis_multi ${stimmodels} \
-regress_motion_per_run \
-regress_apply_mot_types demean deriv \
-regress_censor_motion 0.3 \
-regress_censor_outliers 0.15 \
-regress_censor_first_trs 4 \
-regress_apply_mask \
-regress_run_clustsim no \
-test_stim_files no \
-remove_preproc_files


#####end of here file
End-of-message-fool

chmod a+rwx ${logfile}
${logfile}

endif
end

