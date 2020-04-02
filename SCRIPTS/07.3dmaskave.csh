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


cd ${subdir}/${subject}/${simulation}/subject_volumes

ls *${simulation}*nii | head -n1
set ds=`ls *${simulation}*nii | head -n1`
set dsbasename=`basename $ds .nii`
setenv statsfile ${subdir}/${subject}/${simulation}/${dsbasename}.rdlpfc_mask.1d
rm ${statsfile} >& /dev/null



3dmaskave \
-q \
-mask ${subdir}/${subject}/${subject}.rdlpfc.fmask.nii \
${dsbasename}.nii \
> ${statsfile}



end
end
end

