function sendReq(options) {
    var o = {
        type: "POST",
        async: true,
        url: "",
        contentType: null,
        data: null,
        onResponse: null,
        timeout: 0,
    };

    if (options.type != null)
        o.type = options.type;
    if (options.async != null)
        o.async = options.async;
    if (options.url != null)
        o.url = options.url;
    if (options.contentType != null)
        o.contentType = options.contentType;
    if (options.data != null)
        o.data = options.data;
    if (options.onResponse != null)
        o.onResponse = options.onResponse;
    if (options.timeout != null)
        o.timeout = options.timeout;

    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4) {
            if (o.onResponse != null) {
                o.onResponse(xhr.responseText);
            }
        }
    }

    var cb = new Date();
    xhr.open(o.type, o.url + "&cb=" + cb.getTime(), o.async);
    if (o.contentType)
        xhr.setRequestHeader("Content-Type", o.contentType);
    if (o.async == true && o.timeout > 0)
        xhr.timeout = o.timeout;
    xhr.send(o.data);
}