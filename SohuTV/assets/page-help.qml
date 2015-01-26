import bb.cascades 1.0
import bb 1.0
Page {
    attachedObjects: [
        ApplicationInfo {
            id: ai
        }
    ]
    property string email: qsTr("Email")
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Default
    ScrollView {
        horizontalAlignment: HorizontalAlignment.Fill
        Container {
            Header {
                title: qsTr("About")
                subtitle: qsTr("Ver:") + ai.version
            }
            ImageView {
                imageSource: "asset:///img/sohu.amd"
                horizontalAlignment: HorizontalAlignment.Center
                topMargin: 50.0
            }
            Label {
                horizontalAlignment: HorizontalAlignment.Center
                text: ai.title
            }
            Header {
                title: qsTr("Author List")
            }
            Container {
                horizontalAlignment: HorizontalAlignment.Fill
                leftPadding: 20.0
                rightPadding: 20.0
                topPadding: 20.0
                Label {
                    text: qsTr("Merrick Zhang, Programmer.") + "<a href=\"mailto:anphorea@gmail.com?subject=[SOHUTV]" + ai.version + "\">" + email + "</a>"
                    multiline: true
                    textFormat: TextFormat.Html
                }
            }
        }
    }
}
