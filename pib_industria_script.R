# Script para baixar e animar a série do PIB - Indústria (código 7328)
# Pacotes necessários: GetBCBData, tidyverse, gganimate e ragg

library(GetBCBData)
library(tidyverse)
library(gganimate)
library(gifski)
library(ragg)

# garante que o dispositivo PNG funcione em ambientes sem interface gráfica
options(bitmapType = "cairo")

# Código da série no SGS
my.id <- c(pib_industria = 7328)

# Baixar dados a partir de 1996
series_pib <- gbcbd_get_series(id = my.id,
                               first.date = '1996-01-01',
                               last.date = Sys.Date(),
                               format.data = 'long',
                               use.memoise = TRUE,
                               cache.path = tempdir(),
                               do.parallel = FALSE)

glimpse(series_pib)

# Gráfico animado
p <- ggplot(series_pib, aes(x = ref.date, y = value)) +
  geom_line(color = 'steelblue') +
  geom_point(color = 'steelblue') +
  labs(
    title = 'PIB Indústria - Taxa de variação real no ano',
    subtitle = paste(min(series_pib$ref.date), 'a', max(series_pib$ref.date)),
    x = '',
    y = '% ao ano'
  ) +
  theme_minimal()

anim <- p + transition_reveal(ref.date)

animate(
  anim,
  fps = 10,
  width = 800,
  height = 400,
  renderer = gifski_renderer("pib_industria.gif"),
  device = agg_png
)  # salva GIF
