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
                    onClicked: renderer.command(["loadfile", "http://video6.iad02.hls.ttvnw.net/hls139/brotatoe_16534765808_311261504/chunked/py-index-live.m3u8?token=id=5865055331274984883,bid=16534765808,exp=1442932461,node=video6-1.iad02.hls.justin.tv,nname=video6.iad02,fmt=chunked&sig=aba2221c448832ee49c8155ae9c2e4b93b491a74"])
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
