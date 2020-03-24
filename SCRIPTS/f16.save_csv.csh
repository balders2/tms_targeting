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
echo $subject/
cd ${subdir}/${subject}

setenv sims `ls -d simnibs*vector*`

foreach simulation ($sims)

cd ${subdir}/${subject}/$simulation
set rdlpfc=`ls *rdlpfc_mask.1d | head -n1`
set target=`ls *target_coords.1d | head -n1`
set vector=`ls *vector_coords.1d | head -n1`


echo $subject > rm.sub
echo $simulation > rm.simulation



paste \
-d',' \
rm.sub \
rm.simulation \
${target} \
${vector} \
${rdlpfc} \
| tee ${subject}.${simulation}.meta_data.1d


rm rm.*

end
end


