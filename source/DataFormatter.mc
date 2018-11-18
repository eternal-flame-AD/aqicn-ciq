using Toybox.System;

class DataFormatter {
    static function format(key, val) {
        if (val<10) {
            return key + ": " + val.format("%.1f");
        } else {
            return key + ": " + val.format("%d");
        }
    }
    static function calculateEpoch(v, tz) {
        System.println("calculating epoch: "+v+tz);
        var tzdelta = 0;
        var tzhour = tz.substring(1,3).toNumber();
        var tzminute = tz.substring(4,6).toNumber();
        tzdelta += tzhour*3600 + tzminute*60;
        if (tz.substring(0,1).equals("-")) {
            tzdelta *= -1;
        }
        System.println(v-tzdelta);
        return v-tzdelta;
    }
}