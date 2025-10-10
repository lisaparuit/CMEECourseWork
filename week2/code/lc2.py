# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where the amount of rain was greater than 100 mm.
 
list_heavy_rain = [rainfall[i] for i in range(len(rainfall)) # add the whole tuple
                               if rainfall[i][1] > 100] # only if the rainfall value > 100

print("Results for (1):", list_heavy_rain)
 
# (2) Use a list comprehension to create a list of just month names where the amount of rain was less than 50 mm.

list_light_rain = [rainfall[i][0] for i in range(len(rainfall))  # add the month name only (index 0)
                                  if rainfall[i][1] < 50] # only if the corresponding rainfall value < 50

print("Results for (2):", list_light_rain)

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

# A good example output is:
#
# Step #1:
# Months and rainfall values when the amount of rain was greater than 100mm:
# [('JAN', 111.4), ('FEB', 126.1), ('AUG', 140.2), ('NOV', 128.4), ('DEC', 142.2)]
# ... etc.

list_heavy_rain, list_light_rain = [], [] # declare empty lists

for tuple in rainfall:
    if tuple[1] > 100: # if the rainfall value > 100
        list_heavy_rain.append(tuple) # add the whole tuple to the list
    if tuple[1] < 50: # if the rainfall value < 50
        list_light_rain.append(tuple[0]) # add the month name only (index 0) to the list

print("Results for (1):", list_heavy_rain)
print("Results for (2):", list_light_rain)
