import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Window 2.0
//import "Logic.js" as Logic
import "qrc:/"


ApplicationWindow {
    id: appWindow
    visible: true

    width: layerCitySearch.width + appWindow.padding * 2
    height: layerCitySearch.height + layerWeather.height * 1.3

    maximumHeight: minimumHeight
    maximumWidth: minimumWidth

    title: qsTr(" : מזג אוויר")

    signal getWeather(string cityID)

    signal showLoader()
    signal hideLoader()

    property int padding: 6
    property int searchHeight: 40
    property int searchFieldWidth: 100

    // MAIN VIEW:
    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    CitySearch {
        id: layerCitySearch
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: appWindow.padding
    }

    Weather {
        id: layerWeather
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: layerCitySearch.bottom
        anchors.topMargin: appWindow.padding

        visible: false
    }

    Rectangle {
        id: layerLoader
        visible: false
        anchors.fill: parent

        AnimatedImage {
            anchors.centerIn: parent
            source: "img/loader"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                layerWeather.updateWeatherModel("", "", "", "", "");
                hideLoader();
            }
        }
    }

    // DATA MANIPULATION:
    onShowLoader: {
        layerLoader.visible = true;
    }

    onHideLoader: {
        layerLoader.visible = false;
        layerWeather.visible = true;
    }

    onGetWeather: {
        console.log("Requesting weather for: " + cityID);
        showLoader();

        var params = [];
        var appID  = "adfb5224a2b72b3128172ceca0ba4042";
        var url    = "http://api.openweathermap.org/data/2.5/weather?";

        params.push("id=" + cityID);
        params.push("appid=" + appID);
        params.push("units=metric");
        url += params.join("&");

        request(url, function(responce) {
            var data = JSON.parse(responce.responseText);

            var sunsetTS = data.sys.sunset;

            var sunset = setSunsetDate(sunsetTS);
            var avdala = setUntilAvdala(sunsetTS);

            var temperature = data.main.temp;
            var humidity = data.main.humidity;
            var pressure = data.main.pressure;

            layerWeather.updateWeatherModel(temperature, humidity, pressure, sunset, avdala);
            hideLoader();
        });
    }

    function request(url, callback) {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                if(myxhr.readyState === XMLHttpRequest.DONE) {
                    callback(myxhr)
                }
            }
        })(xhr);
        xhr.open('GET', url, true);
        xhr.send('');
    }

    function setUntilAvdala(sunsetTS) {
        var avdala = "";
        var dateCurrent = new Date();
        var dateCurrentTS = Math.floor(dateCurrent.getTime() / 1000);

        if(dateCurrentTS < sunsetTS) {
            var diff = sunsetTS - dateCurrentTS;

            var hrs = Math.floor(diff / (60 * 24));
            diff = diff - (hrs * (60 * 24));

            var min = Math.floor(diff / 60);
            var sec = diff - min * 60;

            avdala = ((hrs > 0) ? hrs + " hr. " : "")
                    + ((min > 0) ? min + " min. " : "")
                    + ((sec > 0) ? sec + " sec. " : "");
        }

        return avdala;
    }

    function setSunsetDate(sunsetTS) {
        var sunsetDate = new Date(sunsetTS * 1000)
        var sunset = sunsetDate.toDateString() + " " + sunsetDate.toTimeString();

        return sunset;
    }
}
//            "coord":{
//                "lon":34.77,
//                "lat":32.01
//            },
//            "weather":[{
//                         "id":801,
//                         "main":"Clouds",
//                         "description":"few clouds",
//                         "icon":"02n"
//                     }],
//             "base":"cmc stations",
//             "main": {
//                "temp":20.25,
//                "pressure":1010,
//                "humidity":82,
//                "temp_min":20,
//                "temp_max":20.7
//            },
//            "wind":{
//                "speed":3.1,
//                "deg":300
//            },
//            "clouds":{
//                "all":20
//            },
//            "dt":1460313862,
//            "sys":{
//                "type":1,
//                "id":5913,
//                "message":0.0042,
//                "country":"IL",
//                "sunrise":1460258213,
//                "sunset":1460304446
//            },
//            "id":294751,
//            "name":"Holon",
//            "cod":200
