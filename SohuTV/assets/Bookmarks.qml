import bb.cascades 1.0

QtObject {
    /*
     * bk
     * [
     * {
     * "title":"",
     * "url":""
     * }
     * ]
     */
    property variant bk
    /*
     * urls is an array of string urls,for cache
     */
    property variant urls
    function reload(data) {
        if (data.trim().length > 0) {
            bk = JSON.parse(data)
            console.log("Readed : " + bk.length);
            // Sync to urls
            refreshCache()
        } else {
            bk = [];
            urls = [];
        }

    }
    function exp() {
        console.log("Exporting...");
        return JSON.stringify(bk);
    }
    function refreshCache() {

        // store urls in cache for better performance.
        // so I only need to test whether the url is in cache.
        urls = [];
        bk.every(function(v, i) {
                urls.push(v.url);
            })
        console.log("cache refreshed.")
    }

    function add(_name, _url) {
        console.log("Adding: " + _name + " , " + _url);
        //test if this url is already in the cache
        var index = urls.indexOf(_url);
        console.log(index);
        if (index > -1) {
            bk.push(bk.splice(index, 1))
            console.log("moved to top.");
        } else {
            // not added, update the data
            bk.push({
                    "title": _name,
                    "url": _url
                })
            urls.push(_url);
            console.log("added new.");
            console.log(JSON.stringify(bk))
            console.log(JSON.stringify(urls))
        }
        console.log(JSON.stringify(bk))
    }
    function exists(url) {
        /*
         * Test if the specified url is existed in cache.
         */
        /*
         * every in Array
         * func(value,index,Array)
         */

        return (urls.indexOf(url) > -1) ? true : false;
    }
    function removeByURL(u) {
        console.log("removing " + u);
        /*
         * remove an item from bookmark by its url.
         */
        var index = urls.indexOf(u);
        if (index > -1) {
            bk.splice(index, 1);
            urls.splice(index, 1);
        }
    }
    function toggle(n, u) {
        if (exists(u)) {
            removeByURL(u);
        } else {
            add(n, u);
        }
    }
}
