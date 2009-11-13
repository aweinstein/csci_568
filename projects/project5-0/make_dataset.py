#!/usr/bin/env python

import flickrapi

api_key = 'b23df2971d2330109028b7e5835c00f7'

tags = ['animals', 'architecture', 'art', 'asia', 'australia', 'autumn', 'baby', 'band', 'barcelona', 'beach', 'berlin', 'bike', 'bird', 'birds', 'birthday', 'black', 'blackandwhite', 'blue', 'bw', 'california', 'canada', 'canon', 'car', 'cat', 'chicago', 'china', 'christmas', 'church', 'city', 'clouds', 'color', 'concert', 'cute', 'dance', 'day', 'de', 'dog', 'england', 'europe', 'fall', 'family', 'fashion', 'festival', 'film', 'florida', 'flower', 'flowers', 'food', 'football', 'france', 'friends', 'fun', 'garden', 'geotagged', 'germany', 'girl', 'girls', 'graffiti', 'green', 'halloween', 'hawaii', 'hiking', 'holiday', 'home', 'house', 'india', 'ireland', 'island', 'italia', 'italy', 'japan', 'july', 'kids', 'la', 'lake', 'landscape', 'light', 'live', 'london', 'love', 'macro', 'me', 'mexico', 'mountain', 'mountains', 'museum', 'music', 'nature', 'new', 'newyork', 'newyorkcity', 'night', 'nikon', 'nyc', 'ocean', 'old', 'oregon', 'paris', 'park', 'party', 'people', 'photo', 'photography', 'photos', 'portrait', 'red', 'river', 'rock', 'san', 'sanfrancisco', 'scotland', 'sea', 'seattle', 'show', 'sky', 'snow', 'spain', 'spring', 'street', 'summer', 'sun', 'sunset', 'taiwan', 'texas', 'thailand', 'tokyo', 'toronto', 'tour', 'travel', 'tree', 'trees', 'trip', 'uk', 'urban', 'usa', 'vacation', 'washington', 'water', 'wedding', 'white', 'winter', 'yellow', 'york', 'zoo']



def make_photo_list(photos):
    photo_id = []
    for photo in photos.find('photos').findall('photo'):
        photo_id.append(photo.attrib['id'])
    return photo_id

def get_info(id):
    
    info = flickr.photos_getInfo(photo_id=id)
    favorites = flickr.photos_getFavorites(photo_id=id)
    try:
        exif = flickr.photos_getExif(photo_id=id)
    except flickrapi.exceptions.FlickrError:
        exif = None
        print 'No access to exif' 
        
    data = {'id':id,
            'views':'?',
            'location':'?',
            'comments':'?',
            'tags_n':'?',
            'favorites':'?',
            'make':'?',
            'model':'?'}
    
    photo = info.find('photo')
    data['views'] = photo.attrib['views']
    data['location'] = photo.find('owner').attrib['location'].replace(',',' ')
    data['comments'] = photo.find('comments').text
    data['tags_n'] = len(photo.find('tags').findall('tag'))
    data['favorites'] = favorites.find('photo').attrib['total']

    if exif is not None:
        exif_data = exif.find('photo').findall('exif')
        for e in exif_data:
            if e.attrib['label'] == 'Make':
                data['make'] = e.find('raw').text.replace(',',' ')
            if e.attrib['label'] == 'Model':
                data['model'] = e.find('raw').text

    return data


def make_record(data):
    keys = ['id','views','location','comments','tags_n','favorites','make','model']
    record = []
    for key in keys:
        try:
            record.append(str(data[key]).encode('ascii','ignore'))
        except UnicodeEncodeError:
            return None
    return ','.join(record)
    
flickr = flickrapi.FlickrAPI(api_key)
photos = flickr.photos_search(tags='cat', max_upload_date=1226383200)
photos = make_photo_list(photos)


#get_info('3021490602')
records = []
for photo in photos:
    r = make_record(get_info(photo))
    if r is not None:
        records.append(r)
    print records[-1]

f = file('dataset.csv', 'w')
f.write(','.join(['id','views','location','comments','tags_n','favorites','make','model'])
        + '\n')
f.write('\n'.join(records))
f.write('\n')
f.close()
##print 'Done'
