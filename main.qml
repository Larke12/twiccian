// This file is part of Twiccian.
// 
// Twiccian is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// Twiccian is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with Twiccian.  If not, see <http://www.gnu.org/licenses/>.

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
    title: "Twiccian | Minimal System"


    Api {
        id: apiobj
    }

    // A Qt view split into tabs, tabs update and play even when not in view once opened
    TabView {
        id: frame
        anchors.fill: parent
        anchors.margins: 4

        Tab {
            id: login
            title: "Login"
            
            Item {
                // Minimal: Ask for user input on a stream they would like to watch.
                // 50%: Login to view Following
                
                Rectangle {
                    id: logo_rect
                    width: 0
                    height: 0
                    x: (window.width / 2) - ((792 * 0.25) / 2)
                    y: (window.height / 2)  - ((262 * 0.25) / 2) - 200
                    scale: 0.25
                    color: "#6441A5"
                    Image {
                        id: logo
                        fillMode: Image.PreserveAspectFit
                        sourceSize.width: 792
                        sourceSize.height: 262
                        smooth: true
                        source: "assets/twitch_logo_white.png"
                    }
                }
                
                Rectangle {
                    id: url_sub_rect
                    x: (window.width / 2) - 200
                    y: (window.height / 2) - 120
                    TextField {
                        id: submitUrl
                        width: 400
                        horizontalAlignment: TextInput.AlignHCenter
                        inputMask: qsTr("")
                        placeholderText: qsTr("Ex: http://www.twitch.tv/zackcat")
                    }
                }
                
                Rectangle {
                    id: button_rect
                    width: 25
                    height: 25
                    x: (window.width / 2)  - 50
                    y: (window.height / 2) - 50
                    scale: 1.0
                    color: "#6441A5"
                    Button {
                        id: submission
                        text: qsTr("Submit")
                        // TODO: Send URL to daemon: submitUrl.text
                        onClicked: {
                            apiobj.sendUrl(submitUrl.text);
                            // Switch to stream tab
                            frame.currentIndex = 3;
                        }
                        
                    }
                }
            }
            
            // Have youtube-dl convert the URL to a streamable link
            
            // TODO: Have mpv play new streamable link (returned from daemon)
            
            
            // 50% requires login to work
            //login();
            //logOut();

            // Login page will also accept URL's until the other views are acceptable
            // Login View will be moved from a tab view to a button at some point
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
                            // Accept returned stream URL
                            onClicked: renderer.command(["loadfile", apiobj.recvUrl()])
                        }
                    }
                }

                // TODO: replace test text box with actual chat view
                //openChat();
                TextField {
                    id: chat
                    placeholderText: "Chat View coming to \nan app near you!"
                    // TODO: Get Read-Only Chat

                    // TODO: Add interaction with chat view
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

                                           mpv.width = window.width - 220
                                       } else {
                                           splitview.orientation = Qt.Vertical

                                           /*
                                            **** Qt Creator bug, flags an error in Design View ****
                                            **** Uncomment for debug/test runs                 ****
                                           */

                                           mpv.height = window.height - 120
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
                color: styleData.selected ? "#6441A5" :"#B9A3E3"
                border.color:  "#262626"
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
            
            frame: Rectangle { color: "#6441A5" }
            
        }
    }
}
