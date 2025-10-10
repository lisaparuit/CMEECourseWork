taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a python script to populate a dictionary called taxa_dic derived from
# taxa so that it maps order names to sets of taxa and prints it to screen.
# 
# An example output is:
#  
# 'Chiroptera' : set(['Myotis lucifugus']) ... etc. 
# OR, 
# 'Chiroptera': {'Myotis  lucifugus'} ... etc

#### Your solution here #### 
taxa_dict = {}

for species, order in taxa:
    if order not in taxa_dict.keys():
        taxa_dict[order] = {species} # creates a new key with a set as value
    else:
        taxa_dict[order].add(species) # adds species to the set at that key

print('My first dictionary: ', taxa_dict)

# Now write a list comprehension that does the same (including the printing after the dictionary has been created)  

#### Your solution here ####

orders = set([order for spec, order in taxa])
taxa_dict2 = { order : {species for species, ord in taxa if ord == order} for order in orders }

print('My second dictionary: ', taxa_dict2)