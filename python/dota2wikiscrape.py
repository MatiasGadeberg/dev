import requests
from bs4 import BeautifulSoup
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

print('import done')
# get the data
maindata = requests.get('https://dota2.gamepedia.com/Dota_2_Wiki')

# load data into bs4
mainsoup = BeautifulSoup(maindata.text, 'html.parser')
print('maindata recieved')

baseurl = "https://dota2.gamepedia.com/"

col_names = ['Hero','str','agi','int']
# get data from scrape
heroes = []
print('starting iterations')
for div in mainsoup.find('a', {'title': 'Strength'}).find_parent('tr').next_sibling.next_sibling.find_all('div', {'class': 'heroentry'}):
    hero = []
    hero.append(div.a['title'])
    herourl = baseurl + '_'.join(div.a['title'].split(" "))

    data = requests.get(herourl)
    soup = BeautifulSoup(data.text, 'html.parser')
    
    for b in soup.find('table', {'class': 'infobox'}).find_all('b'):
        hero.append(int(b.text))


    heroes.append(hero) 

df = pd.DataFrame(heroes, columns = col_names)
ax = df.plot.bar(x='Hero', y=['str','agi','int'], color = ['r','g','b'], subplots=True)
plt.show()