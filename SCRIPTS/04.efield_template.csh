#!/bin/tcsh
setenv expdir `dirname $PWD`
setenv outfile `basename $0`
setenv subdir ${expdir}/data
setenv mridir ${expdir}/anat
setenv scrdir ${expdir}/SCRIPTS
setenv logdir ${expdir}/logs
setenv resdir ${expdir}/results
setenv stmdir ${expdir}/stimtimes
setenv emgdir ${expdir}/startle
setenv matdir ${expdir}/mfiles
setenv subs `ls ${subdir}`

foreach subject (${subs})

setenv logdir ${subdir}/${subject}/code
setenv swarmfile ${scrdir}/rm.${outfile}.swarm
setenv logfile ${logdir}/${outfile}.${subject}

if (-e ${logfile}) then 
	echo "this script has been run for subject $subject"
else

#####start of here file
cat > ${logfile} <<End-of-message-fool

module load matlab

cd ${matdir}

mri_info \
--scanner2tkr ${subdir}/${subject}/${subject}_T1fs_conform.nii.gz \
| tee ${subdir}/${subject}/${subject}.warp.1d

matlab \
-nosplash \
-nojvm \
-r "vect_target_wrapper('${expdir}','${subject}', 'srt-mnt.rdlpfc', 'Medtronic_MCF_B65.ccd')"


#####end of here file
End-of-message-fool

chmod a+rwx ${logfile}
${logfile}

endif
end


