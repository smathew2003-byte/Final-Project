
#MAKING DATASET: 1 dataset should include MRN, pathogentype(FLU, COVID, RSV), Sex, Bacterial Co-infection (Y/N), Bacterial Pathogen, Race/Ethnicity

#Variable names:
  #MRN: random identifying numbers (1 for each)
  #Pathogen type: 
      #1- FLU 
      #2- COVID-19 
      #3- RSV
  #Sex: 
    #1- Female 
    #2- Male
  #Bacterial Co-infection:
    #1- Yes 
    #2- No 
  #Bacterial Pathogen: 
    #1- S. pneumoniae 
    #2- H. influenzae 
    #3- S. aerues
  #Age
  #Race/Ethnicity: 
    #1- White 
    #2- Black 
    #3- Asian 
    #4- Latino/Hispanic 
    #5- Multiracial 
    #6- Other/Unknown
# Set seed for reproducibility
set.seed(123)

# Define sample size
n <- 1000


# --------------------------------
# 1. Generate Age (Bimodal)
# --------------------------------

# Assign patients to age groups
age_group <- sample(
  c(1, 2),
  n,
  replace = TRUE,
  prob = c(0.40, 0.60)
)

# Generate ages
Age <- ifelse(
  age_group == 1,
  rnorm(n, mean = 5, sd = 3),
  rnorm(n, mean = 70, sd = 12)
)

# Round ages to whole years
Age <- round(Age)

# Restrict age to 0-100
Age <- pmax(0, pmin(Age, 100))


# --------------------------------
# 2. Generate Viral Pathogen
# --------------------------------

PathogenType <- sample(
  c(1, 2, 3),
  n,
  replace = TRUE,
  prob = c(0.25, 0.50, 0.25)
)

# 1 = FLU
# 2 = COVID-19
# 3 = RSV


# --------------------------------
# 3. Generate Bacterial Co-infection
# --------------------------------

# Probability increases with age
# and varies by viral pathogen

prob_coinfection <- plogis(
  -3.5 +
    0.055 * Age +
    ifelse(PathogenType == 1, 0.9, 0) +
    ifelse(PathogenType == 2, -0.5, 0)
)

# Generate co-infection status
coinfection <- ifelse(
  runif(n) < prob_coinfection,
  1,
  0
)

# 1 = Yes
# 0 = No

# --------------------------------
# 4. Generate Bacterial Pathogen
# --------------------------------

# Initialize bacterial pathogen as 0 for everyone
bacterial_pathogen <- rep(0, n)

for (i in 1:n) {
  
  if (coinfection[i] == 1) {
    
    if (PathogenType[i] == 1) {
      
      # FLU: More likely S. pneumoniae
      bacterial_pathogen[i] <- sample(
        1:4, 1,
        prob = c(0.43, 0.22, 0.19, 0.16)
      )
      
    } else if (PathogenType[i] == 2) {
      
      # COVID-19: More likely K. pneumoniae
      bacterial_pathogen[i] <- sample(
        1:4, 1,
        prob = c(0.17, 0.23, 0.21, 0.39)
      )
      
    } else if (PathogenType[i] == 3) {
      
      # RSV: More likely H. influenzae
      bacterial_pathogen[i] <- sample(
        1:4, 1,
        prob = c(0.18, 0.46, 0.23, 0.13)
      )
    }
  }
}

# --------------------------------
# 5. Generate Remaining Variables
# --------------------------------

dataset <- data.frame(
  
  MRN = sample(1000000:9999999, n, replace = FALSE),
  
  Age = Age,
  
  PathogenType = PathogenType,
  
  Sex = sample(
    c(1, 2),
    n,
    replace = TRUE,
    prob = c(0.50, 0.50)
  ),
  
  Bacterial_Coinfection = coinfection,
  
  Bacterial_Pathogen = bacterial_pathogen,
  
  Race_Ethnicity = sample(
    c(1, 2, 3, 4, 5, 6),
    n,
    replace = TRUE,
    prob = c(0.50, 0.20, 0.10, 0.12, 0.05, 0.03)
  )
)


# --------------------------------
# 6. View Dataset
# --------------------------------

View(dataset)

head(dataset)

str(dataset)

setwd("C:/Users/sarah/OneDrive/Documents/Emory/Second Year/DATA 550/Final_Project/Data")
write.csv(dataset, "Bacterial_Coinfection_Dataset.csv", row.names = FALSE)
