all: rides_by_temp.png

trip_data.csv: R/0-read_data.R
	Rscript R/0-read_data.R

twbh_2017.csv: R/1-read_data.R weather.csv trip_data.csv
	Rscript R/1-read-data.R

rides_by_temp.png: R/2-plot_weather.R twbh_2017.csv
	Rscript R/2-plot_weather.R
