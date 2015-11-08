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

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtWebKit 3.0

import twiccian 1.0

ApplicationWindow {
    id: window
    width: 800
    height: 600
    visible: true
    // TODO: Dynamically change the title from API calls
    // Keep for Now Playing, or change with the view?
    title: "Twiccian | On the road to Viridian City!" // result.getTitle();

    /*
      This section is for API calls between QML and C++
      */
    Api {
        id: apiobj
    }

    // A Qt view split into tabs, tabs update and play even when not in view once opened
    TabView {
        id: frame
        anchors.fill: parent
        anchors.margins: 4
        visible: false
        tabsVisible: false

        Tab {
            id: follow
            title: "Following"
            
            Item {
                // TODO: Or dow we want a grid view? http://doc.qt.io/qt-4.8/qml-gridview.html
                Column {
                    // Avoid overlapping
                    id: cols
                    spacing: 5
                    x: (window.width / 4)
                    y: cols.spacing
                    
                    Repeater {
                        // Define number of results
                        model: 10
                        
                        delegate: Rectangle {
                            width: (window.width) / 2
                            height: 80
                            color: "white";
                            border { 
                                width: 1 
                                color: "black" }
                            radius: 3
            
                            TextInput {
                                anchors.fill: parent
                            }
                        }
                    }
                }
                
                Text {
                    id: follow_temp
                    anchors.fill: parent
                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    text: qsTr("This view will list all of the streams\nyou follow that are live")
                }
            }

            //results:Result[]
            //queryLive();
            //queryRecent();
        }

        Tab {
            id: search
            title: "Search"
            
            Text {
                id: search_temp
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                text: qsTr("This view will let you search, to the same extent as the website (API pending)")
            }

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
                        
                        // Player controls
                        Row {
                            // Anchor controls to bottom center of player
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: (parent.height / 2) - (window.width / 15)
                            
                            spacing: 15
                            
                            Button {
                                id: playpause
                                text: qsTr("Pause")
                                opacity: 0.75
                                onClicked: {
                                    if (playpause.text == "Pause") {
                                        renderer.command(["set", "pause", "yes"])
                                        playpause.text = qsTr("Play")
                                    } else {
                                        renderer.command(["set", "pause", "no"])
                                        playpause.text = qsTr("Pause")
                                    }
                                }
                            }
                            
                            Button {
                                id: makelive
                                text: qsTr("Live")
                                opacity: 0.75
                                onClicked: {
                                    renderer.command(["set", "pause", "no"])
                                    renderer.command(["loadfile", apiobj.getUrl()]) // API OBJ
                                    playpause.text = qsTr("Pause")
                                }
                            }
                            
                            CheckBox {
                                id: mute
                                opacity: 0.75
                                style: CheckBoxStyle {
                                            label: Text {
                                                color: "#FFFFFF"
                                                text: "Mute"
                                            }
                                }
                                checked: false
                                onClicked: { 
                                    if (!checked) {
                                        renderer.command(["set", "mute", "no"])
                                    } else {
                                        renderer.command(["set", "mute", "yes"])
                                    }
                                }
                            }
                            
                            Slider {
                                id: volumeslider
                                tickmarksEnabled: false
                                value: 50
                                minimumValue: 0
                                maximumValue: 100
                                stepSize: 5
                                updateValueWhileDragging: true
                                opacity: 0.75
                                onValueChanged: renderer.command(["set", "volume", value.toString()])
                            }
                        }
                    }
                }

                // TODO: replace test text box with actual chat view
                //openChat();
                TextField {
                    id: chat
                    horizontalAlignment: TextInput.AlignHCenter
                    placeholderText: "Chat View coming to \nan app near you!"
                    // TODO: Get Read-Only Chat for 50%

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
                //closeChat();
            }
            //close();
        }
        
        Tab {
            id: profile
            title: "Profile"
            
            // Stretch Goal: Utilize our own view
            ScrollView {
                width: 1280
                height: 720
                WebView {
                    id: webview
                    //account:Account
                    //openWebView(Account);
                    
                    // TODO: Obtain URL from daemon
                    url: "http://www.twitch.tv/bobross/profile"
                    anchors.fill: parent
                    onNavigationRequested: {
                        // detect URL scheme prefix, most likely an external link
                        var schemaRE = /^\w+:/;
                        if (schemaRE.test(request.url)) {
                            request.action = WebView.AcceptRequest;
                        } else {
                            request.action = WebView.IgnoreRequest;
                            // delegate request.url here
                        }
                    }
                }
            }
        }

        // Twitch Branded Design
        style: TabViewStyle {
            frameOverlap: 1
            tabsAlignment: Qt.AlignHCenter
            tab: Rectangle {
                color: styleData.selected ? "#6441A5" :"#B9A3E3"
                border.color:  "#262626"
                implicitWidth: Math.max(text.width + 4, 80)
                implicitHeight: 25
                radius: 1
                
                gradient: Gradient {
                    GradientStop { position: 0 ; color: control.pressed ? "#6441A5" : "#B9A3E3" }
                    GradientStop { position: 1 ; color: control.pressed ? "#B9A3E3" : "#6441A5" }
                }
                
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
    
    // Initial Login View
    Rectangle {
        id: login
        color: "#6441A5"
        border.color: "#262626"
        border.width: 5
        width: window.width
        height: window.height
        visible: true
        
        Item {
            id: login_item
            
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
                id: user_rect
                x: (window.width / 2) - 200
                y: (window.height / 2) - 140
                TextField {
                    id: username //submitUrl
                    width: 400
                    horizontalAlignment: TextInput.AlignHCenter
                    inputMask: qsTr("")
                    placeholderText: qsTr("username")
                }
            }
            
            Rectangle {
                id: pass_rect
                x: (window.width / 2) - 200
                y: (window.height / 2) - 100
                TextField {
                    id: password
                    width: 400
                    horizontalAlignment: TextInput.AlignHCenter
                    inputMask: qsTr("")
                    placeholderText: qsTr("password")
                }
            }
        }
    }
    
    // Login/Logout button, TOP LAYER
    Item {
        id: logger

        Button {
            id: logbtn
            x: (window.width / 2)  - 50
            y: (window.height / 2) - 50
            scale: 1.0
            text: qsTr("Login")
            
            style: ButtonStyle {
                    background: Rectangle {
                        implicitWidth: 80
                        //implicitHeight: 25
                        border.width: control.activeFocus ? 2 : 1
                        border.color: "#000000"
                        radius: 1
                        
                        gradient: Gradient {
                            GradientStop { position: 0 ; color: control.pressed ? "#6441A5" : "#B9A3E3" }
                            GradientStop { position: 1 ; color: control.pressed ? "#B9A3E3" : "#6441A5" }
                        }
                    }
            }
            
            onClicked: {
                /*
                 **** Qt Creator bug, flags an error in Design View ****
                 **** Comment for Design                            ****
                */
                if (logbtn.text == "Login") {
                    // TODO: Call web view
                    //login();
                    logbtn.x = 0
                    logbtn.y = 0
                    logbtn.anchors.right = parent.right
                    logbtn.anchors.rightMargin = (window.width) * -1
                    login.visible = false
                    frame.visible = true
                    frame.tabsVisible = true
                    logbtn.text = qsTr("Logout")
                } else {
                    // TODO: End session
                    //logOut();
                    logbtn.anchors.right = undefined
                    logbtn.anchors.rightMargin = undefined
                    logbtn.x = (window.width / 2)  - 50
                    logbtn.y = (window.height / 2) - 50
                    login.visible = true
                    frame.currentIndex = 0
                    frame.visible = false
                    frame.tabsVisible = false
                    logbtn.text = qsTr("Login")
                }
            }
        }
    }
}
