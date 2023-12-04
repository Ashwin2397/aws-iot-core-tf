terraform-format:
	terraform fmt
	terraform validate

setup:
	mkdir output
	mkdir output/images
	mkdir output/logs
	mkdir output/statistics

clear:
	rm ./output/*/*
	true > output.log
