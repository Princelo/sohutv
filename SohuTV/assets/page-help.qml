import bb.cascades 1.0
import bb 1.0
Page {
    attachedObjects: [
        ApplicationInfo {
            id: ai
        }
    ]
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
            }
            Label {
                horizontalAlignment: HorizontalAlignment.Center
                text: ai.title
            }
            Header {
                title: qsTr("Author")
            }
            Label {
                text: qsTr("Merrick Zhang. You can contact me via <a href=\"mailto:anphorea@gmail.com\">Email</a>")
                multiline: true
                textFormat: TextFormat.Html
            }
        }
    }
}
