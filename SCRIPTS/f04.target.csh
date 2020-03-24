#!/bin/tcsh

setenv expdir `dirname $PWD`
setenv subdir ${expdir}/data
setenv scrdir ${expdir}/SCRIPTS
setenv logdir ${expdir}/logs
setenv resdir ${expdir}/results
setenv stmdir ${expdir}/stimtimes
setenv SUBJECTS_DIR ${expdir}/anat
setenv outfile `basename $0`
setenv subs `ls ${subdir}`
setenv functag task-cog


foreach subject (${subs})

setenv logfile $subdir/$subject/code/${outfile}.${subject}

if (-e ${logfile}) then 
	echo "this script has been run for subject $subject"
else

#####start of here file
cat > ${logfile} <<End-of-message-fool
cd ${subdir}/${subject}


echo "############################################create condition masks"
3dcalc \
-a ${subject}.${functag}_proc/stats.${subject}+orig"[${functag}-sort-maintenance#0_Tstat]" \
-b ${subject}.${functag}_proc/stats.${subject}+orig"[${functag}-maintain-maintenance#0_Tstat]" \
-c ${subject}.rdlpfc.fmask.nii \
-expr "(a-b)*ispositive(c-.5)" \
-prefix ${subject}.srt-mnt.rdlpfc.nii




echo "############################################peak condition masks"
3dclust \
-quiet \
-orient RAI \
-1clip .01 3.5 2 \
${subject}.srt-mnt.rdlpfc.nii \
| head -n1 \
| tr -s ' ' \
| cut -d" " -f15-17 \
| tee ${subject}.srt-mnt.rdlpfc.1d

echo "############################################create sphere"
3dUndump \
-master ${subject}_T1fs_conform.nii.gz \
-prefix ${subject}.srt-mnt.rdlpfc.sphere.nii \
-srad 5 \
-xyz \
-orient RAI \
${subject}.srt-mnt.rdlpfc.1d



#####end of here file
End-of-message-fool

chmod a+rwx ${logfile}
${logfile}

endif
end
