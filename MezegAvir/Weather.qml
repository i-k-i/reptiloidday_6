import QtQuick 2.0

Item {
    width: 350
    height: (rowHeight + componentSpacing) * weatherModel.count + padding * 2

    property int padding: 8
    property int fontSize: 18
    property int rowHeight: 23
    property int cellNameWidth: 130
    property int componentSpacing: 3

    // ROW FOR ONE INFO ITEM
    Component {
        id: weatherRowComponent

        Item {
            height: rowHeight

            Column {
                spacing: componentSpacing

                Row {
                    spacing: componentSpacing
                    visible: (name == "avdala" && value == "") ? false : true

                    Text {
                        font.pixelSize: fontSize
                        width: cellNameWidth
                        text: name + ":"
                    }
                    Text {
                        font.pixelSize: fontSize
                        text: value
                    }
                    Text {
                        font.pixelSize: fontSize
                        text: unit
                        visible: (value == "") ? false : true
                    }
                }
            }
        }
    }

    // MAIN VIEW
    ListView {
        id: weatherListView
        spacing: 6
        model: weatherModel
        delegate: weatherRowComponent
        anchors.fill: parent
    }

    // DATA MANIPULATION:
    ListModel {
        id: weatherModel

        ListElement {
            name: "temperature"
            value: ""
            unit: "°C"
        }

        ListElement {
            name: "humidity"
            value: ""
            unit: "%"
        }

        ListElement {
            name: "pressure"
            value: ""
            unit: "hpa"
        }

        ListElement {
            name: "sunset"
            value: ""
            unit: ""
        }

        ListElement {
            name: "avdala"
            value: ""
            unit: ""
        }
    }

    function updateWeatherModel(temperature, humidity, pressure, sunset, avdala) {
        weatherModel.setProperty(0, "value", temperature.toString());
        weatherModel.setProperty(1, "value", humidity.toString());
        weatherModel.setProperty(2, "value", pressure.toString());
        weatherModel.setProperty(3, "value", sunset);
        weatherModel.setProperty(4, "value", avdala);
    }
}
