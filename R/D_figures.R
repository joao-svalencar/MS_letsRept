library(letsRept)
library(ggplot2)

# SquamBase nomenclature check --------------------------------------------
allReptiles$year <- as.integer(allReptiles$year)
summary(allReptiles$year)

table(allReptiles$suborder, allReptiles$order)

sppYears <- as.data.frame(table(allReptiles$year, allReptiles$suborder))
colnames(sppYears) <- c("year", "suborder", "count")
sppYears$year <- as.integer(as.character(sppYears$year))  # ensure year is numeric

# Plot with ggplot2
fig1 <- ggplot(sppYears, aes(x = year, y = count, color = suborder)) +
        geom_point(alpha = 0.8, size = 1) +
        geom_smooth(method = "loess", se = FALSE, span = 0.3) +
        scale_x_continuous(breaks = seq(1760, 2030, by = 10)) +
        labs(
          x = "Decade",
          y = "Number of Described Species",
          color = "Suborder",
          ) +
        theme_minimal(base_size = 9) +
        theme(
          panel.grid.minor = element_blank(),
          axis.text.x = element_text(angle = 45, hjust = 1)
          )
fig1

ggsave("Fig 1.png",
       device = png,
       plot = fig1,
       path = here::here("outputs", "figures"),
       width = 168,
       height = 80,
       units = "mm",
       dpi = 300,
)
