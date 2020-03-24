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
foreach coil (Medtronic )
cd ${subdir}/${subject}

setenv hotspots `ls -d simnibs_${subject}*${coil}*_vector* | cut -d"v" -f1 | uniq`

foreach hotspot (${hotspots})

cd ${subdir}/${subject}




cat ${hotspot}vector*/*meta_data.1d \
| tee ${hotspot}meta_data.csv

end
end
end
