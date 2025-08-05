library(letsRept)
library(ggplot2)
library(colorblindr)

# sampling date of description from internal database ---------------------
allReptiles$year <- as.integer(allReptiles$year)
summary(allReptiles$year) #min: 1758; max: 2025

table(allReptiles$suborder, allReptiles$order) #only Squamata suborders

sppYears <- as.data.frame(table(allReptiles$year, allReptiles$suborder))
colnames(sppYears) <- c("year", "suborder", "count")
sppYears$year <- as.integer(as.character(sppYears$year))  # ensure year is numeric

# Plot
fig1 <- ggplot(sppYears, aes(x = year, y = count, color = suborder)) +
        geom_point(alpha = 0.7, size = 0.5) +
        geom_smooth(method = "loess", se = FALSE, span = 0.3) +
        scale_x_continuous(
          breaks = c(seq(1755, 2025, by = 10)),
          limits = c(1755, 2030),
          expand = c(0, 0)
        ) +
        scale_color_manual(
        name = "Suborder",
        values = c("Sauria" = "#0072B2",          # blue
                   "Serpentes" = "#D55E00",       # vermillion
                   "Amphisbaenia" = "#009E73"),   # bluish green
        breaks = c("Sauria", "Serpentes", "Amphisbaenia"))+  
        labs(x = "Year",
             y = "Number of Described Species",
             color = "Suborder",
          ) +
        theme_minimal(base_size = 9) +
        theme(
          panel.grid.minor = element_blank(),
          axis.text.x = element_text(angle = 45, hjust = 1)
          )
fig1

colorblindr::cvd_grid(fig1) #test for color blind friendldy colors

ggsave("Fig 1.png",
       device = png,
       plot = fig1,
       path = here::here("outputs", "figures"),
       width = 168,
       height = 80,
       units = "mm",
       dpi = 300,
)
