import json
  
  


# JSON file
f = open ('synthetixtvl.json', "r")
  
# Reading from file
data = json.loads(f.read())
  
# Iterating through the json
# list
for i in data['tvl']:
    print(i)
  
# Closing file
f.close()