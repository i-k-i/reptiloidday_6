import QtQuick 2.2
import QtQuick.Controls 1.1

Item {
    height: rowCitySearch.height
    width: rowCitySearch.width

    signal getCityID(string cityName)
    signal setCityID(string cityID)

    property bool isCityNameChanged: false

    // MAIN VIEW:
    Row {
        id: rowCitySearch
        spacing: appWindow.padding
        height: appWindow.searchHeight

        TextField {
            id: txtCityName
            height: parent.height
            width: appWindow.searchFieldWidth * 2
            placeholderText: qsTr("City")
            onTextChanged: isCityNameChanged = true
        }

        Text {
            height: parent.height
            width: 20
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "or"
        }

        TextField {
            id: txtCityID
            height: parent.height
            width: appWindow.searchFieldWidth
            placeholderText: qsTr("City ID")
        }

        Button {
            height: parent.height
            width: 100
            id: btnProcessHolon
            text: qsTr("מזג אוויר בחולון")
            onClicked: {
                txtCityName.text = "Holon"
                setCityID("294751");
            }
        }

        Button {
            height: parent.height
            width: 100
            id: btnProcessCity
            text: qsTr("!לברר")
            onClicked: {
                if (isCityNameChanged) {
                    getCityID(txtCityName.text)
                } else if (txtCityID.text != "") {
                    getWeather(txtCityID.text)
                }
            }
        }
    }

    // DATA MANIPULATION:
    onGetCityID: {
        console.log("city name: " + cityName);
        // JFT
        setCityID("294751");
    }

    onSetCityID: {
        isCityNameChanged = false;
        txtCityID.text = cityID;
        txtCityID.focus = true;
        appWindow.getWeather(txtCityID.text);
    }
}
