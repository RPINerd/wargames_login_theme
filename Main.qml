import QtQuick 2.8
import QtQuick.Controls 2.8
import QtQuick.Controls 1.4 as Q1
import QtQuick.Controls.Styles 1.4
import SddmComponents 2.0

import "."

Rectangle {
    id : container
    LayoutMirroring.enabled : Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit : true
    property int sessionIndex : session.index

    //SET DEFAULTS
    property int targetscreenwidth : container.width
    property int targetscreenheight : container.height

    property int defaultscreenwidth : 2560
    property int defaultscreenheight : 1600

    property int defaultcharwidth : 16
    property int defaultcharheight : 16

    property string doscolor : "#9effe9"
    property string dosblack : "#000000"


    //Background Settings
    property string borderimage : "Background.png"

    //BOTTOM PADDING (LOGIN, RESTART, SHUTDOWN)
    property int bottomCustomPadding : 75

    //TOP PADDING (WELCOME, FLAVOR TEXT)
    property int topCustomPadding : 100

    //FONT SECTION (1 px = .75 pt)
    property string fontstyle : "wartext.ttf"
    property int dosfontsize : 28

    TextConstants {
        id : textConstants
    }

    FontLoader {
        id : loginfont
        source : fontstyle
    }

    Connections {
        target : sddm
        onLoginSucceeded : {
            errorMessage.color = "green"
            errorMessage.text = textConstants.loginSucceeded
        }
        onLoginFailed : {
            password.text = ""
            errorMessage.color = "red"
            errorMessage.text = textConstants.loginFailed
            errorMessage.bold = true
        }
    }
    color : doscolor
    anchors.fill : parent

    Background {
        anchors.fill: parent
        source: borderimage
        fillMode: Image.Stretch
        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    //Welcome Message
    Column {
        id : welcomeMessage
        anchors.left : parent.left
        topPadding : topCustomPadding
        leftPadding : 150
        Text {
                color : doscolor
                text : "TRZ. 34/53/76\nACTIVE PORTS: 34,53,75,94\nALT MODE FUNCT: PV-8-AY345\n\n\n-:LOGON REQUIRED:-\n\n"
                visible : true
                font.family : loginfont.name
                font.italic : false
                font.pointSize : dosfontsize
        }
    }

    //Flavor Text
    Column {
        id : sysProc
        anchors.top : parent.top
        anchors.horizontalCenter : container.horizontalCenter
        topPadding : topCustomPadding

        Text {
            color : doscolor
            text : "SYS PROC 3435.45.6456\nSTANDBY MODE ACTIVE"
            visible : true
            font.family : loginfont.name
            font.italic : false
            font.pointSize : dosfontsize
        }
    }
    Column {
        id : compStatus
        anchors.right : parent.right
        topPadding : topCustomPadding
        rightPadding : 150

        Text {
            color : doscolor
            text : "XCOMP STATUS: PV-450\nCPU TM USED: 23:43"
            visible : true
            font.family : loginfont.name
            font.italic : false
            font.pointSize : dosfontsize
        }
    }
    Column {
        id : digitsList
        anchors.top : parent.top
        anchors.horizontalCenter : container.horizontalCenter
        topPadding : topCustomPadding + 4 * dosfontsize - 5
        leftPadding : 150
        rightPadding : 150

        Text {
            color : doscolor
            text : "#543.654    \t\t#989.283\t\t\t#028.392\t\t\t#099.293\t\t\t#934.905\t\t    #261.372"
            visible : true
            font.family : loginfont.name
            font.italic : false
            font.pointSize : dosfontsize
        }
    }

    //Username
    Column {
        id : userLabel
        anchors.left : parent.left
        anchors.verticalCenter : parent.verticalCenter
        bottomPadding : 300
        leftPadding : 150

        Text {
            color : doscolor
            text : "USERNAME:"
            visible : true
            font.family : loginfont.name
            font.italic : false
            font.pointSize : dosfontsize
            }
    }
    Column {
        id : userEntry
        anchors.left : parent.left
        anchors.verticalCenter : parent.verticalCenter
        bottomPadding : 300
        leftPadding : 280

        TextField {
            id : name
            font.family : loginfont.name
            font.italic : false
            width : 300
            height : 50
            text : userModel.lastUser
            font.pointSize : dosfontsize
            color : doscolor
            background : Image {
                source : ""
            }
            KeyNavigation.tab : password
            Keys.onPressed : {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    password.focus = true
                    event.accepted = true
                }
            }
        }
    }

    //Password Text
    Column {
        id : passwordLabel
        anchors.left : parent.left
        anchors.verticalCenter : parent.verticalCenter
        bottomPadding : 150
        leftPadding : 150

        Text {
            color : doscolor
            text : "PASSWORD:"
            visible : true
            font.family : loginfont.name
            font.italic : false
            font.pointSize : dosfontsize
        }
    }
    Column {
        id : passwordEntry
        anchors.left : parent.left
        anchors.verticalCenter : parent.verticalCenter
        bottomPadding : 145
        leftPadding : 280

        TextField {
            id : password
            font.family : loginfont.name
            font.italic : false
            width : 400
            height : 50
            echoMode : TextInput.Password
            font.pointSize : 16
            color : doscolor
            background : Image {
                source : ""
            }
            KeyNavigation.backtab : name
            KeyNavigation.tab : loginButton
            focus : true
            Keys.onPressed : {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    sddm.login(name.text, password.text, sessionIndex)
                    event.accepted = true
                }
            }
        }
    }

    //Login Button
    Column {
        id : loginColumn
        anchors.left : parent.left
        anchors.bottom : parent.bottom
        bottomPadding : bottomCustomPadding
        leftPadding : 150

        Image {
            id : loginButton
            source : ""
            width : 100
            height : 50
            visible : true

            MouseArea {
                hoverEnabled : true

                onEntered : {
                    parent.source = ""
                }
                onExited : {
                    parent.source = ""
                }
                onPressed : {
                    parent.source = ""
                    sddm.login(name.text, password.text, sessionIndex)
                }
                onReleased : {
                    parent.source = ""
                }
            }

            Text {
                text : "LOGIN"
                font.family : loginfont.name
                font.italic : false
                font.pointSize : dosfontsize
                color: doscolor
            }

            KeyNavigation.backtab : password
            KeyNavigation.tab : restartButton
        }
    }

    //Restart Button
    Column {
        id : restartColumn
        anchors.left : parent.left
        anchors.bottom : parent.bottom
        bottomPadding : bottomCustomPadding
        leftPadding : 300

        Image {
            id : restartButton
            source : ""
            width : 100
            height : 50
            visible : true

            MouseArea {
                hoverEnabled : true

                onEntered : {
                    parent.source = "None.svg"
                }
                onExited : {
                    parent.source = "None.svg"
                }
                onPressed : {
                    parent.source = "None.svg"
                    sddm.login(name.text, password.text, sessionIndex)
                }
                onReleased : {
                    parent.source = "None.svg"
                }
            }

            Text {
                text : "RESTART"
                font.family : loginfont.name
                font.italic : false
                font.pointSize : dosfontsize
                color: doscolor
            }

            KeyNavigation.backtab : password
            KeyNavigation.tab : shutdownButton
        }
    }

    //Shutdown Button
    Column {
        id : shutdownColumn
        anchors.left : parent.left
        anchors.bottom : parent.bottom
        bottomPadding : bottomCustomPadding
        leftPadding : 500

        Image {
            id : shutdownButton
            source : ""
            width : 100
            height : 50
            visible : true

            MouseArea {
                hoverEnabled : true

                onEntered : {
                    parent.source = "None.svg"
                }
                onExited : {
                    parent.source = "None.svg"
                }
                onPressed : {
                    parent.source = "None.svg"
                    sddm.login(name.text, password.text, sessionIndex)
                }
                onReleased : {
                    parent.source = "None.svg"
                }
            }

            Text {
                text : "HALT"
                font.family : loginfont.name
                font.italic : false
                font.pointSize : dosfontsize
                color: doscolor
            }

            KeyNavigation.backtab : password
            KeyNavigation.tab : loginButton
        }
    }

    //Session Selection
    Column {
        id : sessionColumn
        anchors.right : parent.right
        anchors.bottom : parent.bottom
        bottomPadding : bottomCustomPadding
        rightPadding : 150

        ComboBox {
            id : session
            color : dosblack
            borderColor : dosblack
            hoverColor : dosblack
            focusColor : dosblack
            textColor : doscolor
            menuColor : dosblack
            arrowColor: "transparent"
            width : 250
            height : 50
            visible : true
            font.pointSize : dosfontsize
            font.italic : false
            font.family : loginfont.name
            arrowIcon : ""
            model : sessionModel
            index : sessionModel.lastIndex
            KeyNavigation.backtab : shutdownButton
            KeyNavigation.tab : loginButton
        }
    }

}
