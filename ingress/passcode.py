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

rss = 'http://decodeingress.me/category/code/'
cookie = 'csrftoken=8iDQlP5SkhmJDHX6GFpeA8eRU3uXC8pJ; ingress.intelmap.lat=31.231083570103383; ingress.intelmap.lng=121.50776081828826; ingress.intelmap.zoom=13; ACSID=AJKiYcFTh_qafF1Ym0F3_OOt4lalBOKkDUGFiGF-YWV-S4J9tbQBS0Lf2wJwHbowzrCnLDTDoGD9N2nbDBpRWp7gElo81XfxI_n6TxHpJd8mtUnrR8g8hgiZg3gDA0EsUVtYqc_Dh4Y0dsDZd59CpgQzlfJCo3SZANnX-NN_YMbzZgyyGnrsqF-R2ifgUrzTAo554nyQGjKle8qVhKiALaLKsRIy779ky0ZJYE_NsUYa4mOPCjM4uZ5IjwIkeQLUZvdPTC2ZwFvhwNP2o1X13nzVZluDbTrQNr3Lv6sGqKd1LVd2KMVBrwpVtUD23LGTshre_QHBSKHNbXUtKrES0a_ktDkcBjvjBJCfK-lkdbh6swV9qFy46skJQUIUIO10gLXrWJg1M0mWg1ARhOhu9qMcfXX3SmDCPqcUiZx8TqSGcyAL8hbp0D5VN17k-Vw2Vj7pRQoWed8h0dtu0T0CIrJwro-4iceNpky3YfRcRRG-jzp92GTPTkqC2alM2Gt4JDjdTyKbd87jjRfTkNt3fFbKRvIHd725a71UDewWQtSEZ8BNG6F0sjxVt8vKgbu7yJl2twKMheAjoMyUqprT6O1cjCRa4K7wqFfDcsYUjNto8RT7f1ndBreiYKRZdr28WKLsJysK9z-J; __utma=24037858.793383968.1357310265.1359219363.1359230845.31; __utmb=24037858.53.9.1359232891911; __utmc=24037858; __utmz=24037858.1357310265.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)'

csrf = re.findall('csrftoken=(\w+)', cookie)[0]

chkcodes = '/tmp/checked.passcode'

print datetime.datetime.now().strftime("passcode.py started at %A (%a) %d/%m/%Y %H:%M:%S")

try:
    checked = cPickle.load(open(chkcodes))
except:
    checked = []
 
rt = unicode(urllib2.urlopen(rss).read(), "utf-8")

for each in re.findall(r'>Passcode: (\w*)<', rt):
    if len(each) > 25 or len(each) < 10:
	continue
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
