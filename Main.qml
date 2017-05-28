import QtQuick 2.4
import Ubuntu.Web 0.2
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Qt.labs.settings 1.0
import U1db 1.0 as U1db

MainView {
    id: mainView
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "voice.sanderk1007kpnmailnl"

    width: units.gu(100)
    height: units.gu(75)

    property bool firstRun: true

    Settings{
        property alias firstRun: mainView.firstRun
    }

    U1db.Database {
        id: db
        path: "soundboard"
    }

    U1db.Document {
        id: apiDoc
        docId: 'theme'
        database: db
        create: true
        defaults: { 'apikey': "No API-Key" }
    }

    Component.onCompleted: {
        if(mainView.firstRun){
            mainPage.visible = false
            pageStack.push(introductionPage)
        }
        else{
            selector.selectedIndex = 10
            speedSelector.selectedIndex = 2
        }

    }

    PageStack{
        id: pageStack

        Page {
            id: mainPage
            header: PageHeader {
                id: pageHeader
                title: i18n.tr("Voice")
                StyleHints {
                    foregroundColor: "white"
                    backgroundColor: "#00adda"
                    dividerColor: "#00adda"
                }
                trailingActionBar.actions: [
                    Action {
                        iconName: "info"
                        text: "About"
                        onTriggered: {
                            PopupUtils.open(dialog)
                        }
                    },
                    Action {
                        iconName: "settings"
                        text: "Settings"
                        onTriggered: {
                            PopupUtils.open(changeApiDialog)
                        }
                    }

                ]


            }
            Image {
                id: testImg
                anchors.right: parent.left
                source: "http://www.voicerss.org/images/logo.png"
                onStatusChanged: if (testImg.status == Image.Ready) console.log('TestImg is loaded!')


            }

            Timer {
                id: delaytimer
                interval: 1000
                running: false
                repeat: false
                onTriggered: {
                    if (loaded.text == 'Not loaded'){
                        PopupUtils.open(noConnectionDialog)
                        console.log('Oops! No internet connection.')
                    }
                    else{
                        console.log('Yes! Working internet connection.')
                    }
                }
            }

            Text {
                id: loaded
                visible: false
                text: testImg.status == Image.Ready ? 'Loaded' : 'Not loaded'
                Component.onCompleted: {
                    delaytimer.start()
                }
            }



            WebView {
                id: webView
                width: 0
                height: 0
                anchors.left: parent.left
                anchors.top: pageHeader.bottom

            }

            Text {
                visible: false
                id: language
                text: "en-us"
            }

            Text {
                visible: false
                id: speed
                text: "0"
            }

            Text {
                visible: false
                id: html
                text: '<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta charset="utf-8" />
    <script>"use strict";var VoiceRSS={speech:function(e){this._validate(e),this._request(e)},_validate:function(e){if(!e)throw"The settings are undefined";if(!e.key)throw"The API key is undefined";if(!e.src)throw"The text is undefined";if(!e.hl)throw"The language is undefined";if(e.c&&"auto"!=e.c.toLowerCase()){var a=!1;switch(e.c.toLowerCase()){case"mp3":a=(new Audio).canPlayType("audio/mpeg").replace("no","");break;case"wav":a=(new Audio).canPlayType("audio/wav").replace("no","");break;case"aac":a=(new Audio).canPlayType("audio/aac").replace("no","");break;case"ogg":a=(new Audio).canPlayType("audio/ogg").replace("no","");break;case"caf":a=(new Audio).canPlayType("audio/x-caf").replace("no","")}if(!a)throw"The browser does not support the audio codec "+e.c}},_request:function(e){var a=this._buildRequest(e),t=this._getXHR();t.onreadystatechange=function(){if(4==t.readyState&&200==t.status){if(0==t.responseText.indexOf("ERROR"))throw t.responseText;new Audio(t.responseText).play()}},t.open("POST","https://api.voicerss.org/",!0),t.setRequestHeader("Content-Type","application/x-www-form-urlencoded; charset=UTF-8"),t.send(a)},_buildRequest:function(e){var a=e.c&&"auto"!=e.c.toLowerCase()?e.c:this._detectCodec();return"key="+(e.key||"")+"&src="+(e.src||"")+"&hl="+(e.hl||"")+"&r="+(e.r||"")+"&c="+(a||"")+"&f="+(e.f||"")+"&ssml="+(e.ssml||"")+"&b64=true"},_detectCodec:function(){var e=new Audio;return e.canPlayType("audio/mpeg").replace("no","")?"mp3":e.canPlayType("audio/wav").replace("no","")?"wav":e.canPlayType("audio/aac").replace("no","")?"aac":e.canPlayType("audio/ogg").replace("no","")?"ogg":e.canPlayType("audio/x-caf").replace("no","")?"caf":""},_getXHR:function(){try{return new XMLHttpRequest}catch(e){}try{return new ActiveXObject("Msxml3.XMLHTTP")}catch(e){}try{return new ActiveXObject("Msxml2.XMLHTTP.6.0")}catch(e){}try{return new ActiveXObject("Msxml2.XMLHTTP.3.0")}catch(e){}try{return new ActiveXObject("Msxml2.XMLHTTP")}catch(e){}try{return new ActiveXObject("Microsoft.XMLHTTP")}catch(e){}throw"The browser does not support HTTP request"}};
</script>
</head>
<body>
    <script>
        VoiceRSS.speech({
            key: "' + apiDoc.contents.apikey + '",
            src: "' + text.text + '",
            hl: "' + language.text + '",
            r: ' + speed.text + ',
            c: "mp3",
            f: "44khz_16bit_stereo",
            ssml: false
        });
    </script>
</body>
</html>'
            }

                Component {
                    id: dialog
                    Dialog {
                        id: dialogue
                        title: "About"
                        text: "This app is powered by Voice RSS and developed by Sander Klootwijk."
                        Button {
                            text: "Close"
                            color: "#00adda"
                            onClicked: PopupUtils.close(dialogue)
                        }
                    }
                }

                Component {
                    id: noConnectionDialog
                    Dialog {
                        id: dialogue
                        title: "Oops!"
                        text: "This app requires an active internet connection in order to work."
                        Button {
                            text: "Quit"
                            color: "#00adda"
                            onClicked: Qt.quit()
                        }

                        Button {
                            text: "Try Anyway"
                            color: "#888888"
                            onClicked: PopupUtils.close(dialogue)
                        }
                    }
                }

                Component {
                    id: helpDialog
                    Dialog {
                        id: dialogue
                        title: "Help, I don't hear anything!"
                        text: "<p>Are you sure that you've turned up the volume? Test this by typing some long string in the text field. Then click on 'Speech Text'. Immediately press the volume up button.</p>If it's still not working, make sure that you have an active internet connection."
                        Button {
                            text: "Close"
                            color: "#00adda"
                            onClicked: PopupUtils.close(dialogue)
                        }
                    }
                }

                Component {
                    id: changeApiDialog
                    Dialog {
                        id: dialogue
                        title: "Change API-Key"
                        text: "Please enter your API-Key and click on 'Done'.\n(Create a free api at 'VoiceRSS.org')"
                        TextField {
                            id: apikeyField
                            placeholderText: "API-Key"
                        }


                        Button {
                            text: "Done"
                            color: "#00adda"
                            onClicked: {
                                apiDoc.contents =  { 'apikey': apikeyField.text }
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

                ScrollView {
                    id: view
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: parent.height - pageHeader.height

                    Column {
                        id: columnEuropa
                        width: view.width

                        Rectangle {
                            width: parent.width
                            height: units.gu(1)
                            color: "white"
                        }

                        TextArea {
                            width: parent.width - units.gu(2)
                            anchors.horizontalCenter: parent.horizontalCenter
                            id: text
                            placeholderText: "Text to speech..."
                        }

                        Rectangle {
                            width: parent.width
                            height: units.gu(1)
                            color: "white"
                        }

                        Button {
                            width: parent.width - units.gu(2)
                            anchors.horizontalCenter: parent.horizontalCenter
                            id: button
                            text: "Speech Text"
                            color: "#00adda"

                            onClicked: webView.loadHtml(html.text);
                        }

                        Rectangle {
                            width: parent.width
                            height: units.gu(1)
                            color: "white"
                        }

                        Label {
                            text: "Language:"
                            anchors.left: selector.left
                        }

                        Rectangle {
                            width: parent.width
                            height: 5
                            color: "white"
                        }

                        OptionSelector {
                            id: selector
                            width: parent.width - units.gu(2)
                            containerHeight: parent.height / 2
                            anchors.horizontalCenter: parent.horizontalCenter
                            model: ["Catalan","Chinese (China)","Chinese (Hong Kong)","Chinese (Taiwan)","Danish","Dutch","English (Australia)","English (Canada)","English (Great Britain)","English (India)","English (United States)","Finnish","French (Canada)","French (France)","German","Italian","Japanese","Korean","Norwegian","Polish","Portuguese (Brazil)","Portuguese (Portugal)","Russian","Spanish (Mexico)","Spanish (Spain)","Swedish" ]
                            onSelectedIndexChanged: {
                                switch(selector.selectedIndex) {
                                case 0:
                                    language.text = "ca-es"
                                    break;
                                case 1:
                                    language.text = "zh-cn"
                                    break;
                                case 2:
                                    language.text = "zh-hk"
                                    break;
                                case 3:
                                    language.text = "zh-tw"
                                    break;
                                case 4:
                                    language.text = "da-dk"
                                    break;
                                case 5:
                                    language.text = "nl-nl"
                                    break;
                                case 6:
                                    language.text = "en-au"
                                    break;
                                case 7:
                                    language.text = "en-ca"
                                    break;
                                case 8:
                                    language.text = "en-gb"
                                    break;
                                case 9:
                                    language.text = "en-in"
                                    break;
                                case 10:
                                    language.text = "en-us"
                                    break;
                                case 11:
                                    language.text = "fi-fi"
                                    break;
                                case 12:
                                    language.text = "fr-ca"
                                    break;
                                case 13:
                                    language.text = "fr-fr"
                                    break;
                                case 14:
                                    language.text = "de-de"
                                    break;
                                case 15:
                                    language.text = "it-it"
                                    break;
                                case 16:
                                    language.text = "ja-jp"
                                    break;
                                case 17:
                                    language.text = "ko-kr"
                                    break;
                                case 18:
                                    language.text = "nb-no"
                                    break;
                                case 19:
                                    language.text = "pl-pl"
                                    break;
                                case 20:
                                    language.text = "pt-br"
                                    break;
                                case 21:
                                    language.text = "pt-pt"
                                    break;
                                case 22:
                                    language.text = "ru-ru"
                                    break;
                                case 23:
                                    language.text = "es-mx"
                                    break;
                                case 24:
                                    language.text = "es-es"
                                    break;
                                case 25:
                                    language.text = "sv-se"
                                    break;
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: units.gu(1)
                            color: "white"
                        }

                        Label {
                            text: "Speed:"
                            anchors.left: selector.left
                        }

                        Rectangle {
                            width: parent.width
                            height: 5
                            color: "white"
                        }

                        OptionSelector {
                            id: speedSelector
                            width: parent.width - units.gu(2)
                            containerHeight: parent.height / 2
                            anchors.horizontalCenter: parent.horizontalCenter
                            model: ["Fastest","Faster","Normal","Slower","Slowest"]
                            onSelectedIndexChanged: {
                                switch(speedSelector.selectedIndex) {
                                case 0:
                                    speed.text = "3"
                                    break;
                                case 1:
                                    speed.text = "1"
                                    break;
                                case 2:
                                    speed.text = "0"
                                    break;
                                case 3:
                                    speed.text = "-2"
                                    break;
                                case 4:
                                    speed.text = "-4"
                                    break;
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: units.gu(1)
                            color: "white"
                        }
                    }
                }

                MouseArea {
                    id: helpArea
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: units.gu(2)
                    width: units.gu(5)
                    height: units.gu(5)
                    onClicked: PopupUtils.open(helpDialog)
                }

                Icon {
                    id: helpIcon
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: units.gu(2)
                    width: units.gu(5)
                    height: units.gu(5)
                    color: "#00adda"
                    name: "help"
                }



            }

            Component{
                id: introductionPage
                Introduction{}
            }

        }
    }
