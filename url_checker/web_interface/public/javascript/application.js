var send_ajax = function(url, method, params, success){
    var r = new XMLHttpRequest();
    r.open(method, url, true);
    r.onreadystatechange = function () {
        if (r.readyState != 4 || r.status != 200) return;
        success();
    };
    r.send(params);
};
document.addEventListener("DOMContentLoaded", function() {
    var links = document.getElementsByClassName('delete');
    for(var i = 0; i < links.length; i++) {
        links[i].addEventListener('click', function(e){
            e.preventDefault();
            var element = e.target;
            var id = element.dataset.id;
            alert('not yet working');
            // send_ajax('/delete_url', 'POST', "id="+id, function(){
            //     alert('sent!');
            // })
        }, false);
    }
});