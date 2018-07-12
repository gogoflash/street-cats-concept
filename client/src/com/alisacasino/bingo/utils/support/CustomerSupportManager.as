/**
 * @author grdy
 * @since 6/21/17
 */
package com.alisacasino.bingo.utils.support {
import com.alisacasino.bingo.models.Player;
import com.alisacasino.bingo.platform.PlatformServices;
import com.alisacasino.bingo.utils.Constants;

import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.system.Capabilities;

import mx.utils.StringUtil;

public class CustomerSupportManager {
    private const BODY_TEMPLATE:String = "\n" +
            "[Please describe what happened here]\n" +
            "\n" +
            "\n" +
            "\n" +
            "Please leave following information intact as it helps us diagnose your issue\n" +
            "------------\n" +
            "version: {0}\n" +
            "player_id: {1}\n" +
            "os: {2}\n" +
			"model: {3}";

    private const SUBJECT_TEMPLATE:String = "[Arena Bingo] issue from player: {0}";

    private const SUPPORT_ADDR:String = "support@alisagaming.com";

    private static var _instance:CustomerSupportManager;

    function CustomerSupportManager() {
    }

    public static function get instance():CustomerSupportManager {
        if (_instance == null) {
            _instance = new CustomerSupportManager();
        }

        return _instance;
    }

    public function openMailto():void {
        var url:String = 'mailto:'+ SUPPORT_ADDR +'?' +
                'subject=' + StringUtil.substitute(SUBJECT_TEMPLATE, Player.current.playerId) +
                '&body=' + StringUtil.substitute(
                        BODY_TEMPLATE, gameManager.getVersionString(), Player.current.playerId, PlatformServices.interceptor.getOS(), PlatformServices.interceptor.getDeviceModel()
                );
        var urlRequest:URLRequest = new URLRequest(url);
        navigateToURL(urlRequest);
    }
}
}
