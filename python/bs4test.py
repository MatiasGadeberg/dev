import requests
from bs4 import BeautifulSoup
import numpy as np

# get the data
maindata = requests.get('https://dota2.gamepedia.com/Dota_2_Wiki')

# load data into bs4
mainsoup = BeautifulSoup(maindata.text, 'html.parser')

baseurl = "https://dota2.gamepedia.com/"

# get data from scrape

data = mainsoup.find('a', {'title': 'Strength'}).find_parent('tr').next_sibling.next_sibling.find_all('div', {'class': 'heroentry'})

heroes = []

#for div in mainsoup.find_all('div', {'class': 'heroentry'}):
for div in mainsoup.find('a', {'title': 'Strength'}).find_parent('tr').next_sibling.next_sibling.find_all('div', {'class': 'heroentry'}):
    
    hero = []
    hero.append(div.a['title'])
    herourl = baseurl + '_'.join(div.a['title'].split(" "))

    data = requests.get(herourl)
    soup = BeautifulSoup(data.text, 'html.parser')
    
    for b in soup.find('table', {'class': 'infobox'}).find_all('b'):
        hero.append(b.text)


    heroes.append(hero)

print(heroes)