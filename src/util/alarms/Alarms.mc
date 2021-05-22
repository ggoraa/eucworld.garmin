using Toybox.Attention;
using Toybox.Timer;

module Alarms {
    var alarmUpdateTimer = new Timer.Timer();
    function startAlarmRoutine(updateTime) {
        alarmUpdateTimer.start(method(:alarmHandler), updateTime, true);
    }

    function stopAlarmRoutine() {
        alarmUpdateTimer.stop();
    }

    function alarmHandler() {
        if (WheelData.alarmType != 0) {
            Attention.vibrate(alarmProfile);
        }
    }

    var alarmProfile = [
        new Attention.VibeProfile(100, 50),
        new Attention.VibeProfile(0, 50),
        new Attention.VibeProfile(100, 50),
        new Attention.VibeProfile(0, 50)
    ];
}