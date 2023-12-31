import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Lang;
import Toybox.Communications;
import Toybox.System;
import Toybox.Attention;

module WheelData {
    var currentSpeed = "0.0",
        batteryPercentage = 0,
        batteryVoltage,
        batteryPercentageLoadDrop = 0, // This is the yellow arc value
        temperature = 0,
        useMph = 0,
        speedLimit = 40,
        rideTime = "00:00:00",
        rideDistance = 0,
        averageSpeed,
        topSpeed,
        pwm = "00",
        maxPwm = "00",
        alarmType = 0,
        isWheelConnected = false,
        wheelModel = "";
        
    var webServerPort;
    var isAppConnected = false;

    var dataUpdateTimer = new Timer.Timer();
    var appUpdateTimer = new Timer.Timer();

    function setIsAppConnected(data) {
        var previousState = WheelData.isAppConnected;
        isAppConnected = data;

        if (isAppConnected == true && previousState == false) {
            var progressBar = new WatchUi.ProgressBar(WatchUi.loadResource(Rez.Strings.LoadingScreen_ConnectionSuccessful), 100.0);
            WatchUi.switchToView(progressBar, new WaitingForConnectionViewDelegate(), WatchUi.SLIDE_IMMEDIATE);
            var timer = new Timer.Timer();
            timer.start(new Lang.Method(WheelData, :_hideConnectionScreenMethod), 1000, false);

            dataUpdateTimer.start(new Lang.Method($, :dataUpdateTimerMethod), AppStorage.getSetting("DataUpdateSpeed"), true); // Start a timer routine for constantly getting data from the phone
        } else if (isAppConnected == false) {
            var progressBar = new WatchUi.ProgressBar(WatchUi.loadResource(Rez.Strings.LoadingScreen_WaitingConnectionWithApp), null);
            WatchUi.pushView(progressBar, new WaitingForConnectionViewDelegate(), WatchUi.SLIDE_UP);
            if (dataUpdateTimer != null) {
                dataUpdateTimer.stop(); // Shut down timer
            }
        }
    }

    function _hideConnectionScreenMethod() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
