# Read Cannondale orders data --------------------------------------------------
library(xlsx) 
customers <- read.xlsx("./data/bikeshops.xlsx", sheetIndex = 1)
products <- read.xlsx("./data/bikes.xlsx", sheetIndex = 1) 
orders <- read.xlsx("./data/orders.xlsx", sheetIndex = 1) 

# Combine orders, customers, and products data frames --------------------------
library(dplyr)
orders.extended <- merge(orders, customers, by.x = "customer.id", by.y="bikeshop.id")
orders.extended <- merge(orders.extended, products, by.x = "product.id", by.y = "bike.id")

orders.extended <- orders.extended %>%
  mutate(price.extended = price * quantity) %>%
  select(order.date, order.id, order.line, bikeshop.name, model,
         quantity, price, price.extended, category1, category2, frame) %>%
  arrange(order.id, order.line)

knitr::kable(head(orders.extended)) # Preview the data

# Group by model & model features, summarize by quantity purchased -------------
library(tidyr)  # Needed for spread function
customerTrends <- orders.extended %>%
        group_by(bikeshop.name, model, category1, category2, frame, price) %>%
        summarise(total.qty = sum(quantity)) %>%
        spread(bikeshop.name, total.qty)
customerTrends[is.na(customerTrends)] <- 0  # Remove NA's

# Convert price to binary high/low category ------------------------------------
library(Hmisc)  # Needed for cut2 function
customerTrends$price <- cut2(customerTrends$price, g=2)  

# Convert customer purchase quantity to percentage of total quantity -----------
customerTrends.mat <- as.matrix(customerTrends[,-(1:5)])  # Drop first five columns
customerTrends.mat <- prop.table(customerTrends.mat, margin = 2)  # column-wise pct
customerTrends <- bind_cols(customerTrends[,1:5], as.data.frame(customerTrends.mat))

# View data post manipulation --------------------------------------------------
knitr::kable(head(customerTrends))
