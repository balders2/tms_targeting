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

mkdir ${subject}_orientation_data

cp simnibs*mask.nii ${subject}_orientation_data
cp simnibs*meta_data.csv ${subject}_orientation_data
cp *sphere* ${subject}_orientation_data
cp ${subject}_T1fs_conform.nii* ${subject}_orientation_data
dicom_hdr `ls dicom/*dcm | head -n1` | grep Patient | grep Name | cut -d":" -f2 | tr -s " " "_" | tr '^' "_" > ${subject}_orientation_data/subname.txt




foreach coil (Medtronic)

setenv hotspots `ls -d simnibs_${subject}*${coil}*_vector* | cut -d"v" -f1 | uniq`
foreach hotspot (${hotspots})


setenv peakval `cat ${hotspot}meta_data.csv | cut -d, -f9 | sort -nr | head -n1`
setenv peaksim `more ${hotspot}meta_data.csv | grep ${peakval} | cut -d, -f2 | head -n1`

cp ${peaksim}/${peaksim}.line.nii* ${subject}_orientation_data




end
end
end

