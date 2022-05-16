import pandas as pd
import seaborn as sns
from sklearn.preprocessing import minmax_scale
from skcriteria.preprocessing.scalers import MaxScaler, MinMaxScaler
import skcriteria as skc
from skcriteria.preprocessing import invert_objectives, scalers

def alibaba_ranking():
    data_frame = pd.read_json(r'alibaba.json', lines=True)
    data_frame = data_frame.dropna()
    mat = []
    alter =[]
    for i in range(len(data_frame)):
        alter.append(data_frame.iloc[i,7])
        m = []
        m.append(data_frame.iloc[i,4])
        m.append(data_frame.iloc[i,9])
        m.append(data_frame.iloc[i,8])
        m.append(data_frame.iloc[i,1])
        m.append(data_frame.iloc[i,2])
        m.append(data_frame.iloc[i,3])
        mat.append(m)

    criteria_data = skc.mkdm(
        matrix = mat,          # the pandas dataframe
        objectives = [min, min,min, max, max, max],
        alternatives = alter,      # direction of goodness for each column
        criteria = ["moq","min_price","max_price","rating","review","company year"], # attribute/column name
        weights =  [0.05,0.25,0.25,0.15,0.15,0.15]    # weights for each attribute (based on google form data collection)
        )

    inverter = invert_objectives.MinimizeToMaximize()
    criteria_data = inverter.transform(criteria_data)

    scaler = scalers.SumScaler(target="matrix")
    criteria_data = scaler.transform(criteria_data)
    from skcriteria.madm import simple
    # weighted sum
    dm = simple.WeightedSumModel()
    rank = dm.evaluate(criteria_data)
    data_frame.insert(len(data_frame.columns), 'Rank', rank.rank_)
    with open('alibaba_rank.json', 'w') as f:
        f.write(' ')
    data_frame.to_json(r'alibaba_rank.json',orient = 'records')

