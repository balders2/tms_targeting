#!/bin/tcsh

setenv expdir `dirname $PWD`
setenv subdir ${expdir}/data
setenv scrdir ${expdir}/SCRIPTS
setenv logdir ${expdir}/logs
setenv stmdir ${expdir}/stimtimes
setenv resdir ${expdir}/results
setenv SUBJECTS_DIR ${expdir}/anat
setenv outfile `basename $0`
setenv subs `ls ${subdir}`


foreach subject (${subs})
setenv logdir $subdir/$subject/code
echo $subject
cd ${subdir}/${subject}

setenv sims `ls -d simnibs*vector*`

foreach simulation ($sims)

cd ${subdir}/${subject}/$simulation/subject_volumes

set ds=`ls *normE.nii.gz | head -n1`

set dsbasename=`basename $ds .nii.gz`


setenv swarmfile ${scrdir}/rm.${outfile}.swarm
setenv logfile ${logdir}/${outfile}.${subject}.$simulation
setenv infile ${logdir}/f05.matlab.csh.${subject}

if (-e ${infile}) then
if (-e ${logfile}) then 
	echo "this script has been run for subject $subject"
else

cd $scrdir
#####start of here file
cat > ${logfile} <<End-of-message-fool
cd ${subdir}/${subject}/$simulation/subject_volumes

3drefit \
-space ORIG \
${dsbasename}.nii.gz

3dresample \
-dxyz 2 2 2 \
-prefix ${dsbasename}.${simulation}.nii \
-input ${dsbasename}.nii.gz


#####end of here file
End-of-message-fool

chmod a+rwx ${logfile}
${logfile}

endif
else
	echo "please run ${infile} for $subject"
endif
end
end


