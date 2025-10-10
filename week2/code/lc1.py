birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different lists containing the latin names, common names and mean body masses for each species in birds, respectively. 

latin_names = [ birds[i][0] for i in range(len(birds)) ]
common_names = [ birds[i][1] for i in range(len(birds)) ]
mean_body_masses = [ birds[i][2] for i in range(len(birds)) ]

# print results
print("Latin names:\n", latin_names)
print("Common names:\n", common_names)
print("Mean body masses:\n", mean_body_masses)

# (2) Now do the same using conventional loops (you can choose to do this before 1 !). 

# A nice example out out is:
# Step #1:
# Latin names:
# ['Passerculus sandwichensis', 'Delichon urbica', 'Junco phaeonotus', 'Junco hyemalis', 'Tachycineata bicolor']
# ... etc.

latin_names, common_names, mean_body_masses = [], [], [] # declare empty lists

for tuple in birds:
    # for each tuple, unpack the respective elements into the lists
    latin_names.append(tuple[0])
    common_names.append(tuple[1])
    mean_body_masses.append(tuple[2])

# print results
print("Latin names:\n", latin_names)
print("Common names:\n", common_names)
print("Mean body masses:\n", mean_body_masses)