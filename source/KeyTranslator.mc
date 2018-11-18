using Toybox.WatchUi;

class KeyTranslator {
    hidden const translations = {
        "p" => Rez.Strings.keyNamePressure,
        "so2" => Rez.Strings.keyNameSO2,
        "pm25" => Rez.Strings.keyNamePM25,
        "pm10" => Rez.Strings.keyNamePM10,
        "no2" => Rez.Strings.keyNameNO2,
        "h" => Rez.Strings.keyNameHumidity,
        "o3" => Rez.Strings.keyNameO3,
        "w" => Rez.Strings.keyNameWind,
        "co" => Rez.Strings.keyNameCO,
        "t" => Rez.Strings.keyNameTemp,
        "wg" => Rez.Strings.keyNameGust,
    };
    
    function tryTranslateKey(key) {
        if (translations.hasKey(key)) {
            return WatchUi.loadResource(translations[key]);
        }
        return key;
    }
}