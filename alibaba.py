#
# Alexander's spider code with CMK additions
# CMK's code is commented
#

#
# The request was to pass arguments "acupuncturist" & "counselor" to spider
#


from itertools import count
import scrapy

# use crrawler process to run spider from within a python script
from scrapy.crawler import CrawlerProcess
from selectorlib import Extractor
from scrapy.http import Request
import os
import re 

# needed to parse settings
import json

class Alibaba(scrapy.Spider):
    name = 'alibaba_crawler'
    allowed_domains = ['alibaba.com']
    start_urls = ['http://alibaba.com/']
    extractor = Extractor.from_yaml_file(os.path.join(os.path.dirname(__file__), "alibaba.yml"))
    max_pages = 5
    count = 0

    def start_requests(self):
        # reset output file
        with open('alibaba.json', 'w') as f:
            f.write('')
    
        # settings content
        settings = ''
        
        # load settings from local file
        with open('settings.json', 'r') as f:
            for line in f.read():
                settings += line
        
        # parse settings
        settings = json.loads(settings)
        yield scrapy.Request('https://www.alibaba.com//trade/search?fsb=y&IndexArea=product_en&CatId=&SearchText=%s&viewtype=G' % settings['category'], callback = self.parse)

    def parse(self, response):
        data = self.extractor.extract(response.text,base_url=response.url)
        for product in data['products']:
            product["supplier_id"] = "alibaba" + str(self.count)
            self.count += 1
            if product["price"] is not None:
                product["max_price"] = float(product["price"][3:])
                product["min_price"] = float(product["price"][3:])
            product.pop("price")
            if product["seller_rating"] is not None:
                product["seller_rating"] = float(product["seller_rating"])
            if product["review"] is not None:
                product["review"] = int(product["review"][1:len(product["review"])-1])
            if product["MOQs"] is not None:
                product['MOQs'] = float(product["MOQs"].split()[0])
            if product['seller_year'] is not None:
                product['seller_year'] = int(product["seller_year"].split()[0])
            yield product
            with open('alibaba.json', 'a') as f:
                f.write(json.dumps(product)+'\n')
        
       # Try paginating if there is data
        if data['products']:
            if '&page=' not in response.url and self.max_pages>=2:
                yield Request(response.request.url+"&page=2")
            else:
                url = response.request.url
                current_page_no = re.findall('page=(\d+)',url)[0]
                next_page_no = int(current_page_no)+1
                url = re.sub('(^.*?&page\=)(\d+)(.*$)',rf"\g<1>{next_page_no}\g<3>",url)
                if next_page_no <= self.max_pages:
                    yield Request(url,callback=self.parse)
        
        
# main driver
if __name__ == '__main__':
    # run scraper
    process = CrawlerProcess()
    process.crawl(Alibaba)
    process.start()       
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
