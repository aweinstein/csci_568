#!/usr/bin/env python


makers = ['fuji',
          'canon',
          'nikon',
          'sony',
          'panasonic',
          'epson',
          'hp',
          'kodak',
          'minolta',
          'sigma',
          'casio',
          'olympus',
          'pentax',
          'ricoh',
          'leica',
          'noritsu',
          'nokia',
          'mamiya',
          'samsung']
          
def post_ds(lines):
    # Reduced the number of makers from 62 to 36
    new_lines = []
    for line in lines:
        fields = line.split(',')
        for maker in makers:
            if fields[6].lower().count(maker):
                fields[6] = maker
        new_lines.append(','.join(fields))
    return new_lines


f = open('new_dataset.csv')
lines = f.readlines()
print lines[0:5]
lines = drop_empty_lines(lines)
lines = post_ds(lines)
f.close()

f = open('post_dataset.csv','w')
f.write(''.join(lines))
f.write('\n')
f.close()
print 'Done'
