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
import Qt.labs.settings 1.0
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
    title: "Twiccian"

    /*
      This section is for API calls between QML and C++
      */
    Api {
        id: apiobj
        objectName: "apiobj"
    }
    
    // Logic boolean for stream
    Item {
        id: updateStream
        opacity: 0.0
        visible: false
    }

    Item {
        id: isLight
        opacity: 0.0
        visible: apiobj.isLightTheme();
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
                    property bool selected: false

                    Button {
                        id: followingrefresh
                        anchors.top: parent.top
                        anchors.topMargin: 10
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        
                        text: qsTr("Refresh")
                        opacity: 1.0

                        onClicked: {
                            follows.selected = false
                            apiobj.requestFollowing();
                        }
                    }

                    Column {
                        // Avoid overlapping
                        id: cols
                        spacing: 5
                        x: (window.width / 4.5)
                        y: cols.spacing

                        ListView {
                            id: list
                            clip: true
                            width: window.width; height: window.height
                            spacing: 20

                            footer: Rectangle {
                                height: 100
                                color: "transparent"
                            }

                            model: myModel
                            delegate: Rectangle {
                                id: listrect
                                height: 100
                                border.color: "#000000"
                                border.width: 2
                                radius: 3
                                width: parent.width * 0.75
                                color: (ListView.isCurrentItem && follows.selected) ? "#B9A3E3" : "#FFFFFF"
                                
                                Image {
                                    id: thumb
                                    anchors.top: parent.top
                                    anchors.topMargin: listrect.border.width
                                    anchors.left: parent.left
                                    anchors.leftMargin: listrect.border.width
                                    sourceSize.height: parent.height - (listrect.border.width * 2)
                                    source: thumbnailUrl
                                }
                                
                                Column {
                                    id: streamInfo
                                    //x: parent.x + 180
                                    anchors.top: parent.top
                                    anchors.topMargin: listrect.border.width
                                    anchors.left: parent.left
                                    anchors.leftMargin: thumb.width + (listrect.border.width * 2)
                                    
                                    spacing: 2
                                    
                                    Text {
                                        text: title
                                        width: window.width * 0.75 - 180
                                        font.bold: true
                                        wrapMode: Text.Wrap
                                    }
                                    
                                    Text {
                                        text: "Now Playing " + game
                                        width: window.width * 0.75 - 180
                                        font.bold: false
                                        wrapMode: Text.Wrap
                                    }
                                    
                                    Text {
                                        text: streamer.getName() + " with " + viewerCount + (viewerCount == 1 ?  " viewer" : " viewers")
                                        width: window.width * 0.75 - 180
                                        font.bold: false
                                        wrapMode: Text.Wrap
                                    }
                                }
                                
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        follows.selected = true
                                        list.currentIndex = -1
                                        list.currentIndex = index
                                    }
                                }
                            }

                            onCurrentIndexChanged: {
                                if (list.currentIndex != -1 && follows.selected) {
                                    updateStream.visible = true
                                    window.title = apiobj.getResults()[list.currentIndex].getTitle() + " -  Twiccian"
                                    apiobj.setStreamer(list.currentIndex)
                                    console.log("http://www.twitch.tv/"+apiobj.getStreamer().getName())
                                    apiobj.changeChat(apiobj.getStreamer().getName())
                                    apiobj.requestUrl("http://www.twitch.tv/"+apiobj.getStreamer().getName())
                                    frame.currentIndex = 2
                                }
                            }
                        }
                    }
                }
            }
        }

        Tab {
            id: search
            title: "Search"

            ScrollView {
                frameVisible: true
                verticalScrollBarPolicy: Qt.ScrollBarAsNeeded
                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

                Item {
                    id: searchs
                    property bool selected: false

                    TextField {
                       id: searchQuery
                       anchors.top: parent.top
                       anchors.topMargin: 10
                       anchors.left: parent.left
                       anchors.leftMargin: 10
                       placeholderText: "Username or query"
                    }

                    Button {
                        id: searchSubmit
                        anchors.top: searchQuery.bottom
                        anchors.topMargin: 10
                        anchors.left: searchQuery.left

                        text: qsTr("Search")
                        opacity: 1.0

                        onClicked: {
                            searchs.selected = false
                            apiobj.requestStreamSearch(searchQuery.text)
                        }
                    }

                    Column {
                        // Avoid overlapping
                        id: searchcols
                        spacing: 5
                        x: (window.width / 4.5)
                        y: searchcols.spacing

                        ListView {
                            id: searchlist
                            clip: true
                            width: window.width; height: window.height
                            spacing: 20

                            footer: Rectangle {
                                height: 100
                                color: "transparent"
                            }

                            model: searchModel
                            delegate: Rectangle {
                                id: searchlistrect
                                height: 100
                                border.color: "#000000"
                                border.width: 2
                                radius: 3
                                width: parent.width * 0.75
                                color: (ListView.isCurrentItem && searchs.selected) ? "#B9A3E3" : "#FFFFFF"

                                Image {
                                    id: searchthumb
                                    anchors.top: parent.top
                                    anchors.topMargin: searchlistrect.border.width
                                    anchors.left: parent.left
                                    anchors.leftMargin: searchlistrect.border.width
                                    sourceSize.height: parent.height - (searchlistrect.border.width * 2)
                                    source: thumbnailUrl
                                }

                                Column {
                                    id: searchStreamInfo
                                    //x: parent.x + 180
                                    anchors.top: parent.top
                                    anchors.topMargin: searchlistrect.border.width
                                    anchors.left: parent.left
                                    anchors.leftMargin: searchthumb.width + (searchlistrect.border.width * 2)

                                    spacing: 2

                                    Text {
                                        text: title
                                        width: window.width * 0.75 - 180
                                        font.bold: true
                                        wrapMode: Text.Wrap
                                    }

                                    Text {
                                        text: "Now Playing " + game
                                        width: window.width * 0.75 - 180
                                        font.bold: false
                                        wrapMode: Text.Wrap
                                    }

                                    Text {
                                        text: streamer.getName() + " with " + viewerCount + (viewerCount == 1 ?  " viewer" : " viewers")
                                        width: window.width * 0.75 - 180
                                        font.bold: false
                                        wrapMode: Text.Wrap
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        searchs.selected = true
                                        searchlist.currentIndex = -1
                                        searchlist.currentIndex = index
                                    }
                                }
                            }

                            onCurrentIndexChanged: {
                                if (searchlist.currentIndex != -1 && searchs.selected) {
                                    updateStream.visible = true
                                    window.title = apiobj.getSearches()[searchlist.currentIndex].getTitle() + " -  Twiccian"
                                    apiobj.setStreamerSearch(searchlist.currentIndex)
                                    console.log("http://www.twitch.tv/"+apiobj.getStreamer().getName())
                                    apiobj.changeChat(apiobj.getStreamer().getName())
                                    apiobj.requestUrl("http://www.twitch.tv/"+apiobj.getStreamer().getName())
                                    frame.currentIndex = 2
                                }
                            }
                        }
                    }
                }
            }
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
                    height: window.height
                    Layout.minimumHeight: window.height - 400
					Layout.maximumHeight: window.height
                    Layout.minimumWidth: window.width - 400
                    Layout.maximumWidth: window.width
                    Layout.fillWidth: true
                    
                    MouseArea {
                        id: mpvMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        
                        onEntered: {
                            if (proview.visible) {
                                propic.opacity = 0.7
                                prodrop.opacity = 0.7
                                
                                vcontrols.opacity = 0.0
                                gradientItem.visible = false
                            } else {
                                propic.opacity = 1.0
                                prodrop.opacity = 1.0
                                
                                vcontrols.opacity = 1.0
                                gradientItem.visible = true
                            }
                        }
                        
                        onExited: {
                            vcontrols.opacity = 0.0
                            gradientItem.visible = false
                            propic.opacity = 0.0
                            prodrop.opacity = 0.0
                        }
                        
                        MpvObject {
                            id: renderer
                            anchors.fill: parent

                            onVisibleChanged: {
                                if (frame.currentIndex == 2 && updateStream.visible == true) {
                                    if (apiobj.getUrl() !== "") {
                                        renderer.command(["stop"])
                                        renderer.command(["loadfile", apiobj.getUrl()])
                                    }
                                }
                            }

                            // Stretch Goal: Utilize our own view
                            ScrollView {
                                id: proview
                                width: renderer.width
                                height: renderer.height
                                visible: false
                                
                                WebView {
                                    id: webview
                                    
                                    /*url: {
                                        if (updateStream.visible == true) {
                                            apiobj.getStreamer().getProfileUrl()
                                            console.log(apiobj.getStreamer().getProfileUrl())
                                        }
                                    }*/
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
                                width: 150
                                height: propic.width
                                anchors.top: parent.top
                                anchors.topMargin: propic.height / 4
                                anchors.left: parent.left
                                anchors.leftMargin: propic.width / 4
                                opacity: 0.0
                                
                                // Load profile image
                                Image {
                                    id: avatar
                                    width: propic.width
                                    height: propic.height
                                    //fillMode: Image.PreserveAspectFit
                                    // Source is set at time of chat loading
                                }
                                
                                
                                // Click to view profile in webview
                                MouseArea {
                                    anchors.fill: parent
                                    
                                    onClicked: {
                                        if (!proview.visible) {
                                            proview.visible = true
                                            propic.opacity = 0.6
                                            vcontrols.visible = false
                                            gradientItem.visible = false
                                        } else {
                                            proview.visible = false
                                            propic.opacity = 1.0
                                            vcontrols.visible = true
                                            gradientItem.visible = true
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
                                color: "#000000"
                                opacity: 0.0
                                source: propic
                            }
                            
                            Item {
                                id: gradientItem
                                width: parent.width
                                height: vcontrols.height * 4
                                // Anchor gradient to bottom of player
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: -vcontrols.height
                                visible: false
                                
                                LinearGradient {
                                    id: gradientArt
                                    anchors.fill: parent
                                    
                                    //cached: true
                                    
                                    start: Qt.point(0, 0)
                                    end: Qt.point(0, 60)
                                    
                                    gradient: Gradient {
                                        GradientStop { position: 0.0; color: "#00000000" }
                                        GradientStop { position: 1.0; color: "#FF000000" }
                                    }
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
                                            frame.tabsVisible = false
                                            splitview.orientation = Qt.Vertical
                                            renderer.width = window.width
                                        } else {
                                            renderer.command(["set", "fullscreen", "no"])
                                            splitview.orientation = Qt.Horizontal
                                            frame.tabsVisible = true
                                            window.showNormal()
                                            chat.width = 300
                                            renderer.width = window.width - chat.width
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
                    width: 300
                    
                    url: {
                        if (isLight.visible == false) {
                            "assets/sock.html"
                        } else {
                            "assets/sock_light.html"
                        }
                    }
                    onVisibleChanged: {
                        if (frame.currentIndex == 2 && updateStream.visible == true) {
                            chat.reload()
                            updateStream.visible = false

                            webview.url = apiobj.getStreamer().getProfileUrlAsUrl() + "/profile"
                            avatar.source = apiobj.getStreamer().getAvatarUrl()
                            //console.log(apiobj.getStreamer().getAvatarUrl())
                        }
                    }

                }
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
                    
                    CheckBox {
                        id: theme
                        opacity: 1.0
                        
                        style: CheckBoxStyle {
                                label: Text {
                                    color: "#FFFFFF"
                                    text: "Light Theme"
                                }
                        }
                        
                        checked: false

                        Settings {
                            id: themeSettings
                            property alias checked: theme.checked
                        }
                        
                        onClicked: {
                            if (!checked) {
                                // set theme to black
                               isLight.visible = false
                            } else {
                                // set theme to white
                               isLight.visible = true
                            }
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
					color: styleData.selected ? "#FFFFFF" : "#000000"
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
            if (apiobj.isAuthenticated() === false) {
                // Load stream view
                frame.currentIndex = 2
                login.visible = true
                frame.visible = false
                frame.tabsVisible = false
                // Load following view
                //frame.currentIndex = 0
            } else {
                frame.currentIndex = 2
                login.visible = false
                frame.visible = true
                frame.tabsVisible = true
                //frame.currentIndex = 0
            }
        }

        // Login WebView
        WebView {
            id: logwebview

            url: "https://api.twitch.tv/kraken/oauth2/authorize?response_type=token&client_id=mya9g4l7ucpsbwe2sjlj749d4hqzvvj&redirect_uri=http://localhost:19210&scope=user_read+user_follows_edit+user_subscriptions+chat_login"
            anchors.fill: parent

            onUrlChanged: {
                var schemaRE = /localhost:/;
                if (schemaRE.test(url)) {
                    login.visible = false
                    logwebview.visible = true
                    frame.visible = true
                    frame.tabsVisible = true
                }
            }

            onNavigationRequested: {
                // detect URL scheme prefix, most likely an external link
                var schemaRE = /^\w+:/;
                if (schemaRE.test(request.url)) {
                    request.action = WebView.AcceptRequest;
                } else {
                    request.action = WebView.IgnoreRequest;
                }
            }
        }
    }
}
