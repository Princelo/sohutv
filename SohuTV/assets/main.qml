/*
 * Copyright (c) 2011-2014 BlackBerry Limited.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.0
import bb.system 1.0

NavigationPane {
    id: navpane
    property bool lockedlandscape: false
    property bool actionbarhidden: false
    Menu.definition: MenuDefinition {
        helpAction: HelpActionItem {
            onTriggered: {
                var help = Qt.createComponent("page-help.qml").createObject(navpane)
                navpane.push(help);
            }
        }
        settingsAction: SettingsActionItem {
            onTriggered: {
                var settings = Qt.createComponent("page-settings.qml").createObject(navpane);
                navpane.push(settings);
            }
        }
    }
    onPopTransitionEnded: {
        page.destroy()
    }
    attachedObjects: [
        Storage {
            id: bookmark
            onDatachanged: {
                console.log(serialize())
                _app.setValue("bookmark", serialize());
            }
            onCreationCompleted: {
                load(_app.getValue("bookmark", ""));
            }
        }
    ]
    onCreationCompleted: {
        webv.loadingChanged.connect(syncbookmark)
    }
    function syncbookmark() {
        if (bookmark.exists(webv.url)) {
            actionbookmark.imageSource = "asset:///img/star3.png";
        } else {
            actionbookmark.imageSource = "asset:///img/star1.png";
        }
    }
    Page {
        id: rootpage
        actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
        ScrollView {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            scrollViewProperties.overScrollEffectMode: OverScrollEffectMode.None
            WebView {
                id: webv
                preferredHeight: Infinity
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                settings.credentialAutoFillEnabled: true
                settings.formAutoFillEnabled: true
                url: "http://m.tv.sohu.com"
                settings.userAgent: "Mozilla/5.0 (Linux; Android 4.1.1; Nexus 7 Build/JRO03S) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Safari/535.19"
//                settings.userAgent: "Mozilla/5.0 (Linux; U; Android 3.0; en-us; Xoom Build/HRI39) AppleWebKit/534.13 (KHTML, like Gecko) Version/4.0 Safari/534.13"
                settings.webInspectorEnabled: true
                settings.userStyleSheetLocation: "patch.css"
                onNavigationRequested: {
                }
            }
            attachedObjects: [
                LayoutUpdateHandler {
                    onLayoutFrameChanged: {
                        webv.preferredWidth = layoutFrame.width
                    }
                }
            ]
            gestureHandlers: [
                DoubleTapHandler {
                    onDoubleTapped: {
                        if (actionbarhidden) {
                            rootpage.actionBarVisibility = ChromeVisibility.Default
                        } else {
                            rootpage.actionBarVisibility = ChromeVisibility.Hidden
                        }
                        actionbarhidden = ! actionbarhidden
                    }
                }
            ]
        }
        actions: [
            ActionItem {
                title: qsTr("Back")
                ActionBar.placement: ActionBarPlacement.OnBar
                enabled: webv.canGoBack
                onTriggered: {
                    webv.goBack()
                }
                imageSource: "asset:///img/back.png"
            },
            ActionItem {
                title: qsTr("Home")
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: {
                    if (webv.url == "http://m.tv.sohu.com") {
                        webv.reload();
                    } else {
                        webv.url = "http://m.tv.sohu.com"
                    }
                }
                imageSource: "asset:///img/home.png"
            },
            ActionItem {
                id: actionbookmark
                title: qsTr("Bookmark")
                imageSource: "asset:///img/star1.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: {
                    bookmark.toggle(webv.title, webv.url.toString());
                    syncbookmark();
                }
            },
            ActionItem {
                title: qsTr("Forward")
                ActionBar.placement: ActionBarPlacement.Default
                onTriggered: {
                    webv.goForward()
                }
                enabled: webv.canGoForward
                imageSource: "asset:///img/forward.png"
            },
            ActionItem {
                title: qsTr("Toggle Landscape Lock")
                onTriggered: {
                    if (lockedlandscape) {
                        lockedlandscape = false
                        OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.All
                    } else {
                        lockedlandscape = true
                        OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.DisplayLandscape
                    }
                }
                ActionBar.placement: ActionBarPlacement.InOverflow
                imageSource: "asset:///img/landscape.png"
            },
            ActionItem {
                title: qsTr("Hide Action Bar")
                imageSource: "asset:///img/full.png"
                ActionBar.placement: ActionBarPlacement.InOverflow
                onTriggered: {
                    sst.show();
                    rootpage.actionBarVisibility = ChromeVisibility.Hidden
                    actionbarhidden = true;
                }
                attachedObjects: [
                    SystemToast {
                        id: sst
                        body: qsTr("Double Tap to toggle action-bar visibility.")
                    }
                ]
            },
            ActionItem {
                title: qsTr("Clean Cache")
                ActionBar.placement: ActionBarPlacement.InOverflow
                onTriggered: {
                    webv.storage.clear();
                    cleared.show()
                }
                attachedObjects: [
                    SystemToast {
                        id: cleared
                        body: qsTr("Cache cleared.")
                    }
                ]
            }
        ]
        actionBarVisibility: ChromeVisibility.Default
    }

}