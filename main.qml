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
import QtGraphicalEffects 1.0
import QtWebKit 3.0
import QtWebEngine 1.1

import twiccian 1.0

ApplicationWindow {
	id: window
    width: 1000
    height: 650
	visible: true
    color: "#FF000000"
	title: "Twiccian | result.getTitle()" // result.getTitle();

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
            
            ScrollView {
                frameVisible: true
                verticalScrollBarPolicy: Qt.ScrollBarAsNeeded
                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                
                Item {
                    id: follows

                    Column {
                        // Avoid overlapping
                        id: cols
                        spacing: 5
                        x: (window.width / 4)
                        y: cols.spacing
                        
                        Repeater {
                            // Define number of results
                            id: datarep
                            model: 10
                            
                            delegate: Rectangle {
                                width: (window.width) / 2
                                height: 80
                                color: "white"
                                border { 
                                    width: 1 
                                    color: "black" }
                                radius: 3
                
                                Text {
                                    id: follow_temp
                                    anchors.fill: parent
                                    horizontalAlignment: TextInput.AlignHCenter
                                    verticalAlignment: TextInput.AlignVCenter
                                    text: qsTr("This view will list all of the streams\nyou follow that are live")
                                }
                            }
                        }
                    }
                }
            }

            //results:Result[]
            //queryLive();
            //queryRecent();
        }

        Tab {
            id: stream
            title: "Stream"
            
            // A Qt view which contains the mpv window and chat
            SplitView {
                id: splitview
                resizing: false
                anchors.fill: parent
                orientation: Qt.Horizontal

				// Use default Item container for the MpvObject
				Item {
					id: mpv
					Layout.maximumHeight: window.height
					height: window.height
                    //width: window.width * 0.75
                    Layout.minimumWidth: window.width - 400
                    Layout.minimumHeight: window.height - 400
                    Layout.fillWidth: true
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        
                        onEntered: {
                            vcontrols.opacity = 1.0
                            if (proview.visible) {
                                propic.opacity = 0.7
                                prodrop.opacity = 0.7
                            } else {
                                propic.opacity = 1.0
                                prodrop.opacity = 1.0
                            }
                        }
                        
                        onExited: {
                            vcontrols.opacity = 0.0
                            propic.opacity = 0.0
                            prodrop.opacity = 0.0
                        }
                        
                        MpvObject {
                            id: renderer
                            anchors.fill: parent
                            
                            // Stretch Goal: Utilize our own view
                            ScrollView {
                                id: proview
                                width: renderer.width
                                height: renderer.height
                                visible: false
                                
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
                            
                            // Streamer Profile Photo
                            Rectangle {
                                id: propic
                                width: renderer.width / 6
                                height: propic.width
                                anchors.top: parent.top
                                anchors.topMargin: propic.height / 4
                                anchors.left: parent.left
                                anchors.leftMargin: propic.width / 4
                                opacity: 0.0
                                
                                // Load image
                                
                                // Click to view profile in webview
                                MouseArea {
                                    anchors.fill: parent
                                    
                                    onClicked: {
                                        if (!proview.visible) {
                                            proview.visible = true
                                            propic.opacity = 0.7
                                            vcontrols.visible = false
                                        } else {
                                            proview.visible = false
                                            propic.opacity = 1.0
                                            vcontrols.visible = true
                                            webview.stop();
                                        }
                                    }
                                }
                            }
                            
                            DropShadow {
                                id: prodrop
                                anchors.fill: propic
                                horizontalOffset: 4
                                verticalOffset: 4
                                radius: 8.0
                                samples: 16
                                color: "black"
                                opacity: 0.0
                                source: propic
                            }
                            
                            
                            LinearGradient {
                                // Anchor gradient to bottom of player
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: vcontrols.height
                                anchors.left: parent.left
                                anchors.leftMargin: (parent.width / 2) - (vcontrols.width / 2)
                                
                                start: Qt.point(0, 0)
                                end: Qt.point(0, vcontrols.height)
                                
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0) }
                                    GradientStop { position: 1.0; color: "black" }
                                }
                            }
                            
                            // Player controls
                            Row {
                                id: vcontrols
                                // Anchor controls to bottom center of player
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: vcontrols.height
                                anchors.left: parent.left
                                anchors.leftMargin: (parent.width / 2) - (vcontrols.width / 2)
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
                                        apiobj.requestUrl("http://www.twitch.tv/firedragon764")
                                        renderer.command(["set", "pause", "no"])
                                        renderer.command(["loadfile", apiobj.getUrl()]) // API OBJ
                                        playpause.text = qsTr("Pause")
                                    }
                                }
                                
                                CheckBox {
                                    id: fscreen
                                    opacity: 1.0
                                    
                                    style: CheckBoxStyle {
                                        label: Text {
                                            color: "#FFFFFF"
                                            text: "Fullscreen"
                                        }
                                    }
                                    
                                    checked: false
                                    
                                    onClicked: {
                                        if (checked) {
                                            renderer.command(["set", "fullscreen", "yes"])
                                            window.showFullScreen()
                                            splitview.orientation = Qt.Vertical
                                            //renderer.height = window.height
                                            renderer.width = window.width
                                            chat.height = -1
                                            //chat.width = Screen.desktopAvailableWidth
                                        } else {
                                            renderer.command(["set", "fullscreen", "no"])
                                            window.showNormal()
                                            splitview.orientation = Qt.Horizontal
                                            chat.width = 400
                                        }
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
                    width: 400
                    Layout.minimumWidth: 400
                    //Layout.maximumHeight: window.height
                    //Layout.maximumWidth: window.width * 0.2
                    //Layout.minimumWidth: window.width * 0.25
                    
                    url: "assets/sock.html"
                }
                //closeChat();
            }
            //close();
        }
        
        Tab {
            id: profile
            title: "Settings"
            
            Item {
                width: 310; height: 170
            
                Column {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    
                    spacing: 5
                    
                    
                    Row {
                        id: winwidth
                        
                        Text {
                            text: "Default Width: "
                            color: "#FFFFFF"
                        }
                        
                        TextInput {
                            id: reswinwidth
                            text: window.width
                            color: "#FFFFFF"
                            cursorVisible: false
                        }
                    }
                    
                    Row {
                        id: winheight
                        
                        Text {
                            text: "Default Height: "
                            color: "#FFFFFF"
                        }
                        
                        TextInput {
                            id: reswinheight
                            text: window.height
                            color: "#FFFFFF"
                            cursorVisible: false
                        }
                    }

                    CheckBox {
                        id: theme
                        opacity: 1.0
                        
                        style: CheckBoxStyle {
                                label: Text {
                                    color: "#FFFFFF"
                                    text: "Light Theme (coming soon)"
                                }
                        }
                        
                        checked: false
                        
                        /*onClicked: { 
                            if (!checked) {
                                // set theme to black
                            } else {
                                // set theme to white
                            }
                        }*/
                    }
                    
                    CheckBox {
                        id: resconfig
                        opacity: 1.0
                        
                        style: CheckBoxStyle {
                                label: Text {
                                    color: "#FFFFFF"
                                    text: "Logout (coming soon)"
                                }
                        }
                        
                        checked: false
                        
                        onClicked: { 
                            if (checked) {
                                // delete local config file (?)
                                // uncheck
                            }
                        }
                    }
                    
                    
                    // BTT toggle
                    
                    // FFZ toggle
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
