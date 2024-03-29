import QtQuick 2.12
import QtQuick.Dialogs 1.2

Item {
    id: mainItem
    anchors.fill: parent
    visible: false;

    property variant storages: []

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#202020"
        onOpacityChanged: mainItem.visible = (opacity != 0);
        opacity: 0
    }

    MouseArea {
        anchors.fill: parent
        onClicked: { mainItem.close(); }
    }

    Rectangle {
        id: menuBackground
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "#353535"

        width: 300
        x: -width

        MouseArea {
            anchors.fill: parent
            onClicked: {mainItem.state = "shown"}
        }

        Flickable {
            x: 0
            y: topBar.height
            height: menuBackground.height - y
            width: menuBackground.width
            flickableDirection: Flickable.VerticalFlick
            contentWidth: width
            contentHeight: lastItem.y + lastItem.height

            Text {
                x: 6
                y: 5
                color: "#ffffff"
                text: "Storage folder"
                font.pointSize: 14
            }
            Text {
                x: (parent.width - width)/2
                y: 35
                color: "#ffffff"
                text: pwmodel.storage.storageDir
                font.pointSize: 10
            }
            RectButton {
                x: (parent.width - width)/2
                y: 55
                width: parent.width * 0.8
                text: "Change folder"
                onClicked: {fileDialog.show();}
                font.pointSize: 10
            }

            Text {
                x: 6
                y: 120
                color: "#ffffff"
                text: "Storage type"
                font.pointSize: 14
            }

            RectButton {
                id: type1
                x: (parent.width - width)/2
                y: 140
                opacity: pwmodel.storage === storages[0] ? 1 : 0;
                background.opacity: 0
                color: lastItem.selectedStorage === storages[0] ? "#509040" : "#606060";
                width: parent.width * 0.9
                text: storages[0].storageDescription()
                font.pointSize: 10
                onClicked: {lastItem.selectedStorage = storages[0];}
            }
            RectButton {
                id: type2
                x: (parent.width - width)/2
                y: 140
                opacity: pwmodel.storage === storages[1] ? 1 : 0;
                background.opacity: 0
                color: lastItem.selectedStorage === storages[1] ? "#509040" : "#606060";
                width: parent.width * 0.9
                text: storages[1].storageDescription()
                font.pointSize: 10
                onClicked: {lastItem.selectedStorage = storages[1];}
            }
            RectButton {
                id: lastItem
                x: (parent.width - width)/2
                y: currentTypeBottom()
                width: parent.width * 0.8
                text: "Change type"
                font.pointSize: 10

                property variant selectedStorage: pwmodel.storage
                onClicked: {
                    if (mainItem.state == "shown")
                    {
                        selectedStorage = pwmodel.storage
                        mainItem.state = "type_changing";
                        return;
                    }

                    if (pwmodel.storage !== selectedStorage)
                    {
                        pwmodel.storage = selectedStorage;
                        pwmodel.save();
                    }

                    mainItem.state = "shown";
                }

                function currentTypeBottom() {
                    let currentType = type1.opacity == 0 ? type2 : type1;
                    return currentType.y + currentType.height;
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        selectFolder: true
        function show() {
            fileDialog.folder = "file:///" + Qt.resolvedUrl( pwmodel.storage.storageDir );
            fileDialog.open();
        }

        onAccepted: { pwmodel.storage.setDir(folder.toString().replace("file:///","")); }
    }


    function show() { state = "shown"; }
    function close() { state = ""; }

    states:  [
        State {
            name: "shown"
            PropertyChanges { target: background; opacity: 0.6; }
            PropertyChanges { target: menuBackground; x: 0; }
        },
        State {
            name: "type_changing"
            extend: "shown"
            PropertyChanges { target: type1; opacity: 1; y: 150; background.opacity: 0.7; }
            PropertyChanges { target: type2; opacity: 1; y: type1.y + type1.height - 10; background.opacity: 0.7; }
            PropertyChanges { target: lastItem; text: "Set"; y: type2.y + type2.height + 10; }
        }
    ]

    transitions: Transition {
        PropertyAnimation {
            targets: [background, type1, type2]
            property: "opacity"
            easing.type: Easing.InOutQuad
        }
        PropertyAnimation {
            target: menuBackground
            property: "x"
            easing.type: Easing.InOutQuad
        }
        PropertyAnimation {
            targets: [type1, type2, lastItem]
            property: "y"
            easing.type: Easing.InOutQuad
        }
    }
}
