all: trip_data.csv

trip_data.csv: R/0-read_data.R
	Rscript R/0-read_data.R