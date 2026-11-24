## Project Overview

This project generates an automated HTML report summarizing information regarding bacterial coinfections among patients with viral respiratory illness. 

## Repository Structure

| File/Directory | Description |
|---|---|
| `data/` | Contains the raw dataset |
| `code/make_table.R` | Generates the  table |
| `code/make_figure.R` | Generates the figure |
| `code/render_report.R` | Renders the final HTML report |
| `output/` | Stores generated tables and figures |
| `Makefile` | Defines the workflow for generating the report |
| `report.Rmd` | R Markdown source file for the report |
| `renv.lock` | Records R package dependencies |

## Building the Report

To build the report, open a terminal in the main project directory and run `make`.

- The completed report will be saved as `report.html` in the main project directory.
- To remove generated outputs, run `make clean` in the terminal.
- To restore the project's R package environment, run `make install` in the terminal. This will install the package versions specified in `renv.lock`.