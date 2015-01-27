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
        ScrollView {
            Container {
                id: content
            }
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
                    content.removeAll();
                    for (var i = 0; i < k.length; i ++) {
                        var l = line.createObject();
                        l.title = k.value(i);
                        l.url = v.value(i);
                        l.id = i;
                        l.onTrigger=function(){
                            bookmarkmgr.parent.webv.url=url;
                            bookmarkmgr.close();
                        }
                        l.onRemove=function(){
                            sto.removeByKey(url);
                            content.remove(this);
                        }
                        content.add(l);
                    }
                }
            },
            ComponentDefinition {
                id: line
                source: "Ctrl-Listline.qml"
            }
        ]
        titleBar: TitleBar {
            title: qsTr("Bookmarks")
        }
    }
}