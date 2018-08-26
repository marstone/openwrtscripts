#!/usr/bin/env python
# -*- encoding: utf-8 -*-
# vim: set et sw=4 ts=4 sts=4 ff=unix fenc=utf8:
# Author: Binux<1@binux.me>
#         http://binux.me
# Created on 2013-01-14 10:29:51

import re
import cPickle
import urllib2
import urllib
import datetime

#rss = 'http://decodeingress.me/feed/'

# https://gist.github.com/4528587, or 4627284
key = 'AIzaSyDk3nQfb4O7OfsD0QTItzMYb8JnBXjPARw'
gplus = 'https://www.googleapis.com/plus/v1/activities?query=passcode&maxResults=20&fields=items(annotation%2Cobject(attachments%2Fcontent%2Ccontent%2CoriginalContent)%2Ctitle)%2Ctitle&key='+ key


cookie = 'ACSID=AJKiYcGyrgBKD9wlJGa8ANgw9gCMhE4E0S5ymz_cMVTtgvp4CsAFUDRJ6agmsb5l5Ynlo3BjVoi4og30kazxaAUj_1MXtuejqMscN5IcD7frOgPyZZYmBN3PvazacQigTU9rfWZtXHwPsFtLhWxUY7n_WTAxhoo0lmtBp2v6daRzk3RFQH862ADZE8x-NomdCXbSA3N-VaZ6g4lMH6BSUqBTr0xdfStj76r148hyRUxrxgyoFHm6fCyekI_H23jkl_EMebBuJJk2GzHIz97eS57u16CImfZv9yHXpr4-TXo4ZnZu4m6k9C0QL7a-eKar785suxH2o4crburJo8yHuAzDS-MbTXL6bZJx_69h46bU_GVkm1QnaAP5p7nJ-fTVpTfZ0sYI9G-lbF0OnT8gDcSnl5DHkHqnTO23urkSClMZLoFz0zgb66LUfCzS2G4DmxehCYXiW6jsxM3GjdnvEFD-r5LDYbnOWn8wLoLj7U1rK1-2SshtKUD5TfVCylF2GPil5kWFhgPTd0qoAmJLpSw11pXadU7fUedVxpfcZyUfHWsZMhzV3nQ7-ZPpczj3nytLVq1NXQ8WBiPmMWanLZ7W8i6kntXEls78a-RKdgsUZsnTS4GRtJBgm8jWoVCWSiam8tgnkyY7; csrftoken=7Dl7iQqmcYR2ZjBpMn4PWDLzPW0FKHRm; ingress.intelmap.lat=25; ingress.intelmap.lng=0; ingress.intelmap.zoom=2; __utma=24037858.2099495833.1358146479.1358146479.1358146479.1; __utmb=24037858.11.9.1358146499173; __utmc=24037858; __utmz=24037858.1358146479.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)'
csrf = re.findall('csrftoken=(\w+)', cookie)[0]

chkcodes = '/tmp/checked.passcode'

print datetime.datetime.now().strftime("passcode-gplus.py started at %A (%a) %d/%m/%Y %H:%M:%S")

try:
	checked = cPickle.load(open(chkcodes))
except:
	checked = []
 
rt = unicode(urllib2.urlopen(gplus).read(), "utf-8")
rp = re.findall('\d[A-Za-z]{2}\d[A-Za-z]+\d[A-Za-z]\d[A-Za-z]', data)


for each in rp:
        if each in checked:
            continue
        url = 'http://www.ingress.com/rpc/dashboard.redeemReward'
        values = '{"passcode":"'+ each + '", "method":"dashboard.redeemReward"}'
        headers = {
	        'Cookie': cookie,
        	'X-Requested-With': 'XMLHttpRequest',
        	'X-CSRFToken': csrf,
        }
        #data = urllib.urlencode(values)
        data = values
        req = urllib2.Request(url, data, headers)
        response = urllib2.urlopen(req)
        rtext = response.read()
        checked.append(each)
       
        print each, rtext
try:
	cPickle.dump(checked, open(chkcodes, 'w'))
except:
	pass
