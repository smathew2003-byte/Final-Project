
.PHONY: install clean

report.html: Report.Rmd Code/render_report.R Output/table.rds Output/figure.rds
	Rscript Code/render_report.R

Output/table.rds: Code/make_table.R Data/Bacterial_Coinfection_Dataset.csv
	Rscript Code/make_table.R

Output/figure.rds: Code/make_figure.R Data/Bacterial_Coinfection_Dataset.csv
	Rscript Code/make_figure.R
	
install:
	Rscript -e "renv::restore(prompt=FALSE)"

clean:
	rm -f Output/*.rds
	rm -f Output/*.png
	rm -f Output/*.html
	rm -f Code/Bacterial-Coinfection-Report.html
	rm -f .R
