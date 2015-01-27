import bb.cascades 1.0

Container {
    property string title
    property string url
    property int id
    signal Trigger
    signal Remove
    preferredHeight: 50
    minHeight: 50
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight

    }
    Container {
        gestureHandlers: TapHandler {
            onTapped: {
                Trigger()
            }
        }
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Left
        layoutProperties: StackLayoutProperties {
            spaceQuota: 5.0

        }
        Label {
            text: title
            textStyle.fontSize: FontSize.Large
        }
        Label {
            text: url
            textStyle.fontSize: FontSize.XSmall
        }
    }
    Container {
        horizontalAlignment: HorizontalAlignment.Right
        verticalAlignment: VerticalAlignment.Center
        ImageView {
            imageSource: "asset:///img/ic_delete.png"
            loadEffect: ImageViewLoadEffect.None
            scalingMethod: ScalingMethod.AspectFit
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            gestureHandlers: TapHandler {
                onTapped: {
                    Remove()
                }
            }
        }
    }

}
