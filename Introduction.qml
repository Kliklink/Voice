import QtQuick 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import com.canonical.Oxide 1.0
import Ubuntu.Web 0.2

Page {
    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Setup")
        StyleHints {
            foregroundColor: "white"
            backgroundColor: "#00adda"
            dividerColor: "#00adda"
        }
    }

    id: walkthrough
    property string appName
    property bool isFirstRun: true
    signal finished

    onFinished: {
        mainView.firstRun=false
        pageStack.clear()
        pageStack.push(mainPage)
        selector.selectedIndex = 10
        speedSelector.selectedIndex = 2
    }
    Component.onCompleted: mainView.automaticOrientation = false
    Component.onDestruction: mainView.automaticOrientation = true

    Label {
        id: label
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: parent.height/30
        width: parent.width/1.1
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        text: "Welcome to Voice! Voice is the first native text to speech app for Ubuntu Touch.\n \nThe only thing you'll need is a free API-Key from Voice RSS."
    }

    Label {
        id: finishLabel
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: parent.height/30
        width: parent.width/1.1
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        text: "Voice is configurated!\n \nDo you want to change the API-Key? Just go to the settings menu."
    }

    Button {
        id: createButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: haveoneButton.top
        anchors.bottomMargin: units.gu(3)
        text: "Create an API-Key"
        color: "#00adda"
        onClicked: {
            haveoneButton.visible = false
            createButton.visible = false
            label.visible = false
            createkeyView.visible = true
            doneButton.visible = true
        }
    }

    Button {
        id: haveoneButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: units.gu(5)
        text: "I already have an API-Key"
        color: "#00adda"
        onClicked: {
            PopupUtils.open(apiDialog)
        }
    }

    WebView {
        id: createkeyView
        visible: false
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: doneButton.top
        anchors.top: pageHeader.bottom
        anchors.bottomMargin: units.gu(1)

        url: "http://www.voicerss.org/registration.aspx"

    }

    Button {
        id: doneButton
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: units.gu(3)
        text: "Done"
        color: "#00adda"
        onClicked: {
            PopupUtils.open(apiDialog)
        }
    }

    Component {
        id: apiDialog
        Dialog {
            id: dialogue
            title: "API-Key"
            text: "Please enter your API-Key and click on 'Continue'."
            TextField {
                id: apikeyField
                placeholderText: "API-Key"
            }


            Button {
                text: "Continue"
                color: "#00adda"
                onClicked: {
                    apiDoc.contents =  { 'apikey': apikeyField.text }
                    doneButton.visible = false
                    label.visible = false
                    haveoneButton.visible = false
                    createButton.visible = false
                    createkeyView.visible = false
                    finishButton.visible = true
                    finishLabel.visible = true
                    PopupUtils.close(dialogue)
                }
            }

            Button {
                text: "Cancel"
                color: "#888888"
                onClicked: PopupUtils.close(dialogue)
            }
        }
    }

    Button {
        id: finishButton
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: units.gu(3)
        text: "Finish"
        color: "#00adda"
        onClicked: walkthrough.finished()
    }


}

