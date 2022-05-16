from matplotlib.font_manager import json_load
import pandas as pd
import seaborn as sns
from sklearn.preprocessing import minmax_scale
from skcriteria.preprocessing.scalers import MaxScaler, MinMaxScaler
import skcriteria as skc
from skcriteria.preprocessing import invert_objectives, scalers
from skcriteria.madm import simple
import json

def final_ranking(moq,minp,maxp):
    alibaba = pd.read_json(r'alibaba_rank.json')
    dhgate = pd.read_json(r'dhgate_rank.json')
    ecplaza = pd.read_json(r'ecplaza_rank.json')
    madeinchina = pd.read_json(r'madeinchina_rank.json')
    matrix = []
    alter =[]
    for i in range(len(alibaba)):
        alter.append(alibaba.iloc[i,7])
        m = []
        m.append(alibaba.iloc[i,4])
        m.append(alibaba.iloc[i,9])
        m.append(alibaba.iloc[i,8])
        m.append(alibaba.iloc[i,10])
        matrix.append(m)
    for i in range(len(dhgate)):
        alter.append(dhgate.iloc[i,7])
        m = []
        m.append(dhgate.iloc[i,2])
        m.append(dhgate.iloc[i,8])
        m.append(dhgate.iloc[i,9])
        m.append(dhgate.iloc[i,10])
        matrix.append(m)
    for i in range(len(ecplaza)):
        alter.append(ecplaza.iloc[i,6])
        m = []
        m.append(ecplaza.iloc[i,2])
        m.append(ecplaza.iloc[i,7])
        m.append(ecplaza.iloc[i,8])
        m.append(ecplaza.iloc[i,9])
        matrix.append(m)
    for i in range(len(madeinchina)):
        alter.append(madeinchina.iloc[i,5])
        m = []
        m.append(madeinchina.iloc[i,2])
        m.append(madeinchina.iloc[i,6])
        m.append(madeinchina.iloc[i,7])
        m.append(madeinchina.iloc[i,8])
        matrix.append(m)
    criteria_data = skc.mkdm(
    matrix = matrix,          # the pandas dataframe
    objectives = [min, min, min, min],
    alternatives = alter,      # direction of goodness for each column
    criteria = ["moq","min_price","max_price","rank"], # attribute/column name
    weights =  [0.05,0.25,0.2,0.5]    # weights for each attribute (based on google form data collection)
    )
    inverter = invert_objectives.MinimizeToMaximize()
    criteria_data = inverter.transform(criteria_data)

    scaler = scalers.SumScaler(target="matrix")
    criteria_data = scaler.transform(criteria_data)
    # weighted sum
    dm = simple.WeightedSumModel()
    rank = dm.evaluate(criteria_data)
    result = pd.concat([alibaba, dhgate,ecplaza,madeinchina], ignore_index=True, sort=False)
    result = result.drop_duplicates('supplier_id')
    result['Rank'] = rank.rank_
    result = result.sort_values(by=['Rank'], ascending=True)
    result = result.drop_duplicates('Rank')
    filtered = result.loc[(result['MOQs'] > moq) & (result['min_price'] > minp) & result['max_price'] < maxp]
    json_str = filtered.to_json(orient='records' ,date_format='iso')
    parsed = json.loads(json_str)
    
    with open('result.json', 'w') as json_file:
        json_file.write(json.dumps({"products": parsed} ))
