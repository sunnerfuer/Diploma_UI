import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "theme" as Style
import "components"

ApplicationWindow {
    id: window
    width: 1440
    height: 900
    minimumWidth: 1280
    minimumHeight: 720
    visible: true
    title: "PostureFlow"
    color: Style.Theme.canvas

    function sourceForPage(page) {
        if (page === "live") return "pages/LiveMonitoringPage.qml"
        if (page === "statistics") return "pages/StatisticsPage.qml"
        if (page === "history") return "pages/HistoryPage.qml"
        if (page === "historyDetail") return "pages/HistoryDetailPage.qml"
        if (page === "settings") return "pages/SettingsPage.qml"
        return "pages/DashboardPage.qml"
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Sidebar {
            Layout.preferredWidth: Style.Theme.sidebarWidth
            Layout.fillHeight: true
            onNavigate: page => appState.navigate(page)
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.Theme.canvas

            Loader {
                id: pageLoader
                objectName: "pageLoader"
                anchors.fill: parent
                source: window.sourceForPage(appState.currentPage)
                asynchronous: false
            }
        }
    }

    Shortcut { sequence: "1"; enabled: appState.currentPage === "live"; onActivated: appState.setPostureState("good") }
    Shortcut { sequence: "2"; enabled: appState.currentPage === "live"; onActivated: appState.setPostureState("forward") }
    Shortcut { sequence: "3"; enabled: appState.currentPage === "live"; onActivated: appState.setPostureState("left") }
    Shortcut {
        sequence: "Space"
        enabled: appState.currentPage === "live"
        onActivated: {
            if (appState.currentPage === "live") {
                if (appState.monitoringState === "active") appState.pauseMonitoring()
                else if (appState.monitoringState === "paused") appState.resumeMonitoring()
                else appState.startMonitoring()
            }
        }
    }
}
