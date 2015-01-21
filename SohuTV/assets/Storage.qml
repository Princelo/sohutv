import bb.cascades 1.0
/*
 * Author: Merrick Zhang ( anphorea@gmail.com )
 * Brief: This is a tested way for BlackBerry Cascades's QT-Javascript to 
 * read / write / add / remove items in Key/Value pairs.
 * HOW TO USE:
 * Attach this object in QML, then do the save/load outside.
 */
QtObject {
    signal datachanged

    property ArrayDataModel k: ArrayDataModel {

    }
    property ArrayDataModel v: ArrayDataModel {

    }
    function addItem(key, value) {
        if (exists(key) || exists(value)) {
            console.log("Exited.");
        } else {
            k.append(key);
            v.append(value);
            datachanged()
        }
    }
    function exists(key) {
        if (k && v) {
            return (k.indexOf(key) > -1) || (v.indexOf(key) > -1)
        } else {
            return false;
        }
    }
    function removeByKey(key) {
        if (exists(key)) {
            var index = k.indexOf(key);
            k.removeAt(index);
            v.removeAt(index);
            datachanged()
        } else {
            console.log(key + " not existed.");
        }
    }
    function toggle(key, value) {
        if (exists(key)) {
            removeByKey(key);
        } else {
            addItem(key, value)
        }
    }
    function serialize() {
        var datak = new Array();
        var datav = new Array();
        for (var i = 0; i < k.size(); i ++) {
            datak.push(k.value(i));
            datav.push(v.value(i));
        }
        var data = {
            "k": datak,
            "v": datav
        }
        return JSON.stringify(data);
    }
    function load(str) {
        if (str.length > 0) {
            var data = JSON.parse(str);
            if (data.k && data.v) {

                var datak = data.k;
                var datav = data.v;
                for (var i = 0; datak,i<datak.length; i ++) {
                    k.append(datak[i]);
                    v.append(datav[i]);
                }
            }
        }
    }
}