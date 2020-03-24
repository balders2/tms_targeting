#!/bin/tcsh

setenv expdir `dirname $PWD`
setenv subdir ${expdir}/data
setenv scrdir ${expdir}/SCRIPTS
setenv stmdir ${expdir}/expfiles
setenv resdir ${expdir}/results
setenv SUBJECTS_DIR ${expdir}/anat
setenv outfile `basename $0`
setenv subs `ls ${subdir}`



echo "###########################"
echo "###"
echo "###"
echo "###create timing files"
echo "###"
echo "###"
echo "###########################"

foreach subject (${subs})

mkdir ${subdir}/${subject}/stimtimes


foreach run (run1 run2)


cd ${stmdir}/${subject}/week1/mri_visit/npu/$run/
rm *.1d

setenv timfname `ls *.timing.txt | head -n1`
if ($timfname == "") then 
else
chmod a+rwx $timfname
dos2unix $timfname
./$timfname
endif


end
end



echo "###########################"
echo "###"
echo "###"
echo "###create block timing files"
echo "###"
echo "###"
echo "###########################"

foreach subject (${subs})



foreach run (run1 run2)
foreach npu (n p u)

echo $subject $run $npu
cd ${stmdir}/${subject}/week1/mri_visit/npu/$run
setenv blockfname `ls *post_na.$npu.*block*`

setenv stimnum `ls *post_na.$npu.*block* | wc -l`
if ($stimnum == 0) then 
else
cat $blockfname | sort -n > $subject.$run.$npu.all.mrivisit_tms_npu.block.1d
endif


end
end
end











echo "###########################"
echo "###"
echo "###"
echo "###run NPU"
echo "###"
echo "###"
echo "###########################"



foreach subject (${subs})
foreach stmfile (mrivisit_tms_npu.button.1d n.all.mrivisit_tms_npu.block.1d n.cue.mrivisit_tms_npu.cue.1d n.cue.mrivisit_tms_npu.tms.1d n.nocue.mrivisit_tms_npu.tms.1d p.all.mrivisit_tms_npu.block.1d p.cue.mrivisit_tms_npu.cue.1d p.cue.mrivisit_tms_npu.shock.1d p.cue.mrivisit_tms_npu.tms.1d p.nocue.mrivisit_tms_npu.tms.1d u.all.mrivisit_tms_npu.block.1d u.cue.mrivisit_tms_npu.cue.1d u.cue.mrivisit_tms_npu.tms.1d u.nocue.mrivisit_tms_npu.shock.1d u.nocue.mrivisit_tms_npu.tms.1d)

setenv functag task-npu-tms
setenv outfile ${subject}.${functag}.${stmfile}
rm ${subdir}/${subject}/stimtimes/${outfile}



foreach run (run1 run2)


cd ${stmdir}/${subject}/week1/mri_visit/npu/$run

setenv stmfname `ls *.$stmfile | head -n1`

if ($stmfname == "") then 
else
cat $stmfname | tr "\n" "\t" >> ${subdir}/${subject}/stimtimes/$outfile
echo "" >> ${subdir}/${subject}/stimtimes/$outfile
endif



end
end
end































echo "###########################"
echo "###"
echo "###"
echo "###run sternberg"
echo "###"
echo "###"
echo "###########################"




foreach subject (${subs})
foreach stmfile (sternberg.button.1d sort.sternberg.letter.1d sort.sternberg.maintenance.1d sort.sternberg.response.1d maintain.sternberg.letter.1d maintain.sternberg.maintenance.1d maintain.sternberg.response.1d)

setenv functag task-cog
setenv outfile ${subject}.${functag}.${stmfile}
rm ${subdir}/${subject}/stimtimes/${outfile}


foreach run (run1)



cd ${stmdir}/${subject}/week1/mri_visit/sternberg/$run

setenv stmfname `ls *.$stmfile | head -n1`

if ($stmfname == "") then 
else
cat $stmfname | tr "\n" "\t" >> ${subdir}/${subject}/stimtimes/$outfile
endif


end
end
end

