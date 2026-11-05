
library(dplyr)
library(labelled)
library(gtsummary)
library(gt)

here::i_am("Code/make_table.R")

absolute_path_to_data <- here::here("Data/Bacterial_Coinfection_Dataset.csv")
data <- read.csv(absolute_path_to_data, header = TRUE)

table1 <- data |>
  mutate(
    PathogenType = case_when(
      PathogenType == 1 ~ "Influenza",
      PathogenType == 2 ~ "COVID-19",
      PathogenType == 3 ~ "RSV"
    ),
    Bacterial_Pathogen = case_when(
      Bacterial_Pathogen == 0 ~ "No bacterial pathogen",
      Bacterial_Pathogen == 1 ~ "S. pneumoniae",
      Bacterial_Pathogen == 2 ~ "H. influenzae",
      Bacterial_Pathogen == 3 ~ "S. aureus",
      Bacterial_Pathogen == 4 ~ "K. pneumoniae"
    )
  )

var_label(table1) <- list(
  PathogenType = "Viral Pathogen",
  Bacterial_Pathogen = "Bacterial Pathogen"
)

table1 <- table1 |>
  filter(Bacterial_Coinfection == 1) |>
  select(PathogenType, Bacterial_Pathogen) |>
  tbl_summary(by = PathogenType) |>
  modify_spanning_header(
    c("stat_1", "stat_2", "stat_3") ~ "**Viral Pathogen**"
  ) |>
  add_overall() |>
  add_p()

# Save table as HTML
table1 |>
  as_gt() |>
  gt::gtsave(
    filename = here::here("Output", "table.html")
  )

# Save original table object
saveRDS(
  table1,
  file = here::here("Output", "table.rds")
)
