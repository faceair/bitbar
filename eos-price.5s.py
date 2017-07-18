#! /usr/bin/python
# -*- coding:utf-8 -*-

import json
import urllib2


def readPrice():
    file = open('/tmp/eos_price.txt', 'r')
    return float(file.read())


def writePrice(price):
    file = open('/tmp/eos_price.txt', 'w')
    file.write(str(price))
    file.close()


def fetchPrice():
    req = urllib2.Request('https://api.sosobtc.com/v2/market/widget')
    req.add_header('User-Agent', 'SosobtcWidget/3.3.7.07120 CFNetwork/811.5.4 Darwin/16.6.0')
    req.add_header('Content-Type', 'application/x-www-form-urlencoded')
    res = urllib2.urlopen(req, json.dumps({
        "str": "eos:yunbi",
        "userid": "",
        "lan": "cn"
    }))
    body = json.loads(res.read())
    res.close()
    return float(body['data'][0]['price_cny'])


old_price = readPrice()
price = fetchPrice()
if price > old_price:
    print('↑%.2f | color=red' % price)
elif price == old_price:
    print("%.2f" % price)
elif price < old_price:
    print('↓%.2f | color=green' % price)

writePrice(price)
