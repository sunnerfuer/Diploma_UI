pragma Singleton
import QtQuick

QtObject {
    // Foundations from approved design specification
    readonly property color canvas: "#F7F5F0"
    readonly property color surface: "#FFFFFF"
    readonly property color surfaceSubtle: "#F0EEE9"
    readonly property color sidebar: "#1B1B24"
    readonly property color sidebarSoft: "#282832"
    readonly property color textPrimary: "#202027"
    readonly property color textSecondary: "#777681"
    readonly property color textMuted: "#A09EA7"
    readonly property color border: "#E8E5DE"
    readonly property color grid: "#ECEAE5"

    readonly property color lilac: "#C9B6F4"
    readonly property color lilacSoft: "#EEE8FC"
    readonly property color lime: "#D6EF83"
    readonly property color limeSoft: "#EFF7D7"
    readonly property color peach: "#F3B59C"
    readonly property color peachSoft: "#FBE7DD"
    readonly property color pink: "#EFB6CF"
    readonly property color pinkSoft: "#FAE7EF"

    readonly property color good: "#CFEA7A"
    readonly property color goodSoft: "#EFF7D7"
    readonly property color forward: "#F1AE91"
    readonly property color forwardSoft: "#FBE6DC"
    readonly property color left: "#C9B6F4"
    readonly property color leftSoft: "#EEE8FC"

    readonly property string fontFamily: appFontFamily
    readonly property color brandAccent: [lilac, lime, peach][appState.preferences.accentIndex]
    readonly property color brandSoft: [lilacSoft, limeSoft, peachSoft][appState.preferences.accentIndex]
    readonly property color positiveText: "#4C9029"
    readonly property color chartLine: "#78B82A"
    readonly property color overlay: "#DD292825"
    readonly property int pageTitle: 30
    readonly property int heroNumber: 40
    readonly property int postureState: 26
    readonly property int sectionTitle: 18
    readonly property int cardTitle: 14
    readonly property int body: 14
    readonly property int secondary: 13
    readonly property int micro: 11

    readonly property int sidebarWidth: 224
    readonly property int pagePadding: appState.preferences.densityIndex === 1 ? 22 : 28
    readonly property int gap: 18
    readonly property int largeRadius: 22
    readonly property int cardRadius: 18
    readonly property int controlRadius: 13

    readonly property int borderWidth: 1
    readonly property color shadowColor: "#140F1020"
    readonly property real shadowBlur: 0.28
    readonly property int shadowYOffset: 4

    function postureColor(key) {
        if (key === "forward") return forward
        if (key === "left") return left
        return good
    }
    function postureSoftColor(key) {
        if (key === "forward") return forwardSoft
        if (key === "left") return leftSoft
        return goodSoft
    }
}
