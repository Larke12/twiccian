import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1

import twiccian 1.0

ApplicationWindow {
    id: window
    width: 800
    height: 600
    visible: true
    // TODO: Dynamically change the title
    title: "Mega Man Battle Network 3 Blue PB - Twiccian"

    // Default view which contains the mpv window and chat
    SplitView {
        id: splitview
        anchors.fill: parent
        orientation: Qt.Horizontal

        // Use default Item container for the MpvObject
        // TODO: Ask for user input on a stream they would like to watch.
        // TODO: Query API for live channels, remove user input dialog.
        Item {
            id: mpv
            Layout.maximumHeight: window.height
            Layout.maximumWidth: window.width
            width: 580
            height: 400

            MpvObject {
                id: renderer
                anchors.fill: parent

                MouseArea {
                    anchors.fill: parent
                    onClicked: renderer.command(["loadfile", "http://vod.ak.hls.ttvnw.net/v1/AUTH_system/vods_2826/nmarkro_15601296912_281029264/chunked/highlight-9467635-muted-AGRAEYOW2Q.m3u8"])
                }
            }
        }

        // TODO: replace test text box with actual chat view
        TextField {
            id: chat
            placeholderText: "Chris: This is soooocool\nRyan: Best senior design project ever!\nDan: lol yeah it is"

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                // Change chat position layout and resize mpv to an acceptible size
                onClicked: if (mouse.button & Qt.LeftButton) {
                               if (splitview.orientation == Qt.Vertical) {
                                   splitview.orientation = Qt.Horizontal
                                   mpv.width = window.width - 220
                               } else {
                                   splitview.orientation = Qt.Vertical
                                   mpv.height = window.height - 120
                               }
                           }
            }
        }
    }
}
