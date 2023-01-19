### R Script used to analyze and plot the data associated with the article entitled 
### "Soybean dependence on biotic pollination decreases with latitude"
### submitted for consideration for publication by 
### Nicolay Leme da Cunha, Natacha P. Chacoff, Agustín Sáez, 
### Reto Schmucki, Leonardo Galetto, Mariano Devoto, 
### Julieta Carrasco, Mariana P. Mazzei, Silvio Egunio Castillo, 
### Tania Paula Palacios, José Luis Vesprini, Kayna Agostini, 
### Antônio Saraiva, Ben Woodcock, 
### Jeff Ollerton and Marcelo Adrián Aizen 
### that we are submitting for consideration for publication in Proceedings of the Royal Society B. 



# Used packages
{
  library(readxl)
  library(lme4)
  library(car)
  library(ggplot2)
  library(emmeans)
}



# Figure 1
{
  for_map  =  as.data.frame(read_excel("[data] Cunha et al. MS_soybean.xlsx",  sheet  =  "data_map"))
  for_map
  mp <- NULL
  mapWorld <- borders("world", colour="black", fill="white", xlim = c(-140, 45), ylim = c(-35, 41)) 
  mp <- ggplot() +  xlab("Longitude (degrees)") + ylab("Latitude (degrees)") +  mapWorld 
  mp <- mp+ geom_point(aes(x = for_map$Long, y = for_map$Lat), shape = 21, stroke = 1, 
                       size = 2.5, bg = "lightblue", 
                       position = position_jitter(width = 1.5, height = 1)) +
    theme (panel.background = element_rect(fill = 'lightblue3'))+
    theme_classic() +
    geom_hline(yintercept = c(0), col = "lightgrey", linetype= "dashed") +
    scale_y_continuous(n.breaks = 8)
}
mp




#### Pollinator Dependence ~ Latitude


{
  datos  <-  as.data.frame(read_excel("[data] Cunha et al. MS_soybean.xlsx",  sheet  =  "data"))
  datos$Treatment <- factor(datos$Treatment)
  datos$Variable2 <- factor(datos$Variable, levels = c("Pods", "Seeds", "Yield"), labels= c("Pods", "Seeds", "Yield"))
  datos$Lat <- abs(datos$Lat)
  datos$lat_factor <- factor(datos$Lat)
  datos$site <- factor(datos$site)
  datos$Treatment2 <- factor(datos$Treatment, levels = c("Open", "Open + honey bees", "Enclosure + bees"), 
                             labels = c("Open", "Open + honey bees", "Enclosure + bees"))
}



#### testing different random effect structures ###



m1 <- lmer(Value ~ poly(Lat, 2, raw=TRUE) + Variable2   + Treatment2 + (1|Reference_Data_owner/`Soybean variety`),
                   data = datos)

{
  
  m2 <- lm(Value ~ 1 ,
                           data = datos)
  
  m3 <- lmer(Value ~ 1 + (1|Reference_Data_owner),
                          data = datos, REML = TRUE)
  
  m4 <- lmer(Value ~ 1 + (1|Reference_Data_owner/`Soybean variety`/site),
                          data = datos, REML = TRUE)
  
  m5 <- lmer(Value ~ 1 + (1|Reference_Data_owner/`Soybean variety`),
                           data = datos, REML = TRUE)
  
  m6 <- lmer(Value ~ 1 + (1|Reference_Data_owner/site),
                           data = datos, REML = TRUE)


  AIC(m1, m2, m3, m4, m5, m6)
  lmtest::lrtest(m1, m2)
  lmtest::lrtest(m2, m3)
  lmtest::lrtest(m3, m4)
  lmtest::lrtest(m4, m5)
  lmtest::lrtest(m5, m6)
  
    
}




{
  # 
  # Running mixed models
  # Quadratic model
  # options(contrasts=c("contr.sum","contr.poly")) 
  
    mod1_2 <- lmer(Value ~ poly(Lat, 2, raw=TRUE) + Variable2   + Treatment2 +  (1|Reference_Data_owner/site),
                 data = datos)
  
  Anova(mod1_2)
  summary(mod1_2)
  x=fixef(mod1_2)
  y=confint(mod1_2)
  
  m=100*(1-10^-x[1]) #average pollinator dependence
  l=100*(1-10^-y[3]) #lower boundary of the 95% interval
  h=100*(1-10^-y[14]) #higher boundary of the 95% interval
  
  meansxx <- lsmeans(mod1_2, pairwise ~ Treatment)
  contrast(meansxx, alpha=0.05, method="pairwise", adjust="Tukey")
  meansxx=as.data.frame(summary(meansxx))
  
  (o=100*(1-10^-meansxx[1,2])) 
  (op=100*(1-10^-meansxx[2,2]))
  (cp=100*(1-10^-meansxx[3,2]))
  
  
  meansxx<-lsmeans(mod1_2, ~ Variable)
  contrast(meansxx, alpha=0.05, method="pairwise", adjust="Tukey")
  (meansxx=as.data.frame(summary(meansxx)))
  (s=100*(1-10^-meansxx[1,2])) 
  (p=100*(1-10^-meansxx[2,2]))
  (y=100*(1-10^-meansxx[3,2]))
  
  (plM=100*(10^(meansxx[2,2]-meansxx[1,2])-1)) #as an increase
  (plm=100*(1-10^-(meansxx[2,2]-meansxx[1,2]))) #as an decrease
  
  #finding the max of the function
  xx=seq(10,20, 0.1)
  yy=x[1]+x[2]*xx+x[3]*xx^2
  xy=data.frame(xx,yy)
  
  mal=xy[which.max(xy$yy),]
  
  r = range(datos$Lat)
  
  100*(1-10^-max(xy$yy))
  100*(10^max(xy$yy)-1)
  
  100*(1-10^-x[1]+x[2]*r+x[3]*r^2)
  100*(10^x[1]+x[2]*r+x[3]*r^2-1)
  
  
  # Quadratic model with interactions
  mod1_2_int <- lmer(Value ~ poly(Lat, 2, raw=TRUE) * Variable   + poly(Lat, 2, raw=TRUE)*Treatment   + (1|Reference_Data_owner/site),
                     data = datos)
  Anova(mod1_2_int)

}



#############################################################################################


# Figure 1 A
{
df_MOD1_2_Treat <- as.data.frame(emmeans::lsmeans(mod1_2, pairwise ~ Treatment2))[1:3, ]

df_MOD1_2_Treat$Treatment2 <- factor(df_MOD1_2_Treat$Treatment2, 
                                   levels = c("Open", "Open + honey bees", "Enclosure + bees"))

colnames(df_MOD1_2_Treat) <- c("x", "contrast" , "predicted", "std.error", "df", "lower.CL", "upper.CL")

df_MOD1_2_Treat$predicted_POS <- 100*(1-10^-(df_MOD1_2_Treat$predicted+df_MOD1_2_Treat$std.error))
df_MOD1_2_Treat$predicted_NEG <- 100*(1-10^-(df_MOD1_2_Treat$predicted-df_MOD1_2_Treat$std.error))
df_MOD1_2_Treat$predicted2 <- 100*(1-10^-df_MOD1_2_Treat$predicted)


                

Figure1A <- ggplot(data = df_MOD1_2_Treat, 
                          aes(x = x, y = predicted2)) +
  geom_errorbar(aes(ymin =  predicted_NEG, 
                    ymax =  predicted_POS), 
                width = 0.1, colour = "black", alpha = 0.9) +
  geom_point(size = 3, shape = 21, color = "black", fill = "darkgrey") + 
  
  labs(x = "Treatment", y = "Pollinator dependence (%)", subtitle = "", title = "") +
  annotate("segment", x=-Inf, xend=Inf, y=-Inf, yend=-Inf, colour = "black", size = 1)+
  annotate("segment", x=-Inf, xend=-Inf, y=-Inf, yend=Inf, colour = "black", size = 1)+
   theme_classic()
}



# Figure 1 B
{
df_mod1_2_Var <- as.data.frame(emmeans::lsmeans(mod1_2, pairwise ~ Variable2))[1:3, ]
  
  df_mod1_2_Var$predicted_POS <- 100*(1-10^-(df_MOD6_Var$lsmean+df_MOD6_Var$SE))
  df_mod1_2_Var$predicted_NEG <- 100*(1-10^-(df_MOD6_Var$lsmean-df_MOD6_Var$SE))
  df_mod1_2_Var$predicted2 <- 100*(1-10^-df_MOD6_Var$lsmean)  
  


}


Figure2B <- ggplot(data = df_mod1_2_Var, 
                        aes(x = Variable2, y = predicted2)) +
  geom_errorbar(aes(ymin =  predicted_NEG, 
                    ymax =  predicted_POS,
                    width = 0.1)) +
  geom_point(size = 3, shape = 21, color = "black", fill = "darkgrey") + 
  labs(x = "Yield category", y = "", subtitle = "", title = "") +
  ylim(17, 43) +
  annotate("segment", x=-Inf, xend=Inf, y=-Inf, yend=-Inf, colour = "black", size = 1)+
  annotate("segment", x=-Inf, xend=-Inf, y=-Inf, yend=Inf, colour = "black", size = 1)+
  theme_classic()

Figure2B


# Figure 2
  

library(ggeffects)

df_mod1_2 <- ggpredict(mod1_2, terms = c("Lat[4:44]", "Variable2", "Treatment2"), 
                     back.transform = FALSE)

{
  df_mod1_2$predicted <- 100*(1-10^-(df_mod1_2$predicted))
  df_mod1_2$conf.low <- 100*(1-10^-(df_mod1_2$conf.low))
  df_mod1_2$conf.high <- 100*(1-10^-(df_mod1_2$conf.high))
  df_mod1_2$std.error <- 100*(1-10^-(df_mod1_2$std.error))
}


Figure4 <- 
  plot(df_mod1_2, 
       add.data = TRUE, 
       ci = TRUE, 
       limit.range = TRUE, 
       ci.style = "dot",
       dot.alpha = 0.5,
       dot.size = 3, 
       line.size = 1, 
       grid = FALSE,
       one.plot = TRUE) +
  labs(x = "Latitude (degrees)", y = "Pollinator dependence (%)", subtitle = "", title = "") +
  xlim(0, 50) +
  scale_y_continuous(breaks = c(-60, -30, 0, 30, 60), limits = c(-70, 70))+
  geom_hline(yintercept = 0, linetype = "dashed", color = "lightgrey")+
  annotate("segment", x=-Inf, xend=Inf, y=-Inf, yend=-Inf, colour = "black", size = 1)+
  annotate("segment", x=-Inf, xend=-Inf, y=-Inf, yend=Inf, colour = "black", size = 1)+
  theme_classic()
 

{
  Figure4_ <- ggplot_build(Figure4)
  Figure4_$data[[1]]$y <- 100*(1-10^-qq$data[[1]]$y)
  }


library(grid)
Figure4 <- grid.draw(ggplot_gtable(qq)) 




