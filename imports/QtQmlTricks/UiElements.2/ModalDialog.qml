import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

FocusScope {
    id: base;
    anchors.fill: parent;
    Component.onCompleted: { forceActiveFocus (); }

    property string title   : "";
    property var    message : "";

    property int buttons : (buttonOk | buttonCancel);

    readonly property int buttonOk     : (1 << 0);
    readonly property int buttonYes    : (1 << 1);
    readonly property int buttonNo     : (1 << 2);
    readonly property int buttonCancel : (1 << 3);
    readonly property int buttonAccept : (1 << 4);
    readonly property int buttonReject : (1 << 5);

    default property alias content : container.children;

    function hide () {
        base.destroy ();
    }

    function shake () {
        animShake.start ();
    }

    signal buttonClicked (int buttonType);

    MouseArea {
        id: blocker;
        hoverEnabled: Style.useHovering;
        anchors.fill: parent;
        onWheel: { }
        onPressed: { }
        onReleased: { }
    }
    Rectangle {
        id: dimmer;
        color: Style.colorForeground;
        opacity: 0.65;
        anchors.fill: parent;
    }
    Rectangle {
        id: frame;
        color: Style.colorSecondary;
        radius: Style.roundness;
        antialiasing: radius;
        border {
            width: Style.lineSize;
            color: Style.colorSelection;
        }
        anchors {
            fill: layout;
            margins: -Style.spacingBig;
        }
    }
    StretchColumnContainer {
        id: layout;
        spacing: Style.spacingBig;
        anchors.centerIn: parent;

        SequentialAnimation on anchors.horizontalCenterOffset {
            id: animShake;
            loops: 2;
            running: false;
            alwaysRunToEnd: true;

            PropertyAnimation {
                to: 30;
                duration: 40;
            }
            PropertyAnimation {
                to: -30;
                duration: 40;
            }
            PropertyAnimation {
                to: 0;
                duration: 40;
            }
        }
        TextLabel {
            id: lblTitle;
            text: base.title;
            font.pixelSize: Style.fontSizeTitle;
        }
        Line { }
        Stretcher {
            implicitHeight: lblMsg.contentHeight;
            implicitWidth: Math.max (Math.min (lblMsg.contentWidth, 600), 400);

            TextLabel {
                id: lblMsg;
                text: {
                    var ret = "";
                    if (base.message !== undefined) {
                        if (Array.isArray (base.message)) {
                            ret = base.message.join ("\n");
                        }
                        else {
                            ret = base.message.toString ();
                        }
                    }
                    return ret;
                }
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                horizontalAlignment: Text.AlignJustify;
                ExtraAnchors.horizontalFill: parent;
            }
        }
        Stretcher {
            visible: (container.children.length > 0);
            implicitWidth: Math.max (Math.min (container.implicitWidth, 600), 400);
            implicitHeight: container.implicitHeight;

            StretchColumnContainer {
                id: container;
                ExtraAnchors.topDock: parent;
            }
        }
        Line { }
        StretchRowContainer {
            id: row;
            spacing: Style.spacingNormal;

            Stretcher { }
            Repeater {
                model: [
                    { "type" : buttonCancel, "label" : qsTr ("Cancel"), "symbol" : Style.symbolCross },
                    { "type" : buttonNo,     "label" : qsTr ("No"),     "symbol" : Style.symbolCross },
                    { "type" : buttonReject, "label" : qsTr ("Reject"), "symbol" : Style.symbolCross },
                    { "type" : buttonAccept, "label" : qsTr ("Accept"), "symbol" : Style.symbolCheck },
                    { "type" : buttonYes,    "label" : qsTr ("Yes"),    "symbol" : Style.symbolCheck },
                    { "type" : buttonOk,     "label" : qsTr ("Ok"),     "symbol" : Style.symbolCheck },
                ];
                delegate: TextButton {
                    text: (modelData ["label"] || "");
                    icon: SymbolLoader {
                        size: Style.fontSizeNormal;
                        color: Style.colorForeground;
                        symbol: (modelData ["symbol"] || null);
                    }
                    visible: (buttons & (modelData ["type"] || 0));
                    onClicked: { base.buttonClicked (modelData ["type"] || 0); }
                }
            }
            Stretcher { }
        }
    }
}