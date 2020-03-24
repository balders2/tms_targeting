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

if (-e ${logfile}) then 
	echo "this script has been run for subject $subject"
else

cd ${subdir}/${subject}

#####start of here file
cat > ${logfile} <<End-of-message-fool


dcm2niix_afni \
-b y \
-f %d \
-i y \
-o ${subdir}/${subject} \
${subdir}/${subject}/dicom

#####end of here file
End-of-message-fool

chmod a+rwx ${logfile}
${logfile}

endif
end

