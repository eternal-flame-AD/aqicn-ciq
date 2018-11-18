using Toybox.Application;
using Toybox.Communications;
using Toybox.System;

class AQICNApp extends Application.AppBase {

    hidden var view;
    hidden var apiKey;
    hidden var stationName;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        apiKey = Application.getApp().getProperty("apiKey");
        stationName = Application.getApp().getProperty("stationName");
        getAQI();
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        view = new AQICNView();
        return [ view ];
    }

    function receiveAQIResponse(responseCode, data) {
        if (responseCode==200) {
            var status = data["status"];
            if (status.equals("ok")) {
                var dataMap = {};
                var keys = data["data"]["iaqi"].keys();
                for (var i=0; i<keys.size(); i++) {
                    dataMap[keys[i]] = data["data"]["iaqi"][keys[i]]["v"];
                }
                view.onAQIData({
                    "aqi" => data["data"]["aqi"],
                    "data" => dataMap,
                    "city" => data["data"]["city"]["name"],
                    "update" => DataFormatter.calculateEpoch(data["data"]["time"]["v"], data["data"]["time"]["tz"]),
                });
            } else if (status.equals("error")) {
                view.onError(data["data"]);
            }
        } else {
            view.onError(responseCode);
        }
    }
    
    function getAQI() {
        Communications.makeWebRequest("https://api.waqi.info/feed/" + stationName + "/?token=" + apiKey , null, {
                :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
        }, method(:receiveAQIResponse));
    }

}