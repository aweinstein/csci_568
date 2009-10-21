#!/usr/bin/env python
print 'Sampling train-a-convert.arff'
file_name = 'new_file.arff'

new_lines = []
start_data = False

f = file(file_name)
lines = f.readlines()
n = 0
for line in lines:
    if start_data is False and line.startswith('@data'):
        start_data = True
        new_lines.append(line)
    elif start_data is False:
        new_lines.append(line)
    if start_data:
        fields = line.split(',')
        if len(fields) > 8:
            if fields[8] == '2' or fields[8] == '20': #'Y':
                new_lines.append(line)
            elif n < 10000:
                n += 1
                new_lines.append(line)
            
f.close()
f = file('new_file_small.arff', 'w')
f.writelines(new_lines)
f.close()
print 'Done'
