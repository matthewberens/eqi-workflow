###################
### PLOT STYLES ###
###################
library(PNWColors)
library(ggh4x)

# functions 
theme_mb1 <- function() {  # this for all the elements common across plots
  theme_bw() %+replace%
    theme(
      text = element_text(family = "PT Sans"),
      legend.position = "top",
      legend.key=element_blank(),
      #legend.title = element_blank(),
      legend.background = element_blank(),
      legend.text = element_text(size = 10),
      legend.title = element_text(size = 10),
      legend.key.size = unit(1.5, 'lines'),
      panel.border = element_rect(color="black",linewidth=1, fill = NA),
      panel.grid = element_blank(),
      
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      plot.subtitle = element_text(hjust = 0, size = 12, lineheight = 1.5, face = "bold"),
      axis.text = element_text(size = 10, color = "black"),
      axis.title = element_text(size = 12, color = "black"),
      
      # formatting for facets
      panel.background = element_blank(),
      strip.background = element_blank(), #facet formatting
      panel.spacing.x = unit(1.5, "lines"), #facet spacing for x axis
      panel.spacing.y = unit(1.5, "lines"), #facet spacing for x axis
      strip.text.x = element_text(size=10, face="bold"), #facet labels
      strip.text.y = element_text(size=10, face="bold", angle = 270),
      strip.placement = "outside"
    )
  
}

shapes = c(21, 25, 22, 24)
