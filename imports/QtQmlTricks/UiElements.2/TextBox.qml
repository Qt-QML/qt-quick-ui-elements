import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

FocusScope {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    implicitWidth: (input.contentWidth + padding * 2);
    implicitHeight: (input.contentHeight + padding * 2);

    property int   padding    : Style.spacingNormal;
    property bool  isPassword : false;
    property alias readOnly   : input.readOnly;
    property alias text       : input.text;
    property alias textFont   : input.font;
    property alias textColor  : input.color;
    property alias textAlign  : input.horizontalAlignment;
    property alias textHolder : holder.text;
    property alias inputMask  : input.inputMask;
    property alias validator  : input.validator;
    property alias acceptable : input.acceptableInput;
    property alias rounding   : rect.radius;

    signal accepted ();

    function selectAll () {
        input.selectAll ();
    }

    function clear () {
        input.text = "";
    }

    Rectangle {
        id: rect;
        radius: Style.roundness;
        enabled: base.enabled;
        visible: !readOnly;
        antialiasing: radius;
        gradient: (enabled ? Style.gradientEditable () : Style.gradientDisabled ());
        border {
            width: Style.lineSize;
            color: (input.activeFocus ? Style.colorSteelBlue : Style.colorGray);
        }
        anchors.fill: parent;
    }
    Item {
        clip: (input.contentWidth > input.width);
        enabled: base.enabled;
        anchors {
            fill: rect;
            margins: rect.border.width;
        }

        TextInput {
            id: input;
            focus: true;
            color: (enabled ? Style.colorBlack : Style.colorGray);
            enabled: base.enabled;
            selectByMouse: true;
            selectionColor: Style.colorSteelBlue;
            selectedTextColor: Style.colorWhite;
            activeFocusOnPress: true;
            echoMode: (isPassword ? TextInput.Password : TextInput.Normal);
            font {
                family: Style.fontName;
                weight: Font.Light;
                pixelSize: Style.fontSizeNormal;
            }
            anchors {
                left: parent.left;
                right: parent.right;
                margins: padding;
                verticalCenter: parent.verticalCenter;
            }
            onAccepted: { base.accepted (); }
        }
    }
    TextLabel {
        id: holder;
        font: input.font;
        color: Style.colorGray;
        enabled: base.enabled;
        visible: (!input.activeFocus && input.text.trim ().length === 0 && !readOnly);
        horizontalAlignment: input.horizontalAlignment;
        anchors {
            left: parent.left;
            right: parent.right;
            margins: padding;
            verticalCenter: parent.verticalCenter;
        }
    }
}