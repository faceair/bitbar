#! /usr/bin/python
# -*- coding:utf-8 -*-

import json
import urllib2

COIN_COUNT = 0


def readPrice():
    try:
        file = open('/tmp/eos_price.txt', 'r')
        return float(file.read())
    except Exception:
        return 0


def writePrice(price):
    file = open('/tmp/eos_price.txt', 'w+')
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
    return float(body['data'][0]['price_cny']), float(body['data'][0]['percent'])


old_price = readPrice()
price, percent = fetchPrice()
if price > old_price:
    print('↑%.2f | color=green' % price)
elif price == old_price:
    print("%.2f" % price)
elif price < old_price:
    print('↓%.2f | color=red' % price)

print('---')

if percent > 0:
    print('Change: +%.2f%% | color=green' % percent)
elif percent == 0:
    print('Change: %.2f%%' % percent)
elif percent < 0:
    print('Change: %.2f%% | color=red' % percent)
print("Summary: ￥%.2f | color=black" % (price * COIN_COUNT))


writePrice(price)
