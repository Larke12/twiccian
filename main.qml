import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1

import twiccian 1.0

ApplicationWindow {
    id: window
    width: 800
    height: 600
    visible: true
    // TODO: Dynamically change the title from API calls
    // Keep for Now Playing, or change with the view?
    title: "Mega Man Battle Network 3 Blue PB - Twiccian"

    // A Qt view split into tabs, tabs update and play even when not in view
    TabView {
        id: frame
        anchors.fill: parent
        anchors.margins: 4

        Tab {
            id: login
            title: "Login"

            //login();
            //logOut();

            // Login page will also accept URL's until the other views are acceptable
            // Login View will be moved from a tab view to a button at some point

            // Ask for user input on a stream they would like to watch.

            Label {
                x: 304
                y: 101
                text: qsTr("Please enter a live Twitch page:")
            }

            Button {
                id: button1
                x: 358
                y: 177
                text: qsTr("Ok")
            }

            TextField {
                id: textField1
                x: 343
                y: 120
                width: 80
                height: 6
                placeholderText: qsTr("http://www.twitch.tv/zackcat")
            }
        }

        Tab {
            id: follow
            title: "Following"

            //results:Result[]
            //queryLive();
            //queryRecent();
        }

        Tab {
            id: search
            title: "Search"

            //results:Result[]
            //query();
        }

        Tab {
            id: stream
            title: "Stream"
            // A Qt view which contains the mpv window and chat
            SplitView {
                id: splitview
                anchors.fill: parent
                orientation: Qt.Horizontal

                // Use default Item container for the MpvObject
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

                        // Obtain stream from the daemon
                        //StreamView();
                        //~StreamView();
                        //unwrapUrl(String);

                        MouseArea {
                            anchors.fill: parent
                            onClicked: renderer.command(["loadfile", "http://vod.ak.hls.ttvnw.net/v1/AUTH_system/vods_2826/nmarkro_15601296912_281029264/chunked/highlight-9467635-muted-AGRAEYOW2Q.m3u8"])
                        }
                    }
                }

                // TODO: replace test text box with actual chat view
                //openChat();
                TextField {
                    id: chat
                    placeholderText: "Chris: This is soooocool\nRyan: Best senior design project ever!\nDan: lol yeah it is"

                    // TODO: add interaction with chat view
                    //sendChatMessage();

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        // Change chat position layout and resize mpv to an acceptible size (when uncommented)
                        onClicked: if (mouse.button & Qt.LeftButton) {
                                       if (splitview.orientation == Qt.Vertical) {
                                           splitview.orientation = Qt.Horizontal

                                           /*
                                            **** Qt Creator bug, flags an error in Design View ****
                                            **** Uncomment for debug/test runs                 ****
                                           */

                                           //mpv.width = window.width - 220
                                       } else {
                                           splitview.orientation = Qt.Vertical

                                           /*
                                            **** Qt Creator bug, flags an error in Design View ****
                                            **** Uncomment for debug/test runs                 ****
                                           */

                                           //mpv.height = window.height - 120
                                       }
                                   }
                    }
                }
            }
            // Close the stream and jump to Following View
            //close();
        }
        Tab {
            id: profile
            title: "Profile"

            // Inital status shows a web view, to switch to a local view later
            //account:Account
            //openWebView(Account);
        }

        style: TabViewStyle {
            frameOverlap: 1
            tabsAlignment: Qt.AlignHCenter
            tab: Rectangle {
                color: styleData.selected ? "steelblue" :"lightsteelblue"
                border.color:  "steelblue"
                implicitWidth: Math.max(text.width + 4, 80)
                implicitHeight: 20
                radius: 2
                Text {
                    id: text
                    anchors.centerIn: parent
                    text: styleData.title
                    color: styleData.selected ? "white" : "black"
                }
            }
            frame: Rectangle { color: "steelblue" }
        }
    }
}
