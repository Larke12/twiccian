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
import QtWebEngine 1.1

import twiccian 1.0

ApplicationWindow {
	id: window
	width: 800
	height: 600
	visible: true
	title: "Twiccian | Row row, fight the powa!" // result.getTitle();

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
				Item {
					id: mpv
					Layout.maximumHeight: window.height
					height: 400
                    Layout.maximumWidth: window.width * 0.8
                    Layout.minimumWidth: window.width * 0.75
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            vcontrols.opacity = 1.0
                        }
                        onExited: {
                            vcontrols.opacity = 0.0
                        }
                        
                        MpvObject {
                            id: renderer
                            anchors.fill: parent
                            
                            // Player controls
                            Row {
                                id: vcontrols
                                // Anchor controls to bottom center of player
                                anchors.centerIn: parent
                                anchors.verticalCenterOffset: (parent.height / 2) - (window.width / 15)
                                opacity: 0.0
                                
                                spacing: 15 
                                
                                Button {
                                    id: playpause
                                    text: qsTr("Pause")
                                    opacity: 1.0
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
                                    opacity: 1.0
                                    onClicked: {
                                        apiobj.requestUrl("http://www.twitch.tv/twitchplayspokemon")
                                        renderer.command(["set", "pause", "no"])
                                        renderer.command(["loadfile", apiobj.getUrl()]) // API OBJ
                                        playpause.text = qsTr("Pause")
                                    }
                                }
                                
                                CheckBox {
                                    id: mute
                                    opacity: 1.0
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
                                    opacity: 1.0
                                    onValueChanged: renderer.command(["set", "volume", value.toString()])
                                }
                            }
                        }
                    }
                }

                WebEngineView {
                    id: chat
                    url: "assets/sock.html"
                }
                //closeChat();
            }
            //close();
        }
        
        Tab {
            id: profile
            title: "Settings"
            
            // Stretch Goal: Utilize our own view
            ScrollView {
                width: 1280
                height: 720
                WebView {
                    id: webview
                    //account:Account
                    //openWebView(Account);
                    
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
        Component.onCompleted: {
            if (apiobj.isAuthenticated() === true) {
                login.visible = false
                frame.visible = true
                frame.tabsVisible = true
            }
        }

        // Login WebView
        WebView {
            id: logwebview

            url: "https://api.twitch.tv/kraken/oauth2/authorize?response_type=token&client_id=mya9g4l7ucpsbwe2sjlj749d4hqzvvj&redirect_uri=http://localhost:19210&scope=user_read+user_follows_edit+user_subscriptions+chat_login"
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
