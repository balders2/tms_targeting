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
setenv logdir $subdir/$subject/code
cd ${subdir}/${subject}

setenv sims `ls -d simnibs*vector*`

foreach simulation ($sims)
echo $simulation

cd ${subdir}/${subject}/$simulation

set ds=`ls *mat | head -n1`

set dsbasename=`basename $ds .mat`


setenv swarmfile ${scrdir}/rm.${outfile}.swarm
setenv logfile ${logdir}/${outfile}.${subject}.$dsbasename
setenv infile ${logdir}/f05.matlab.csh.${subject}

if (-e ${infile}) then
if (-e ${logfile}) then 
	echo "this script has been run for subject $subject"
else

cd $scrdir
#####start of here file
cat > ${logfile} <<End-of-message-fool
#!/bin/bash


cd ${subdir}/${subject}/${simulation}


simnibs --cpus 1 ${ds}

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






