# sudo apt-get -y install python-pip
# sudo pip install requests


import requests
import datetime
import time

citi_id = '294751'
appid = 'adfb5224a2b72b3128172ceca0ba4042'

def is_shabbat():
    if datetime.datetime.now().weekday() == 6:
        return True

current_url = 'http://api.openweathermap.org/data/2.5/weather?id={}&appid={}&units=metric'.format(citi_id, appid)
current_resp = requests.get(url=current_url)
json_data = current_resp.json()

exports_end = 'sunset: {}'.format(datetime.datetime.fromtimestamp(json_data['sys']['sunset'])) 

if is_shabbat() :
    time_delta = int(json_data['sys']['sunset']) - time.time() + 30*60
    time_delta_minutes = int(time_delta / 60)
    time_delta_seconds = int(time_delta - (time_delta_minutes * 60))
    time_delta_hours   = int(time_delta_minutes / 60)
    time_delta_minutes = time_delta_minutes - (time_delta_hours * 60)
    exports_end += '\n\t avdala in: {} hrs. {} min. {} sec.'.format(time_delta_hours, time_delta_minutes, time_delta_seconds) 

export_string = '{}: \n\t temp: {}*C \n\t hum: {} \n\t pres: {}\n\t {}'.format(
    json_data['name'], 
    json_data['main']['temp'], 
    json_data['main']['humidity'],
    json_data['main']['pressure'],
    exports_end
    )

if __name__ == '__main__':
    
    print current_resp.request.url
    print export_string





# print(export_string) # 4 python 3

# for key, value in current_resp.json().items():
    # print key, value

    # clouds {u'all': 40}
    # name Holon
    # coord {u'lat': 32.01, u'lon': 34.77}
    # sys {u'country': u'IL', u'sunset': 1460218011, u'message': 0.0137, u'type': 1, u'id': 5913, u'sunrise': 1460171876}
    # weather [{u'main': u'Clouds', u'id': 802, u'icon': u'03n', u'description': u'scattered clouds'}]
    # cod 200
    # base cmc stations
    # dt 1460239765
    # main {u'pressure': 1010, u'temp_min': 23, u'temp_max': 23, u'temp': 23, u'humidity': 60}
    # id 294751
    # wind {u'speed': 3.1, u'deg': 360}




# import ipdb; ipdb.set_trace



# forecast_url = 'http://api.openweathermap.org/data/2.5/forecast/city?id={}&APPID={}&units=metric'.format(citi_id, appid)
# forecast_resp = requests.get(url=forecast_url)


# stupino_id 486968
