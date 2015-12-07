
Parse.Cloud.define("bSave", function(request, response) {
    var url = request.params.link;
    console.log(request.user.get("credits"));
    Parse.Cloud.useMasterKey();
    request.user.set("credits", parseInt(request.user.get("credits")) - 1);
    request.user.save();
   /* var query = new Parse.Query("User");
    query.equalTo("objectId", usr);
    query.find({
        success: function(results) {
            results[0].set("credits", parseInt(results[0].get("credits")) - 1);
        },
        error: function() {
            response.error("error");
        }
    });
    */
    query = new Parse.Query("Data");
    query.equalTo("link", url);
    query.find({
        success: function(results) {
            console.log('http://api.diffbot.com/v3/product?token=ab3a0c3a01500212c58e303946d068d8&url=' + url );
            Parse.Cloud.httpRequest({
                method: "GET",
                url: 'http://api.diffbot.com/v3/product?token=ab3a0c3a01500212c58e303946d068d8&url=' + url
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
