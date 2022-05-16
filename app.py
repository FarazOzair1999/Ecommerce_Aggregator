#
# Flask web app to run scrapy spider from web interface
#

# packages
from flask import Flask
from flask import render_template
from flask import request
import json
import subprocess
from rankingalgo_alibaba import alibaba_ranking
from rankingalgo_dhgate import dhgate_ranking
from rankingalgo_ecplaza import ecplaza_ranking
from rankingalgo_madeinchina import madeinchina_ranking
from rankingalgo_final import final_ranking

# create app instance
app = Flask(__name__)
    
# run scraper route
@app.route('/run/', methods=['GET'])
def run():
    if request.method == 'GET':
        query = str(request.args['query'])
        moq = int(request.args['moq'])
        minp = int(request.args['minp'])
        maxp = int(request.args['maxp'])
        print(query)
        if " " in query:
            query = str(query).replace(" ","+")
        else:
            pass

    # extract user input parameters
    category = query
    
    # settings content
    settings = ''
    
    # open settings file
    with open('settings.json', 'r') as f:
        for line in f.read():
            settings += line
    
    # parse settings
    settings = json.loads(settings)
    
    # update settings
    settings['category'] = category
    
    # write scraper settings
    with open('settings.json', 'w') as f:
        f.write(json.dumps(settings, indent=4))
    
    # run scraper
    process = subprocess.Popen('python alibaba.py', shell=True)
    process.wait()
    process = subprocess.Popen('python dhgate.py', shell=True)
    process.wait()
    process = subprocess.Popen('python madeinchina.py', shell=True)
    process.wait()
    process = subprocess.Popen('python ecplaza.py', shell=True)
    process.wait()
    # output content
    output = ''
    
    #ranking each website
    alibaba_ranking()
    dhgate_ranking()
    ecplaza_ranking()
    madeinchina_ranking()

    #final ranking of all websites
    final_ranking(moq,minp,maxp)
    
    with open('result.json', 'r') as f:
        for line in f.read():
            output += line
    return output

# main driver
if __name__ == '__main__':
    # run app
    app.run(debug=True, threaded=True)
