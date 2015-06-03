source("config.R")

library(logging)
library(RPostgreSQL)
library(zoo)




logReset()
addHandler(writeToConsole)
loginfo('Début')

loginfo('Connection à a base de données')
m <- dbDriver("PostgreSQL")

tryCatch(con <- dbConnect(m, host=vigilante.host, 
                          user=vigilante.login, 
                          password=vigilnate.password, 
                          dbname=vigilante.base,
                          port=5433),
         error = function(e) logerror("Pas de connection"), 
         finally = loginfo("Fin Connection"))


tryCatch(listeBanqueR <- dbSendQuery(con, "select distinct publication_code from snapshot"),
         error = function(e) logerror("Requete Non Executer"), 
         finally = loginfo("Fin Requete"))

tryCatch(listeBanque <- fetch(listeBanqueR, n = -1), 
         error = function(e) logerror("Chargement erreur"), 
         finally = loginfo("Chargement des données"))


Production <-function(code, con){
  
  Requete = paste0("select date_trunc('days', insert_date) as insert_day, publication_date, count(*) 
                  from snapshot
                  where publication_code = '",
                  code,"'
                  group by 1,2
                  order by 1,2", 
                  collapse = NULL)
  
  loginfo(Requete)
  
  tryCatch(PR <- dbSendQuery(con, Requete), 
           error = function(e) logerror(paste0("Erreur requete pour la banque :",code ,collapse = NULL)), 
           finally = loginfo(paste0("Fin de requete pour la banque :",code ,collapse = NULL))) 
  
  P <- fetch(PR, n = -1)
  
  
  return(P)
  loginfo("Fin Production")
}

data <- Production("ECHO", con)
hist(data$count)
plot(density(data$count))
boxplot(data$count)
z <- zoo(x = data$count, order.by = data$insert_day)
