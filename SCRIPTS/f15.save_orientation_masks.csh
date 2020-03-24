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

foreach coil (Medtronic)
setenv logdir $subdir/$subject/code

cd ${subdir}/${subject}

setenv hotspots `ls -d simnibs_${subject}*${coil}*_vector* | cut -d"v" -f1 | uniq`

foreach hotspot (${hotspots})

cd ${subdir}/${subject}

setenv simulations `ls ${hotspot}v*/*sphere.nii`


setenv swarmfile ${scrdir}/rm.${outfile}.swarm
setenv logfile ${logdir}/${outfile}.${subject}.${hotspot}
setenv infile ${logdir}/f05.matlab.csh.${subject}

if (-e ${infile}) then
if (-e ${logfile}) then 
	echo "this script has been run for subject $subject"
else

cd $scrdir


#####start of here file
cat > ${logfile} <<End-of-message-fool

cd ${subdir}/${subject}

3dbucket \
-prefix ${hotspot}orientation.buck.nii \
${simulations}

3dTstat \
-max \
-prefix ${hotspot}orientation.mask.nii \
${hotspot}orientation.buck.nii




#####end of here file
End-of-message-fool

chmod a+rwx ${logfile}
echo "tcsh -c ${logfile}" >> ${swarmfile}

endif
else
	echo "please run ${infile} for $subject"
endif
end
end
end



cd $scrdir
#####run swarm command
#swarm -t 2 -g 16 --module afni,python,freesurfer --time=2:00:00 -f ${swarmfile}

chmod a+rwx $swarmfile
$swarmfile

#####remove swarm file
rm ${swarmfile}


