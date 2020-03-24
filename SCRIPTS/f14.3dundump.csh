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


cd ${subdir}/${subject}

ls -d simnibs_${subject}*_vector* | cut -d"v" -f1 | uniq
setenv hotspots `ls -d simnibs_${subject}*_vector* | cut -d"v" -f1 | uniq`

foreach hotspot (${hotspots})

cd ${subdir}/${subject}

ls -d ${hotspot}v*
setenv simulations `ls -d ${hotspot}v*`

foreach simulation(${simulations})
setenv logdir $subdir/$subject/code


cd ${subdir}/${subject}/${simulation}
 
set targetcoords=`ls *target_coords.1d | head -n1`
set vectorcoords=`ls *vector_coords.1d | head -n1`
set simvalue=`ls *rdlpfc_mask.1d | head -n1`

paste $targetcoords $simvalue | tr ',' '\t' > rm.targetcoords
paste $vectorcoords $simvalue | tr ',' '\t' > rm.vectorcoords

cat rm.targetcoords rm.vectorcoords > rm.sphere.1d
cat *coords.1d > rm.coords.line.1d


setenv swarmfile ${scrdir}/rm.${outfile}.swarm
setenv logfile ${logdir}/${outfile}.${subject}.${hotspot}.$simulation
setenv infile ${logdir}/f05.matlab.csh.${subject}

if (-e ${infile}) then
if (-e ${logfile}) then 
	echo "this script has been run for subject $subject"
else

cd $scrdir


#####start of here file
cat > ${logfile} <<End-of-message-fool

cd ${subdir}/${subject}/${simulation}


3dUndump \
-master ${subdir}/${subject}/${subject}_T1fs_conform.nii.gz \
-prefix ${simulation}.sphere.nii \
-datum float \
-srad 3 \
-orient RAI \
-xyz \
rm.sphere.1d

3dUndump \
-master ${subdir}/${subject}/${subject}_T1fs_conform.nii.gz \
-prefix ${simulation}.line.nii \
-datum float \
-srad 6 \
-orient RAI \
-xyz \
rm.coords.line.1d



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


