
Parse.Cloud.define("bSave", function(request, response) {
    var url = request.params.link;
    var query = new Parse.Query("Data");
    query.equalTo("link", url);
    query.find({
        success: function(results) {
            console.log('http://api.diffbot.com/v3/product?token=6ec693665e677a8dd630f0f261114fdf&url=' + url );
            Parse.Cloud.httpRequest({
                method: "GET",
                url: 'http://api.diffbot.com/v3/product?token=6ec693665e677a8dd630f0f261114fdf&url=' + url
            }).then(function (httpResponse) {
                var jsonResponse = JSON.parse(httpResponse.text);
                results[0].set("description", jsonResponse.objects[0].title);
                results[0].set("price", parseInt(jsonResponse.objects[0].offerPrice));
                results[0].set("prev_price", parseInt(jsonResponse.objects[0].offerPrice));
                results[0].set("photoURL", jsonResponse.objects[0].images[0].url);
                results[0].set("deleted", false);
                results[0].save();
                response.success();
            }, function(err) {
                console.error(err);
            });
        },
        error: function() {
            response.error("error");
        }
    });
    

});
