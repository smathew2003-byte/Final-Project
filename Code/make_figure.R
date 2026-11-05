
here::i_am("Code/make_figure.R")

library(dplyr)
library(ggplot2)

absolute_path_to_data <- here::here("Data/Bacterial_Coinfection_Dataset.csv")
data <- read.csv(absolute_path_to_data, header = TRUE)

figure <- data |>
  mutate(
    PathogenType = case_when(
      PathogenType == 1 ~ "Influenza",
      PathogenType == 2 ~ "COVID-19",
      PathogenType == 3 ~ "RSV"
    ),
    Bacterial_Coinfection = factor(
      Bacterial_Coinfection,
      levels = c(1, 0),
      labels = c("Yes", "No")
    )
  ) |>
  count(PathogenType, Bacterial_Coinfection) |>
  group_by(PathogenType) |>
  mutate(
    Proportion = n / sum(n)
  ) |>
  ungroup()

figure <- ggplot(
  figure,
  aes(
    x = PathogenType,
    y = n,
    fill = Bacterial_Coinfection
  )
) +
  geom_col() +
  geom_text(
    aes(
      label = paste0(round(Proportion * 100, 1), "%")
    ),
    position = position_stack(vjust = 0.5),
    color = "black",
    size = 4
  ) +
  scale_fill_manual(
    values = c("Yes" = "lightblue", "No" = "azure3")
  ) +
  labs(
    title = "Bacterial Coinfection by Viral Pathogen",
    x = "Viral Pathogen",
    y = "Number of Patients",
    fill = "Bacterial Coinfection"
  ) +
  theme_classic() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 12, face = "bold"),
    axis.text = element_text(size = 11, color = "black"),
    legend.position = "bottom"
  )

# Save figure as PNG
ggsave(
  filename = here::here("Output", "figure.png"),
  plot = figure,
  width = 10,
  height = 7,
  dpi = 300
)

# Save original ggplot object
saveRDS(
  figure,
  file = here::here("Output", "figure.rds")
)
