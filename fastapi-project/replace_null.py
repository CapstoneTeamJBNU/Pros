import json

with open('test_data.py', 'r') as f:
    data = f.read()

data = data.replace('null', 'None')

with open('test_data.py', 'w') as f:
    f.write(data)
