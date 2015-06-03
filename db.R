source("config.R")
library(RPostgreSQL)

m <- dbDriver("PostgreSQL")
con <- dbConnect(m, host=vigilante.host, 
                    user=vigilante.login, 
                    password=vigilnate.password, 
                    dbname=vigilante.base,
                    port=5433)


listeBanqueR <- dbSendQuery(con, "select distinct publication_code from snapshot")
listeBanque <- fetch(listeBanqueR, n = -1)

Production <-function(code, con){
  
  PR <- dbSendQuery(con, paste("select date_trunc('days', insert_date) as insert_day, publication_date, count(*) 
                          from snapshot
                          where publication_code = '",code,"'
                          group by 1,2")
                    )
  P <- fetch(listeBanqueR, n = -1)
  return(P)
}

Production("ECHO", con)
