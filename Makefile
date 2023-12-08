terraform-format:
	terraform fmt
	terraform validate

setup:
	mkdir output
	mkdir output/images
	mkdir output/logs
	mkdir output/statistics

run_big_2:
	ruby client.rb subscribe $N $N_big_2

clear:
	rm ./output/*/*
	true > output.log
