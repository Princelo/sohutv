import bb.cascades 1.0
Sheet {
    id: bookmarkmgr
    Page {
        actions: [
            ActionItem {
                title: qsTr("Back")
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: {
                    bookmarkmgr.close()
                }

            }
        ]
        ListView {
            id: bookmarklist
            dataModel: ArrayDataModel {
                id: adm
            }
            snapMode: SnapMode.LeadingEdge
            horizontalAlignment: HorizontalAlignment.Fill
            listItemComponents: ListItemComponent {
                type: "item"
                StandardListItem {
                    title: ListItemData.k
                    description: ListItemData.v
                    textFormat: TextFormat.Plain
                    onTouch: {
                        navpane.navto(description);
                        bookmarkmgr.close()
                    }
                }
            }
            verticalAlignment: VerticalAlignment.Fill
        }
        attachedObjects: [
            Storage {
                id: sto
                onDatachanged: {
                    console.log(serialize())
                    _app.setValue("bookmark", serialize());
                }
                onCreationCompleted: {
                    load(_app.getValue("bookmark", ""));
                    for (var i = 0; i < k.length; i ++) {
                        adm.append({
                                k: k.value(i),
                                v: v.value(i)
                            });
                    }
                }
            }
        ]
        titleBar: TitleBar {
            title: qsTr("Bookmarks")
        }
    }
}