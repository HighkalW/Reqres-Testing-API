import json

# Read the JSON data from the file
with open('users_data.json', 'r') as file:
    users_data = json.load(file)

# Now you can access the data as a dictionary
print(users_data['page'])  # Output: 1
print(users_data['data'][0]['first_name'])  # Output: George
