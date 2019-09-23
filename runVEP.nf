sampleName = "C-600-28-189-002"


process runMuPeXI {
	
	memory 32.GB 

	container 'ngebremedhin/ensemble-vep-python:vep_plugin'

	beforeScript "mkdir -p /efs/${sampleName}"


	script:
	"""
	cd /efs/${sampleName}

	/usr/local/bin/aws s3 cp s3://bioinformatics-analysis/fsPeptideArrays/C-600-28-189-002/C-600-28-189-002.FS.sorted.hg38.vcf  ./	
	
	vep --input_file  C-600-28-189-002.FS.sorted.hg38.vcf  --output_file C-600-28-189-002.FS.sorted.hg38.vep.vcf --format vcf --vcf --symbol --terms SO --tsl --offline --plugin Downstream --plugin Wildtype --pick --transcript_version --cache --dir /vep_cache
	

	/usr/local/bin/aws s3 cp /efs/${sampleName}/C-600-28-189-002.FS.sorted.hg38.vep.vcf s3://bioinformatics-analysis/fsPeptideArrays/${sampleName}/
	"""
}
