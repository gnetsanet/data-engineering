vcfs = [["SampleA","HLA-A11:01,HLA-A26:01,HLA-B08:01,HLA-B35:01,HLA-C04:01,HLA-C07:02"],
["SampleB","HLA-A02:01,HLA-A23:01,HLA-B35:03,HLA-B44:03,HLA-C04:01"],
["SampleC","HLA-A02:01,HLA-A03:01,HLA-B27:05,HLA-B49:01,HLA-C02:02,HLA-C07:01"],
["SampleD","HLA-A02:01,HLA-B07:02,HLA-C07:02"]]

//Channel
//	.from(vcfs)
//	.map { line -> line.tokenize(".")[0] }
//	.subscribe { println "$it"}

process runMuPeXI {
	
	memory 32.GB 

	beforeScript "mkdir -p /efs/${sampleName}"

	input:
	set val(sampleName), val(hlas) from Channel.from(vcfs).map { line -> [line[0].tokenize(".")[0],line[1]] } 

	script:
	"""
	cd /efs/${sampleName}

	/usr/local/bin/aws s3 cp s3://bioinformatics-analysis/fsPeptideArrays/${sampleName}.vcf  ./	
	/MuPeXI/MuPeXI.py -v ./${sampleName}.vcf  -g -n -l '8,9,10,11,12'  -f -a ${hlas} -t
	/usr/local/bin/aws s3 cp /efs/${sampleName} s3://bioinformatics-analysis/fsPeptideArrays/${sampleName} --recursive
	"""
}
