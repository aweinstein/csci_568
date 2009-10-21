#!/usr/bin/env python

print 'Filtering train-a-convert.arff'
file_name = 'train-a-convert.arff'

new_lines = []
start_data = False

f = file(file_name)
lines = f.readlines()
for line in lines:
    if line.count('Patient-Disposition') == 1:
        #new_lines.append('@attribute Patient-Disposition {Y,N}\n')
        new_lines.append('@attribute Patient-Disposition {0,2,20}\n')
    elif start_data is False and line.startswith('@data'):
        start_data = True
        new_lines.append(line)
    elif start_data is False:
        new_lines.append(line)
    if start_data:
        fields = line.split(',')
        if len(fields) > 8:
            if fields[8] == '20':# or fields[8] == '2':
                fields[8] = '20'
            elif fields[8] == '2':
                fields[8] = '2'
            else:
                fields[8] = '0'
            new_lines.append(','.join(fields))

f.close()
f = file('new_file.arff', 'w')
f.writelines(new_lines)
f.close()
print 'Done'
