#!/usr/bin/env python

import sys

from operator import itemgetter
from string import Template

import numpy as np
import pylab as pl


def read_array(filename, separator=','):
    """ Read a file with an arbitrary number of columns.
        The type of data in each column is arbitrary
        It will be cast to the given dtype at runtime

        From http://www.scipy.org/Cookbook/InputOutput
    """
    dtype = np.dtype([('id','S12'),
                      ('views','int32'),
                      ('location','S140'),
                      ('comments','int32'),
                      ('tags_n','int32'),
                      ('favorites','int32'),
                      ('make','S50'),
                      ('model','S100')])
    cast = np.cast
    data = [[] for dummy in xrange(len(dtype))]
    f = open(filename, 'r')
    lines = f.readlines()
    for line in lines[1:-100]:
        fields = line.strip().split(separator)
        for i, number in enumerate(fields):
            data[i].append(number)
    for i in xrange(len(dtype)):
        data[i] = cast[dtype[i]](data[i])
    return np.rec.array(data, dtype=dtype)

def get_stat_numerical(data):
    mean = '%0.1f' % np.mean(data)
    maxv = '%0.0f' % np.max(data)
    minv = '%0.0f' % np.min(data)
    sigma = '%0.1f' % np.std(data)
    return {'mean':mean, 'min':minv, 'max':maxv, 'sigma':sigma}

def get_latex_stat_table(data): 
    s = Template(
        r'\begin{tabular}{|l|l|}' '\n' \
        r'\hline' \
        r'\multicolumn{2}{|c|}{$attr} \\' '\n'\
        r'\hline' '\n'\
        r'Min & $min \\' '\n'\
        r'Max & $max \\' '\n'\
        r'Mean & $mean\\' '\n'\
        r'Std dev & $sigma \\' '\n'\
        r'\hline' '\n' \
        r'\end{tabular}' '\n'
        ).substitute(data)
    
    return s
    
def make_latex_stats(data):
    tables = []
    for attrib in data.dtype.names:
        if data.dtype[attrib].name == 'int32':
            stats = get_stat_numerical(data[attrib])
            stats['attr'] = attrib
            tables.append(get_latex_stat_table(stats))

    f = open('stats_tables.tex','w')
    f.write('\n'.join(tables))
    f.close()
    
def compute_freq(data):
    freq = {}
    for d in data:
        freq[d] = freq.setdefault(d,0) + 1
    return freq

def bar_plot(freq):
    # sort the dictionary:
    freq = sorted(freq.iteritems(), key=itemgetter(1), reverse=True)
    val = [f[1] for f in freq]
    pos = np.array(range(len(freq)))+0.5
    fig = pl.figure()
    pl.bar(pos,val, align='center')
    makes = [m[0].strip('"').capitalize().split()[0] + ' ' for  m in freq]
    xt = pl.xticks(pos, makes, rotation=90)
    fig.subplots_adjust(bottom=.25)
    pl.savefig('histo_make.pdf',bbox_inches='tight', pad_inches=0.1)
    pl.show()
        
def plot(data):
    pl.figure()
    pl.hist(data['views'],100, histtype='stepfilled')
    pl.xlim([0,200000])
    pl.xlabel('views')
    pl.savefig('histo_views.pdf')

    pl.figure()
    pl.hist(data['comments'],100, histtype='stepfilled')
    pl.xlim([0, 1500])
    pl.xlabel('comments')
    pl.savefig('histo_comments.pdf')

    pl.figure()
    pl.hist(data['favorites'],100, histtype='stepfilled')
    pl.xlim([0,2000])
    pl.xlabel('favorites')
    pl.savefig('histo_favorites.pdf')
    
    pl.figure()
    pl.hist(data['tags_n'],50, histtype='stepfilled')
    pl.xlim([0,280])
    pl.xlabel('tags')
    pl.savefig('histo_tags.pdf')
    
    pl.figure()
    color = np.log10(data['favorites'])
    pl.scatter(data['comments'],data['views'],c=color,alpha=0.9,cmap=pl.cm.jet)
    pl.colorbar()
    pl.xlabel('comments')
    pl.ylabel('views')
    pl.xlim([0, 3000])
    pl.ylim([0, 1200000])

    pl.savefig('scatter.pdf')
    try:
        pl.show()
    except KeyboardInterrupt:
        sys.exit(0)

if __name__ == '__main__':
    print 'Making some plots'
    file_name = 'post_dataset.csv'
    data = read_array(file_name)
    #make_latex_stats(data)
    #d = compute_stat_numerical(data['comments'])
    #d['attr'] = 'comments'
    #get_latex_stat_table(d)

    plot(data)
    #freq = compute_freq(data['make'])
    #bar_plot(freq)
    
