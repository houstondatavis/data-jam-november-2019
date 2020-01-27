library(data.table)
library(ggplot2)

twbd_2017 <- fread('twbd_2017.csv')
twbh_2017 <- fread('twbh_2017.csv')

rides_by_temp_date <- ggplot(twbd_2017, aes(x=temp, y=rides, color = rain_bool)) +
  geom_point(alpha=0.75) +
  geom_smooth(method='lm', se=F, aes(color= rain_bool)) +
  scale_color_manual(values=c("#5E5C6C", "#5299D3")) +
  guides(color=guide_legend("")) +
  theme_minimal()

ggsave("rides_by_temp_date.png", rides_by_temp_date)

rides_by_temp_hour <- ggplot(twbh_2017, aes(x=temp, y=rides, color = rain_bool)) +
  geom_point(alpha=0.1) +
  geom_smooth(se=F, aes(color= rain_bool)) +
  scale_color_manual(values=c("#5E5C6C", "#5299D3")) +
  guides(color=guide_legend("")) +
  theme_minimal() +
  facet_grid(. ~ rain_bool)

ggsave("rides_by_temp_hour.png", rides_by_temp_hour)

break

#change to rides by temp for hours
rides_by_sd <- ggplot(twbd_2017, aes(x=temp_sd, y=rides, color = rain_bool)) +
    geom_point(alpha=0.25) +
    geom_smooth(method='lm', se=F, aes(color= rain_bool)) +
    scale_color_manual(values=c("#5E5C6C", "#5299D3")) +
    guides(color=guide_legend("")) +
    theme_minimal()

ggsave("rides_by_sd.png", rides_by_sd)
