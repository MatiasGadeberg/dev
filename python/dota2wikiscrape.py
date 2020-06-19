import requests
from bs4 import BeautifulSoup

# get the data
maindata = requests.get('https://dota2.gamepedia.com/Dota_2_Wiki')

# load data into bs4
mainsoup = BeautifulSoup(maindata.text, 'html.parser')

baseurl = "https://dota2.gamepedia.com/"

# get data from scrape
heroes = []
for div in mainsoup.find_all('div', {'class': 'heroentry'}):
    hero = []
    hero.append(div.a['title'])
    hero.append(baseurl + '_'.join(div.a['title'].split(" ")))
    
    data = requests.get(hero[1])
    soup = BeautifulSoup(data.text, 'html.parser')
    
    heroes.append(hero)
print(heroes)