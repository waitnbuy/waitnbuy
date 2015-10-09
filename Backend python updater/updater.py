#! /usr/bin/python

import json,httplib,urllib,requests,re

connection = httplib.HTTPSConnection("api.parse.com", 443)
connection.connect()
connection.request("GET", "/1/classes/Data", {}, {
	"X-Parse-Application-Id": "8gjlvPcqeoOcMy6AHEEeAzwinCgFVfv7XWdzmUl6",
    "X-Parse-REST-API-Key": "BAZ1TZTEruRVhyeb86enQuMKijbYXvdYApGiDE5a",
    "X-Parse-Master-Key": "iKbL8EZxZZVbAXr7v2LbIMzsnK3QPrNdPwKxvCS3",
    "Content-Type": "application/json"
    })	

arr = json.loads(connection.getresponse().read())
for obj in arr["results"]:
    params = {'token': '6ec693665e677a8dd630f0f261114fdf', 'url' : obj['link']}
    url = 'api.diffbot.com/v3/product?' 
    response = requests.get('http://api.diffbot.com/v3/product', params=params)
    new_arr = response.json()
    new_price = new_arr["objects"][0]["offerPrice"]
    new_descr = new_arr["objects"][0]["title"]
    new_photo = new_arr["objects"][0]["images"][0]["url"]
    default = 0
    old_price = obj.get("price", default)
    nprice = int(re.search(r'\d+', new_price).group())
    objid = obj["objectId"]
    connection.connect()
    connection.request('PUT', '/1/classes/Data/' + objid, json.dumps({
       "prev_price": old_price,
       "description": new_descr,
       "deleted": obj.get("deleted", False),
       "photoURL": new_photo,
       "price": nprice
    }), {
       "X-Parse-Application-Id": "8gjlvPcqeoOcMy6AHEEeAzwinCgFVfv7XWdzmUl6",
       "X-Parse-REST-API-Key": "BAZ1TZTEruRVhyeb86enQuMKijbYXvdYApGiDE5a",
       "X-Parse-Master-Key": "iKbL8EZxZZVbAXr7v2LbIMzsnK3QPrNdPwKxvCS3",
       "Content-Type": "application/json"
    })
    result = json.loads(connection.getresponse().read())
    print result
    #print obj.get("owner", "nil")
    if nprice != old_price:

        connection.connect()
        connection.request('POST', '/1/push', json.dumps({
            "where": {
                "userID": obj.get("owner", "nil")
            },
            "data": {
                "alert": "Your item's \"" + obj.get("description", "nil") + "\" price has changed! Check it out!"
            }
        }), {
            "X-Parse-Application-Id": "8gjlvPcqeoOcMy6AHEEeAzwinCgFVfv7XWdzmUl6",
            "X-Parse-REST-API-Key": "BAZ1TZTEruRVhyeb86enQuMKijbYXvdYApGiDE5a",
            "X-Parse-Master-Key": "iKbL8EZxZZVbAXr7v2LbIMzsnK3QPrNdPwKxvCS3",
            "Content-Type": "application/json"
        })
        result = json.loads(connection.getresponse().read())
        print result
    
    
    #print str(old_price) + " -> " + str(int(s) for s in new_price.split() if s.isdigit())
print "finished updating"
