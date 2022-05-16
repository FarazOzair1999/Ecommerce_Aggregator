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

class MadeinChina(scrapy.Spider):
    name = 'madeinchina_crawler'
    allowed_domains = ['made-in-china.com']
    start_urls = ['http://made-in-china.com/']
    extractor = Extractor.from_yaml_file(os.path.join(os.path.dirname(__file__), "madeinchina.yml"))
    max_pages = 10*5 #number of products in each page is 10 fix
    count = 0

    def start_requests(self):
        # reset output file
        with open('madeinchina.json', 'w') as f:
            f.write('')
    
        # settings content
        settings = ''
        
        # load settings from local file
        with open('settings.json', 'r') as f:
            for line in f.read():
                settings += line
        
        # parse settings
        settings = json.loads(settings)
        yield scrapy.Request('https://www.made-in-china.com/productdirectory.do?word=%s&file=&searchType=0&subaction=hunt&style=b&mode=and&code=0&comProvince=nolimit&order=0&isOpenCorrection=1&org=top&viewtype=G' % settings['category'], callback = self.parse)

    def parse(self, response):
        data = self.extractor.extract(response.text,base_url=response.url)
        for product in data['products']:
            product['supplier_id'] = "madeinchina" + str(self.count)
            self.count += 1
            yield product
            if product["price"] is not None:
                if "-" in product["price"] and len(product["price"].split()) == 3:
                    price = product["price"].split()[2]
                    price = price.split('-')
                    product["min_price"] = float(price[0])
                    product["max_price"] = float(price[1])
                elif "-" in product["price"] and len(product["price"].split()) == 2:
                    price = product["price"].split()[1]
                    price = price.split('-')
                    product["min_price"] = float(price[0])
                    product["max_price"] = float(price[1])
                elif "-" not in product["price"] and len(product["price"].split()) == 3:
                    price = product["price"].split()
                    product["min_price"] = float(price[2])
                    product["max_price"] = float(price[2])
                else:
                    price = product["price"].split()
                    product["min_price"] = float(price[1])
                    product["max_price"] = float(price[1])
                product.pop("price")
            if product["MOQs"] is not None:
                product["MOQs"] = int(product["MOQs"].split()[0])
            with open('madeinchina.json', 'a') as f:
                f.write(json.dumps(product) + '\n')
            
        
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
    process.crawl(MadeinChina)
    process.start()       
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
