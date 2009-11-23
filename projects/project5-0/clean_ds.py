#!/usr/bin/env python


def clean_ds(lines):
    new_lines = []
    for line in lines:
        fields = line.split(',')
        fields = [f.strip('"') for f in fields]
        fields = ['?' if f.isspace() else f for f in fields]
        fields = fields[0:8]
        new_lines.append(','.join(fields))
    return new_lines


f = open('dataset.csv')
lines = f.readlines()
new_lines = clean_ds(lines)
f.close()

f = open('new_dataset.csv','w')
f.write('\n'.join(new_lines))
f.write('\n')
f.close()
print 'Done'
