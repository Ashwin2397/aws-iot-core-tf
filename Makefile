terraform-format:
	terraform fmt
	terraform validate

clear:
	rm ./output/*/*
	true > output.log
