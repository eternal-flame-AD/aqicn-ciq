using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Communications;

class AQICNView extends WatchUi.View {
            
    hidden var status = "loading";
    hidden var errMsg = null;
    hidden var aqiResp = null;
    hidden var translator = new KeyTranslator();

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        if (status.equals("ok") && aqiResp != null) {
            dc.drawText(dc.getWidth()/2, 0, Graphics.FONT_MEDIUM, aqiResp["city"], Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth()/2, 20, Graphics.FONT_MEDIUM, "AQI Index: " + aqiResp["aqi"], Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth()/2, 40, Graphics.FONT_MEDIUM, "Updated: " + ((Time.now().value()-aqiResp["update"])/60).format("%d") + " min. ago", Graphics.TEXT_JUSTIFY_CENTER);
            var keys = aqiResp["data"].keys();
            for (var i=0;i<(keys.size()+1)/2;i++) {
                var str = DataFormatter.format(translator.tryTranslateKey(keys[i*2]), aqiResp["data"][keys[i*2]]);
                if (i*2+1!=keys.size()) {
                    str = str  + "   " + DataFormatter.format(translator.tryTranslateKey(keys[i*2+1]),aqiResp["data"][keys[i*2+1]]);
                }
                dc.drawText(dc.getWidth()/2, 60+i*20, Graphics.FONT_MEDIUM, str, Graphics.TEXT_JUSTIFY_CENTER);
            }
        } else if (errMsg != null) {
            dc.drawText(dc.getWidth()/2, 0, Graphics.FONT_MEDIUM, "Status: " + status, Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth()/2, 20, Graphics.FONT_MEDIUM, "Reason: " + errMsg, Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            dc.drawText(dc.getWidth()/2, 0, Graphics.FONT_MEDIUM, "Status: " + status, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
    
    function onError(msg) {
        status = "error";
        errMsg = msg;
        WatchUi.requestUpdate();
    }
    
    function onAQIData(data) {
        status = "ok";
        aqiResp = data;
        WatchUi.requestUpdate();
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
