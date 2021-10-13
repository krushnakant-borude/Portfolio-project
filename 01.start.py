
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
pd.get_option('display.max_columns',None)
# pd.set_option('display.max_rows', None) 


df=pd.read_excel("movies_data.xlsx")
# print(df)

#  lets see if there is any missing data

for col in df.columns:
    pct_mssing=np.mean(df[col].isnull())
    print('{} - {}'.format(col,pct_mssing))
# look at datatype of our columns

# df.budget.astype("int64")   # this will change float into int or if you want to change it in another you can 


# so in this data date of release is not matching with year so we gonna add another column which contain year and gonna delete the year column

df["released_year"]=df['released'].astype(str).str[:4]    # astype will make it a str so that you can extract the data you want 


print(df.sort_values(by=["gross"],ascending=False))   # this is for sort the data 

## to check there are any duplicate or not 

# df["company"].drop_duplicates().sort_values(ascending=False)  # this will drop the dupplicates 

## what things are more correlated 
# compnay high correlation 

#scatter plot 

plt.scatter(df.budget,df.gross,marker="+",)
plt.grid()


# now we have to look that they are correlated or not 

#  for that we gonna use regression plot 

sns.regplot(x="budget",y="gross",data=df,scatter_kws={"color":"red"},line_kws={"color":"blue"})    # this will plot a line a regression line 
plt.show()


# lets start looking at co-relation 

correaltion_matrix=df.corr(method="pearson")  # pearson, kendall, spearman different type of correlation 
sns.heatmap(correaltion_matrix, annot=True)
plt.show()   # this will give us a visualization of co relation

df_numerized=df

for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype=="object"):
        df_numerized[col_name]=df_numerized[col_name].astype("category")
        df_numerized[col_name]=df_numerized[col_name].cat.codes   # so it will give random numerization

print(df_numerized)
correaltion_matrix=df_numerized.corr(method="pearson")  # pearson, kendall, spearman different type of correlation 
sns.heatmap(correaltion_matrix, annot=True)
plt.show()

correaltion_mat=df_numerized.corr()
corr_pairs=correaltion_mat.unstack()
print(corr_pairs)
sorted_pairs=corr_pairs.sort_values  # this will sort out the part 
high_corr=sorted_pairs[(sorted_pairs)>0.5]
