import QtQuick 2.12
import QtQuick.Controls 2.5


Item {
    id: mainItem

    property string password

    signal accept()

    anchors.fill: parent
    opacity: 0
    visible: false

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#202020"
        opacity: 0.5
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {}
    }

    Rectangle {
        id: cardBackground
        anchors.verticalCenter: mainItem.verticalCenter
        anchors.horizontalCenter: mainItem.horizontalCenter
        color: "#404040"
        width: 400
        radius: 5
        height: passphraseText.anchors.topMargin * 2 +
                passphraseText.contentHeight +
                cardTitle.contentHeight +
                acceptButton.height

        Text {
            id: cardTitle
            text: "Input storage key"
            color: "#ffffff"
            font.pointSize: 16
            y: 5
            x: (parent.width - width)/2
        }

        Rectangle {
            id: passphraseBackground
            color: "#fb0d0d"
            radius: 5
            opacity: 0
            anchors.fill: passphraseText

            PropertyAnimation {
                id: wrongKey
                target: passphraseBackground;
                to: 0.3
                duration: 100
                property: "opacity";
                easing.type: Easing.InQuad
                onFinished: { wrongKey_end.start(); }
            }
            PropertyAnimation {
                id: wrongKey_end
                target: passphraseBackground;
                to: 0
                duration: 600
                property: "opacity";
                easing.type: Easing.OutQuad
            }
        }

        TextInput {
            id: passphraseText
            onEditingFinished: { password = text; }

            color: "#ffffff"
            font.pointSize: 16
            horizontalAlignment: Qt.AlignHCenter
            echoMode: TextInput.Password
            focus: true

            anchors.margins: 15
            anchors.top: cardTitle.bottom
            anchors.left: cardBackground.left
            anchors.right: cardBackground.right

            Keys.onReturnPressed: { password = text; accept(); }
        }

        RectButton {
            id: acceptButton
            text: "Proceed"
            y: parent.height - height - 5
            x: (parent.width - width)/2

            Keys.onReturnPressed: { accept(); }
            onClicked: { accept(); }
        }
    }

    function show() {
        state = "shown"
    }

    function close() {
        state = "";
        password = "";
    }

    function showPasswordIsWrong() {
        wrongKey.start();
        shakeInputText();
    }

    function shakeInputText() {

    }

    states: [
        State {
            name: "shown"
            PropertyChanges { target: mainItem; opacity: 1; }
        }
    ]

    transitions: Transition {
        PropertyAnimation { target: mainItem; property: "opacity"; easing.type: Easing.OutQuad}
        PropertyAnimation { target: cardBackground; property: "color"; easing.type: Easing.OutQuad}
    }

    onOpacityChanged: visible = (opacity != 0);
}