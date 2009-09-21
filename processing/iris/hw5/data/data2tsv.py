
f = open('iris.data')
f_new = open('iris.tsv', 'w')
lines = ['class\tsepal length\tsepal width\tpetal length\tpetal_width\n']
for line in f:
    fields = line.split(',')
    lines.append('\t'.join([fields[-1].strip()] + fields[:-1]) + '\n')
print lines
f_new.writelines(lines)
f.close()
f_new.close()