# ETL_practice
ETL
PROJECT 2 - ETL

1. EXTRACT
Which Data?
I decided that there were too many options with the podcasting datasets, and was unclear what data I could merge it with. 
The mass shootings happened so I decide to follow the CDC link to gun death data
to look at the number of deaths in the USA by firearm. 

NCHS dataset from CDC - https://dev.socrata.com/foundry/data.cdc.gov/nt65-c7a7

Downloading Options
I learned that the CDC file is so large that are two options for getting it:
1) Using SoQL paging parameters to iterate through the dataset, or 
2) Download as a CSV file. 
I decided to download the CSV file (I don't know how to use SoQL iterative).

Description of Dataset
The dataset comprised almost one million rows. I expected each row to be an observation
But each row in the dataset was grouped by year, then by sex, then by age category, then by race. 
Additonal rows were cumulative data -  all ages, all races, and both sexes and still grouped by year. 

The dataset has 17 columns. Many of them I didn't need because I am focused only on who dies from firearms.
I decided to keep Sex, Age (grouped), Race, Injury Intent (legal, suicide, homicide, unintentional)
Deaths (number), Population (national population group as per row parameters).
I will filter by Injury Mechanism - Firearm. Other Injury Mechanism fields included drowning, 
falls, transport, cutting, fire, motor vehicle, posioning, suffocation. These other fields are not needed.

The Second Dataset
Speaking to Michael, we decided that the easist field to merge into a second dataset is "age". 
I searched on Kaggle, and found a dataset authored by Chris Awram on US Product Related Injuries.
Awram dataset - https://data.world/awram/us-product-related-injuries
I can look at how people of certain ages either die by firearm or get hurt by products. 
The dataset is for 2015 only. So now I will filter the CDC dataset for 2015 only.
The columns I will import are Age, Sex, Diagnosis (type of injury) and Product (what products caused the harm)

2. TRANSFORM
Pandas Steps. 
1. Downloaded both CSV files.
2. Read files  

For NCHS Data - The Firearms table
Once dataframe was loaded, I filtered by 
1. 2015 - deleting all other years
2. Firearm - deleting all other tpes of death
3. Male | Female

The result was an imperfect table. I had to go back and filter by "Race". I kept "All Races"
which resulted in the deletion of named individual races.

Then I deleted year / race / population columns as they were superfluous.

I transformed the original file from 98,260 rows down to 60. 

In the Load process, I discovered that some rows had been lost along the transformation, 
When I checked the number of rows in the final Firearms dataframe, there were only 30. 
All date for 5 x age group bins 15-74 were never brought into the new dataframe
I looked up query that would include all Age_groups but not "All Ages" and found
a new way to delete rows with a certain values
new_df = df_name[~df_name.column.str.contains('value')]. Yay! 

New data table - Population
Into a separate datafram I split off the population figures because it could be used both by the 
Awram dataset and NCHS datset to calculate injury rate per population grouping.
The population was grouped by Age_group and Sex.

The Awram database - Injury
Of the 13 columns, I only needed 4 columns. 
As stated above these were: The columns I will import are Age, Sex, Diagnosis (type of injury)
and Product (what products caused the harm)
The "age" column needed to be binned in same values for the CDC database.
To find the categories to bin the values, I ran a new query on the firearms dataframe. 
But I had to rename this column to Age_group from "Age_group" because (years) was read 
as a function in the query. 
After binning "Age_group", then I had to group the individual 334,839 observations to match the 
grouped values of the Firearms table.
There were two entries with NaN values. I dropped these. 
With Michael's help I grouped by Age_group and Sex and diagnois. The Product column was the 
counted values for each grouping. So now that it is grouped, I cannot look up what product type 
contributed to the injury. 
The new grouped dataframe has only 360 rows, shrunk over a 1,000 fold.

3. LOADING STAGE
I encountered a problem that PGADMIN where refused Pandas uppercase column names  where 
SQL tables columns names were defined as lowercase
I went back to Pandas and renamed to lowercase.
I had a problem with defining columns of numbers that were defined as integers in Postgres
but were actually strings with thousand commas in Pandas.
I had to use pd to write the object to numeric and delete the number commas between 1,000s. 
Convert pd.to_numeric.
I had to drop all tables twice to set numbers as INT, and to set keys as 3 columns.
Otherwise the Load engine worked well. 

BONUS-New Table - Injury Disagnosis Lookup Table
I easily imported a new Table that gives names to the Disgnosis Codes in Injuty tables. 
I create a new Table in Postgres.
I couldn't export the data from Pandas into Postgres. Still troublshooting! 

LESSONS LEARNED
I could have gone back and optimized when to drop/filter by certain values. 
New commands learned! 
There were of lot of errors writing from Pandas to Postgres requring me to go back to Pandas
to change data type/ column name
Plan out unique columns beforehand. I should have re-named "disagnosis" as "diagnosis_code" 
in Injury (integer) so that it wouldn't be confused with "diagnosis" (not an integer) 
in Diagnosis table when doing SQL queries. 
Make all column names lower case

- Peta

