#
# Alexander's spider code with CMK additions
# CMK's code is commented
#

#
# The request was to pass arguments "acupuncturist" & "counselor" to spider
#


import scrapy

# use crrawler process to run spider from within a python script
from scrapy.crawler import CrawlerProcess
from selectorlib import Extractor
from scrapy.http import Request
import os
import re 

# needed to parse settings
import json

class ECPlaza(scrapy.Spider):
    name = 'ecplaza_crawler'
    allowed_domains = ['ecplaza.net']
    start_urls = ['http://ecplaza.net/']
    extractor = Extractor.from_yaml_file(os.path.join(os.path.dirname(__file__), "ecplaza.yml"))
    max_pages = 20 #number of products in each page is 10 fix
    count = 0

    def start_requests(self):
        # reset output file
        with open('ecplaza.json', 'w') as f:
            f.write('')
    
        # settings content
        settings = ''
        
        # load settings from local file
        with open('settings.json', 'r') as f:
            for line in f.read():
                settings += line
        
        # parse settings
        settings = json.loads(settings)
        yield scrapy.Request('https://www.ecplaza.net/%s--product?listType=list' % settings['category'], callback = self.parse)

    def parse(self, response):
        data = self.extractor.extract(response.text,base_url=response.url)
        for product in data['products']:
            product['supplier_id'] = "ecplaza" + str(self.count)
            self.count += 1
            if product["price"] is not None:
                price = product["price"].split()
                product["min_price"] = float(price[0][1:].replace(',',''))
                if len(price) > 1:
                    product["max_price"] = float(price[2][1:].replace(',',''))
                else:
                    product["max_price"] = float(price[0][1:].replace(',',''))
            product.pop("price")
            if product["MOQs"] is not None:
                product["MOQs"] = int(product["MOQs"].split()[0])
            if product["seller_year"] is not None:
                product["seller_year"] = int(product["seller_year"])
            product["image"] = "https://image1.ecplaza.com/global/header/ecplaza-logo.svg"
            yield product
            with open('ecplaza.json', 'a') as f:
                f.write(json.dumps(product)+'\n')
            yield product
        
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
    process.crawl(ECPlaza)
    process.start()       
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
