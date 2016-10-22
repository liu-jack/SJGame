function sdkBase(){this.servType={APP:"APP_SERV",COMMON:"COMMON_SERV",LOGIN:"LOGIN_SERV",PAY:"PAY_SERV",PHONE:"PHONE_SERV",BBS:"BBS_SERV",SDKSERVER:"SDK_SERVER_SERV"},this.actions={HISTORY_BACK:"HISTORY_BACK",LOAD_URL:"LOAD_URL",URL_HASH_CHANGE:"URL_HASH_CHANGE",CLEAR_HISTORY:"CLEAR_HISTORY",OVERRIDE_BACK_BTN:"OVERRIDE_BACK_BTN",KEYBOARD:"KEYBOARD",GET_SDK_INFO:"GET_SDK_INFO",GET_GAME_INFO:"GET_GAME_INFO",GET_CURR_USER:"GET_CURR_USER",SET_SETTING:"SET_SETTING",GET_SETTING:"GET_SETTING",GET_NETWORK_INFO:"GET_NETWORK_INFO",START_APP:"START_APP",SET_PAGE_PARAMS:"SET_PAGE_PARAMS",GET_PAGE_PARAMS:"GET_PAGE_PARAMS",STAT:"STAT",SIGN:"SIGN",GET_PHONE:"GET_PHONE",VERIFY_SIGN:"VERIFY_SIGN",GET_SOURCE_PAGE_INFO:"GET_SOURCE_PAGE_INFO",JUMP_TO_NATIVE_PAGE:"JUMP_TO_NATIVE_PAGE",SET_UI_STYLE:"SET_UI_STYLE",JUMP_TO_SDKPAGE:"JUMP_TO_SDKPAGE",GET_FEATURE_SWITCH:"GET_FEATURE_SWITCH",GET_CLIENT_CONFIG:"GET_CLIENT_CONFIG",TOAST:"TOAST",LOADING_INDICATOR_SHOW:"LOADING_INDICATOR_SHOW",HIDE_LOADING_INDICATOR:"HIDE_LOADING_INDICATOR",GET_LOGIN_CONFIG:"GET_LOGIN_CONFIG",GET_LOGIN_HISTORY:"GET_LOGIN_HISTORY",GET_LOGIN_GAMEHISTORY:"GET_LOGIN_GAMEHISTORY",GET_LOGIN_GAMEHISTORYSYNC:"GET_LOGIN_GAMEHISTORYSYNC",GET_LOGIN_HISTORY_COUNT:"GET_LOGIN_HISTORY_COUNT",DELETE_LOGIN_HISTORY:"DELETE_LOGIN_HISTORY",LOGIN:"LOGIN",REGISTER:"REGISTER",LOGIN_AFTER_REGISTER:"LOGIN_AFTER_REGISTER",LOGIN_EXIT_SDK:"LOGIN_EXIT_SDK",LOGIN_NOTIFY_CP:"LOGIN_NOTIFY_CP",LOGOUT:"LOGOUT",CHANGE_PASSWORD:"CHANGE_PASSWORD",LOGOUT_NOTIFY_CP:"LOGOUT_NOTIFY_CP",SET_AUTO_LOGIN_STATE:"SET_AUTO_LOGIN_STATE",JUMP_TO_LOGIN_WIDGET:"JUMP_TO_LOGIN_WIDGET",GET_PAYMENT_INFO:"GET_PAYMENT_INFO",EXIT_SDK:"EXIT_SDK",GET_PAY_WAY:"GET_PAY_WAY",GET_PAY_WAY_USAGE:"GET_PAY_WAY_USAGE",CMCCPAY:"CMCCPAY",UDPAY:"UDPAY",CARDPAY:"CARDPAY",PAY_EXIT_SDK:"PAY_EXIT_SDK",PAY_NOTIFY_CP:"PAY_NOTIFY_CP",ALI_PAY:"ALI_PAY",CMCC_GAME_PAY:"CMCC_GAME_PAY",CALL_SDK_SERVER:"CALL_SDK_SERVER",SMS_SEND_MESSAGE:"SMS_SEND_MESSAGE",REGISTER_GUEST:"REGISTER_GUEST",ACTIVATE_GUEST:"ACTIVATE_GUEST"},this.sdkInfoObj={}}!function(e){e.prototype.hooks={extend:function(e,t){c[e]||(c[e]=[]),c[e].push(t);try{t.initialize()}catch(n){throw new Error("Undefined initialize function")}}},e.prototype.request=function(e,n,r,o,i,a,c,d){function f(e){u(v)||0==v||clearTimeout(v),G||(u(e)||g(e)?b(e):u(e.success)||e.success?T(e):b(e))}function T(e){!u(o)&&p(o)&&o.apply(this,[e]),l.success(h)}function b(e){!u(i)&&p(i)&&i.apply(this,[e]),l.fail(h)}function A(){G=!0,!u(i)&&p(i)&&i.apply(this,[{success:!1,msg:"请求超时，请重新再试"}]),l.timeout(h)}var h=0,v=0,G=!1,y={};if(_(I,n)>=0&&(a=!0),!u(O[n])){var N=S(this.sdkVersion(),O[n]);if(!1===N||0>N)return y={success:!1,msg:"接口请求失败，请联系我们"},a?(b(y),void 0):y}h=l.start(e,n,r,a,d),a=u(a)?!1:a,r=u(r)||g(r)?{}:r,c=!u(c)&&E(c)?c:1;var R=t(e);if(!R)return!1;var C=R.apply(this,[n]);return C?(u(v)||g(v)||clearTimeout(v),v=setTimeout(s(A,this),1e3*c),a?(C.apply(this,[r,f,e,n]),void 0):(y=C.apply(this,[r,null,e,n]),f(y),y)):!1},e.prototype.isCmwap=function(){return this.request(this.servType.COMMON,this.actions.GET_NETWORK_INFO)},e.prototype.sdkInfo=function(){if(g(this.sdkInfoObj)){var e=this.request(this.servType.COMMON,this.actions.GET_SDK_INFO);e.success&&(this.sdkInfoObj=e.data)}return this.sdkInfoObj},e.prototype.sdkVersion=function(){var e=this.sdkInfo();return g(e)?null:e.ve},e.prototype.osVersion=function(){var e=S(this.sdkVersion(),"2.1.0");if(!1!==e&&e>=0){var t=this.sdkInfo();return g(t)?t.androidSdkVer:null}return null};var t=function(e){return T[e]?!u(r[T[e]])&&p(r[T[e]])?r[T[e]]:n:!1},n=function(e){return b[e]?!u(i[b[e]])&&p(i[b[e]])?i[b[e]]:o:!1},r={SdkServerService:function(e){return b[e]?(this.callSdkServer=i.callSdkServer,this[b[e]]):!1}},o=function(e,t,n,r){return u(t)||null==t?n&&r?bridge.exec(T[n],b[r],e):{success:!1}:(n&&r||t.apply(this,[{success:!1}]),bridge.exec(T[n],b[r],e,t),void 0)},i={callSdkServer:function(e,t,n,r){if(u(e)||u(e.api))throw new Error('A "api" attribute is required');var o=e.api;delete e.api;var i={service:o,data:e};bridge.exec(T[n],b[r],i,t)}},a=function(){return this._lastId=0,this._requestPool=[],this._events=[],this.start=function(e,t,n,r,o){var i;if(o=u(o)?{}:o,this._requestPool.push(++this._lastId),c.request){i=this._lastId;for(var a=0;a<c.request.length;a++)setTimeout(s(function(a){c.request[a].start({id:i,service:e,action:t,param:n,isAsyn:r,option:o})}(a),this),1)}return i},this.success=function(e){if(c.request)for(var t=0;t<c.request.length;t++)setTimeout(s(function(t){c.request[t].success({id:e})}(t),this),1)},this.fail=function(e){if(c.request)for(var t=0;t<c.request.length;t++)setTimeout(s(function(t){c.request[t].fail({id:e})}(t),this),1)},this.timeout=function(e){if(c.request)for(var t=0;t<c.request.length;t++)setTimeout(s(function(t){c.request[t].timeout({id:e})}(t),this),1)},this},l=new a,c={},s=function(e,t){if("string"==typeof t){var n=e[t];t=e,e=n}if(!p(e))return void 0;var r=Array.prototype.slice.call(arguments,2),o=function(){return e.apply(t,r.concat(Array.prototype.slice.call(arguments)))};return o},u=function(e){return void 0===e},d=Array.isArray||function(e){return"[object Array]"===Object.prototype.toString.call(e)},f=function(e){return"[object String]"===Object.prototype.toString.call(e)},E=function(e){return"[object Number]"===Object.prototype.toString.call(e)},p=function(e){return"[object Function]"===Object.prototype.toString.call(e)},_=function(e,t){if(null===e)return-1;if(Array.prototype.indexOf&&e.indexOf===Array.prototype.indexOf)return e.indexOf(t);for(var n=0,r=e.length;r>n;n++)if(n in e&&e[n]===t)return n;return-1},g=function(e){if(null===e)return!0;if(d(e)||f(e))return 0===e.length;for(var t in e)if(Object.prototype.hasOwnProperty.call(e,t))return!1;return!0},S=function(e,t){if(!e)return!1;if(!t)return!1;var n=e.split("."),r=t.split(".");if(n.length<3||3>r)return!1;var o=100*parseInt(n[0])+10*parseInt(n[1])+parseInt(n[2]),i=100*parseInt(r[0])+10*parseInt(r[1])+parseInt(r[2]);return o>i?1:o==i?0:-1},T={APP_SERV:"App",COMMON_SERV:"CommonService",LOGIN_SERV:"LoginService",PAY_SERV:"PayService",SDK_SERVER_SERV:"SdkServerService",PHONE_SERV:"PhoneService"},b={HISTORY_BACK:"backHistory",LOAD_URL:"loadUrl",URL_HASH_CHANGE:"urlHashChange",CLEAR_HISTORY:"clearHistory",OVERRIDE_BACK_BTN:"overrideBackbutton",KEYBOARD:"keyboard",GET_SDK_INFO:"getSdkInfo",GET_GAME_INFO:"getGameInfo",GET_CURR_USER:"getCurrUser",SET_SETTING:"setSetting",GET_SETTING:"getSetting",GET_NETWORK_INFO:"getNetworkInfo",START_APP:"startOrDownloadApp",SET_PAGE_PARAMS:"setPageParams",GET_PAGE_PARAMS:"getPageParams",STAT:"stat",SIGN:"sign",GET_PHONE:"getPhoneInfo",VERIFY_SIGN:"verifySign",GET_SOURCE_PAGE_INFO:"getNativeSourcePageInfo",JUMP_TO_NATIVE_PAGE:"jumpToNativePage",SET_UI_STYLE:"setNativeUIStyle",JUMP_TO_SDKPAGE:"jumpToSdkPage",GET_FEATURE_SWITCH:"getFeatureSwitch",GET_CLIENT_CONFIG:"getClientConfig",TOAST:"toast",LOADING_INDICATOR_SHOW:"showloadingIndicator",HIDE_LOADING_INDICATOR:"hideLoadingIndicator",GET_LOGIN_CONFIG:"getLoginConfig",GET_LOGIN_HISTORY:"getLoginHistory",GET_LOGIN_GAMEHISTORY:"getLoginHistoryWithGame",GET_LOGIN_GAMEHISTORYSYNC:"getLoginHistoryWithGameSync",GET_LOGIN_HISTORY_COUNT:"getUCIDLoginHistoryCount",DELETE_LOGIN_HISTORY:"deleteLoginHistory",LOGIN:"login",REGISTER:"register",LOGIN_AFTER_REGISTER:"doLoginForRegister",LOGIN_EXIT_SDK:"exitSdk",LOGIN_NOTIFY_CP:"loginNotifyCp",LOGOUT:"logout",CHANGE_PASSWORD:"changePassword",LOGOUT_NOTIFY_CP:"logoutNotifyCp",SET_AUTO_LOGIN_STATE:"setAutoLoginState",JUMP_TO_LOGIN_WIDGET:"jumpToLoginWidget",GET_PAYMENT_INFO:"getPaymentInfo",EXIT_SDK:"exitSdk",GET_PAY_WAY:"getPayWay",GET_PAY_WAY_USAGE:"getPayWayUsage",CMCCPAY:"cmccPay",UDPAY:"udPay",CARDPAY:"cardPay",PAY_EXIT_SDK:"exitSdk",PAY_NOTIFY_CP:"payNotifyCp",ALI_PAY:"alixPay",CMCC_GAME_PAY:"cmccGamePay",CALL_SDK_SERVER:"callSdkServer",SMS_SEND_MESSAGE:"smsSendMessage",REGISTER_GUEST:"registerForGuestBind",ACTIVATE_GUEST:"loginForGuestBind"},I=["LOGIN","REGISTER","CHANGE_PASSWORD","GET_LOGIN_HISTORY","GET_PAY_WAY","GET_PAY_WAY_USAGE","CMCCPAY","UDPAY","CARDPAY","SIGN","VERIFY_SIGN","CALL_SDK_SERVER","CMCC_GAME_PAY","ALI_PAY","GET_LOGIN_GAMEHISTORY","KEYBOARD"],O={SIGN:"2.1.0",GET_PHONE:"2.1.0",VERIFY_SIGN:"2.1.0",ALI_PAY:"2.1.0",CMCC_GAME_PAY:"2.1.0",GET_SOURCE_PAGE_INFO:"2.1.0",JUMP_TO_NATIVE_PAGE:"2.1.0",SET_UI_STYLE:"2.1.0",JUMP_TO_SDKPAGE:"2.1.0",SMS_SEND_MESSAGE:"2.1.4",GET_LOGIN_GAMEHISTORY:"2.1.4",GET_LOGIN_GAMEHISTORYSYNC:"2.2.0",GET_FEATURE_SWITCH:"2.2.0",LOGOUT_NOTIFY_CP:"2.2.0",GET_CLIENT_CONFIG:"2.2.0",OVERRIDE_BACK_BTN:"2.2.0",GET_LOGIN_HISTORY_COUNT:"2.2.0",KEYBOARD:"2.2.1",LOADING_INDICATOR_SHOW:"2.3.5",HIDE_LOADING_INDICATOR:"2.3.5"}}(sdkBase);var JSON;JSON||(JSON={}),function(){"use strict";function f(e){return 10>e?"0"+e:e}function quote(e){return escapable.lastIndex=0,escapable.test(e)?'"'+e.replace(escapable,function(e){var t=meta[e];return"string"==typeof t?t:"\\u"+("0000"+e.charCodeAt(0).toString(16)).slice(-4)})+'"':'"'+e+'"'}function str(e,t){var n,r,o,i,a,l=gap,c=t[e];switch(c&&"object"==typeof c&&"function"==typeof c.toJSON&&(c=c.toJSON(e)),"function"==typeof rep&&(c=rep.call(t,e,c)),typeof c){case"string":return quote(c);case"number":return isFinite(c)?String(c):"null";case"boolean":case"null":return String(c);case"object":if(!c)return"null";if(gap+=indent,a=[],"[object Array]"===Object.prototype.toString.apply(c)){for(i=c.length,n=0;i>n;n+=1)a[n]=str(n,c)||"null";return o=0===a.length?"[]":gap?"[\n"+gap+a.join(",\n"+gap)+"\n"+l+"]":"["+a.join(",")+"]",gap=l,o}if(rep&&"object"==typeof rep)for(i=rep.length,n=0;i>n;n+=1)"string"==typeof rep[n]&&(r=rep[n],o=str(r,c),o&&a.push(quote(r)+(gap?": ":":")+o));else for(r in c)Object.prototype.hasOwnProperty.call(c,r)&&(o=str(r,c),o&&a.push(quote(r)+(gap?": ":":")+o));return o=0===a.length?"{}":gap?"{\n"+gap+a.join(",\n"+gap)+"\n"+l+"}":"{"+a.join(",")+"}",gap=l,o}}"function"!=typeof Date.prototype.toJSON&&(Date.prototype.toJSON=function(){return isFinite(this.valueOf())?this.getUTCFullYear()+"-"+f(this.getUTCMonth()+1)+"-"+f(this.getUTCDate())+"T"+f(this.getUTCHours())+":"+f(this.getUTCMinutes())+":"+f(this.getUTCSeconds())+"Z":null},String.prototype.toJSON=Number.prototype.toJSON=Boolean.prototype.toJSON=function(){return this.valueOf()});var cx=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,escapable=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,gap,indent,meta={"\b":"\\b","	":"\\t","\n":"\\n","\f":"\\f","\r":"\\r",'"':'\\"',"\\":"\\\\"},rep;"function"!=typeof JSON.stringify&&(JSON.stringify=function(e,t,n){var r;if(gap="",indent="","number"==typeof n)for(r=0;n>r;r+=1)indent+=" ";else"string"==typeof n&&(indent=n);if(rep=t,t&&"function"!=typeof t&&("object"!=typeof t||"number"!=typeof t.length))throw new Error("JSON.stringify");return str("",{"":e})}),"function"!=typeof JSON.parse&&(JSON.parse=function(text,reviver){function walk(e,t){var n,r,o=e[t];if(o&&"object"==typeof o)for(n in o)Object.prototype.hasOwnProperty.call(o,n)&&(r=walk(o,n),void 0!==r?o[n]=r:delete o[n]);return reviver.call(e,t,o)}var j;if(text=String(text),cx.lastIndex=0,cx.test(text)&&(text=text.replace(cx,function(e){return"\\u"+("0000"+e.charCodeAt(0).toString(16)).slice(-4)})),/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,"@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,"]").replace(/(?:^|:|,)(?:\s*\[)+/g,"")))return j=eval("("+text+")"),"function"==typeof reviver?walk({"":j},""):j;throw new SyntaxError("JSON.parse")})}(),function(){var require,define;!function(){function e(e){var t=e.factory;return e.exports={},delete e.factory,t(require,e.exports,e),e.exports}var t={};require=function(n){if(!t[n])throw"module "+n+" not found";return t[n].factory?e(t[n]):t[n].exports},define=function(e,n){if(t[e])throw"module "+e+" already defined";t[e]={id:e,factory:n}},define.remove=function(e){delete t[e]}}(),"object"==typeof module&&"function"==typeof require&&(module.exports.require=require,module.exports.define=define),define("bridge",function(e,t,n){function r(e,t){var n=document.createEvent("Events");if(n.initEvent(e,!1,!1),t)for(var r in t)t.hasOwnProperty(r)&&(n[r]=t[r]);return n}var o=e("bridge/channel"),i=document.addEventListener,a=document.removeEventListener,l=window.addEventListener,c=window.removeEventListener,s={},u={};document.addEventListener=function(e,t,n){var r=e.toLowerCase();"bridgeready"==r?o.onBridgeReady.subscribeOnce(t):"resume"==r?(o.onResume.subscribe(t),o.onResume.fired&&t instanceof Function&&t()):"pause"==r?o.onPause.subscribe(t):"undefined"!=typeof s[r]?(console.log("documentEventHandlers:"+JSON.stringify(s)),s[r].subscribe(t)):i.call(document,e,t,n)},window.addEventListener=function(e,t,n){var r=e.toLowerCase();"undefined"!=typeof u[r]?u[r].subscribe(t):l.call(window,e,t,n)},document.removeEventListener=function(e,t,n){var r=e.toLowerCase();"undefined"!=typeof s[r]?s[r].unsubscribe(t):a.call(document,e,t,n)},window.removeEventListener=function(e,t,n){var r=e.toLowerCase();"undefined"!=typeof u[r]?u[r].unsubscribe(t):c.call(window,e,t,n)},"undefined"==typeof window.console&&(window.console={log:function(){}});var d={define:define,require:e,addWindowEventHandler:function(e,t){return u[e]=o.create(e,t)},addDocumentEventHandler:function(e,t){return s[e]=o.create(e,t)},removeWindowEventHandler:function(e){delete u[e]},removeDocumentEventHandler:function(e){delete s[e]},fireDocumentEvent:function(e,t){var n=r(e,t);"undefined"!=typeof s[e]?s[e].fire(n):document.dispatchEvent(n)},fireWindowEvent:function(e,t){var n=r(e,t);"undefined"!=typeof u[e]?u[e].fire(n):window.dispatchEvent(n)},shuttingDown:!1,UsePolling:!0,callbackId:0,callbacks:{},callbackStatus:{NO_RESULT:0,OK:1,CLASS_NOT_FOUND_EXCEPTION:2,ILLEGAL_ACCESS_EXCEPTION:3,INSTANTIATION_EXCEPTION:4,MALFORMED_URL_EXCEPTION:5,IO_EXCEPTION:6,INVALID_ACTION:7,JSON_EXCEPTION:8,ERROR:9},callbackSuccess:function(e,t){if(console.log("callbackId is "+e),d.callbacks[e]){if(t.status==d.callbackStatus.OK)try{d.callbacks[e].success&&d.callbacks[e].success(t.message)}catch(n){console.log("Error in success callback: "+e+" = "+n)}t.keepCallback||delete d.callbacks[e]}},callbackError:function(e,t){if(d.callbacks[e]){try{d.callbacks[e].fail&&d.callbacks[e].fail(t.message)}catch(n){console.log("Error in error callback: "+e+" = "+n)}t.keepCallback||delete d.callbacks[e]}}};n.exports=d}),define("bridge/channel",function(e,t,n){var r=function(e,t){this.type=e,this.handlers={},this.numHandlers=0,this.guid=0,this.fired=!1,this.enabled=!0,this.events={onSubscribe:null,onUnsubscribe:null},t&&(t.onSubscribe&&(this.events.onSubscribe=t.onSubscribe),t.onUnsubscribe&&(this.events.onUnsubscribe=t.onUnsubscribe))},o={join:function(e,t){for(var n=t.length,r=n,o=function(){--n||e()},i=0;r>i;i++)t[i].fired?n--:t[i].subscribeOnce(o);n||e()},create:function(e,t){return o[e]=new r(e,t),o[e]},deviceReadyChannelsArray:[],deviceReadyChannelsMap:{},waitForInitialization:function(e){if(e){var t=null;t=this[e]?this[e]:this.create(e),this.deviceReadyChannelsMap[e]=t,this.deviceReadyChannelsArray.push(t)}},initializationComplete:function(e){var t=this.deviceReadyChannelsMap[e];t&&t.fire()}},i=e("bridge/utils");r.prototype.subscribe=function(e,t,n){if(null!==e&&void 0!==e){var r=e;return"object"==typeof t&&e instanceof Function&&(r=i.close(t,e)),n=n||r.observer_guid||e.observer_guid||this.guid++,r.observer_guid=n,e.observer_guid=n,this.handlers[n]=r,this.numHandlers++,this.events.onSubscribe&&this.events.onSubscribe.call(this),n}},r.prototype.subscribeOnce=function(e,t){if(null!==e&&void 0!==e){var n=null,r=this,o=function(){e.apply(t||null,arguments),r.unsubscribe(n)};return this.fired?("object"==typeof t&&e instanceof Function&&(e=i.close(t,e)),e.apply(this,this.fireArgs)):n=this.subscribe(o),n}},r.prototype.unsubscribe=function(e){null!==e&&void 0!==e&&(e instanceof Function&&(e=e.observer_guid),this.handlers[e]=null,delete this.handlers[e],this.numHandlers--,this.events.onUnsubscribe&&this.events.onUnsubscribe.call(this))},r.prototype.fire=function(){if(this.enabled){var e=!1;this.fired=!0;for(var t in this.handlers){var n=this.handlers[t];if(n instanceof Function){var r=n.apply(this,arguments)===!1;e=e||r}}return this.fireArgs=arguments,!e}return!0},o.create("onDOMContentLoaded"),o.create("onNativeReady"),o.create("onBridgeCoreReady"),o.create("onBridgeReady"),o.create("onResume"),o.create("onPause"),o.create("onDestroy"),o.waitForInitialization("onBridgeCoreReady"),n.exports=o}),define("bridge/exec",function(require,exports,module){var bridge=require("bridge");module.exports=function(success,fail,service,action,args){try{var callbackId=service+bridge.callbackId++;(success||fail)&&(bridge.callbacks[callbackId]={success:success,fail:fail});var r=prompt(JSON.stringify(args||{}),"gap:"+JSON.stringify([service,action,callbackId,!0]));if(r.length>0){if(eval("var v="+r+";"),v.status===bridge.callbackStatus.OK){if(success){try{success(v.message)}catch(e){console.log("Error in success callback: "+callbackId+" = "+e)}v.keepCallback||delete bridge.callbacks[callbackId]}return v.message}if(v.status!==bridge.callbackStatus.NO_RESULT){if(console.log("Error: Status="+v.status+" Message="+v.message),fail){try{fail(v.message)}catch(e1){console.log("Error in error callback: "+callbackId+" = "+e1)}v.keepCallback||delete bridge.callbacks[callbackId]}return null}v.keepCallback||delete bridge.callbacks[callbackId]}}catch(e2){console.log("Error: "+e2)}}}),define("bridge/execapi",function(e,t,n){var r=e("bridge/exec");n.exports=function(e,t,n,o){try{return r(o,function(e){console.log("ERROR:in bridge/execapi,MSG="+e)},e,t,n)}catch(i){console.log("ERROR:in bridge/execapi;Exeception="+i)}}}),define("bridge/platform",function(e,t,n){n.exports={id:"android",initialize:function(){var t=e("bridge/channel"),n=e("bridge"),r=e("bridge/plugin/android/callback"),o=e("bridge/plugin/android/polling"),i=e("bridge/exec");t.onDestroy.subscribe(function(){n.shuttingDown=!0}),console.log("3---1---Start listening for XHR callbacks"),setTimeout(function(){if(n.UsePolling)o();else{var e=prompt("usePolling","gap_callbackServer:");n.UsePolling=e,"true"==e?(n.UsePolling=!0,o()):(n.UsePolling=!1,r())}},1),n.addDocumentEventHandler("backbutton",{onSubscribe:function(){1===this.numHandlers&&i(null,null,"App","overrideBackbutton",{override:!0})},onUnsubscribe:function(){0===this.numHandlers&&i(null,null,"App","overrideBackbutton",{override:!1})}}),n.addDocumentEventHandler("menubutton"),n.addDocumentEventHandler("searchbutton"),console.log("3---2---Figure out if we need to shim-in localStorage and WebSQL");var a=e("bridge/plugin/android/storage");if("undefined"==typeof window.openDatabase)window.openDatabase=a.openDatabase;else{var l=window.openDatabase;window.openDatabase=function(e,t,n,r){var o=null;try{o=l(e,t,n,r)}catch(i){if(18!==i.code)throw i;o=null}return null===o?a.openDatabase(e,t,n,r):o}}if(console.log("3---4---Patch localStorage if necessary"),"undefined"==typeof window.localStorage||null===window.localStorage){console.log("3---4---window.localStorage set");var c=new a.DIYLocalStorage;window.localStorage=c,window.localStorage1=c,console.log("3---4---new storage.DIYLocalStorage( result="+window.localStorage)}else console.log("3---4---window.localStorage already exists");console.log("3---5---Let native code know we are all done on the JS side."),t.join(function(){console.log("onBridgeCoreReady"),prompt("","gap_init:")},[t.onBridgeCoreReady])},objects:{bridge:{children:{JSCallback:{path:"bridge/plugin/android/callback"},JSCallbackPolling:{path:"bridge/plugin/android/polling"}}},navigator:{children:{app:{path:"bridge/plugin/android/app"}}}}}}),define("bridge/plugin/android/app",function(e,t,n){var r=e("bridge/exec");n.exports={clearCache:function(){r(null,null,"App","clearCache",null)},loadUrl:function(e,t){r(null,null,"App","loadUrl",{url:e,props:t})},cancelLoadUrl:function(){r(null,null,"App","cancelLoadUrl",null)},clearHistory:function(){r(null,null,"App","clearHistory",null)},backHistory:function(){r(null,null,"App","backHistory",null)},overrideBackbutton:function(e){r(null,null,"App","overrideBackbutton",{override:e})},exitApp:function(){return r(null,null,"App","exitApp",null)}}}),define("bridge/plugin/android/callback",function(require,exports,module){var port=null,token=null,bridge=require("bridge"),polling=require("bridge/plugin/android/polling"),callback=function(){if(!bridge.shuttingDown){if(bridge.UsePolling)return polling(),void 0;var xmlhttp=new XMLHttpRequest;xmlhttp.onreadystatechange=function(){if(4===xmlhttp.readyState){if(bridge.shuttingDown)return;if(200===xmlhttp.status){var msg=decodeURIComponent(xmlhttp.responseText);setTimeout(function(){try{var t=eval(msg)}catch(e){console.log("JSCallback: Message from Server: "+msg),console.log("JSCallback Error: "+e)}},1),setTimeout(callback,1)}else 404===xmlhttp.status?setTimeout(callback,10):403===xmlhttp.status?console.log("JSCallback Error: Invalid token.  Stopping callbacks."):503===xmlhttp.status?console.log("JSCallback Server Closed: Stopping callbacks."):400===xmlhttp.status?console.log("JSCallback Error: Bad request.  Stopping callbacks."):(console.log("JSCallback Error: Request failed."),bridge.UsePolling=!0,polling())}},null===port&&(port=prompt("getPort","gap_callbackServer:")),null===token&&(token=prompt("getToken","gap_callbackServer:")),xmlhttp.open("GET","http://127.0.0.1:"+port+"/"+token,!0),xmlhttp.send()}};module.exports=callback}),define("bridge/plugin/android/polling",function(require,exports,module){var bridge=require("bridge"),period=50,polling=function(){if(!bridge.shuttingDown){if(!bridge.UsePolling)return require("bridge/plugin/android/callback")(),void 0;var msg=prompt("","gap_poll:");msg?(setTimeout(function(){try{var t=eval(""+msg)}catch(e){console.log("JSCallbackPolling: Message from Server: "+msg),console.log("JSCallbackPolling Error: "+e)}},1),setTimeout(polling,1)):setTimeout(polling,period)}};module.exports=polling}),define("bridge/plugin/android/storage",function(e,t,n){function r(e,t){var n=l[e];if(n)try{delete l[e];var r=n.tx;if(console.log("method=completeQuery:query.tx"+n.sql),r&&r.queryList[e]){var o=new s;o.rows.resultSet=t,o.rows.length=t.length;try{"function"==typeof n.successCallback&&n.successCallback(n.tx,o)}catch(i){console.log("executeSql error calling user success callback: "+i)}r.queryComplete(e)}}catch(a){console.log("executeSql error: "+a)}}function o(e,t){var n=l[t];if(n)try{delete l[t];var r=n.tx;if(r&&r.queryList[t]){r.queryList={};try{"function"==typeof n.errorCallback&&n.errorCallback(n.tx,e)}catch(o){console.log("executeSql error calling user error callback: "+o)}r.queryFailed(t,e)}}catch(i){console.log("executeSql error: "+i)}}var i=e("bridge/utils"),a=e("bridge/exec");channel=e("bridge/channel");var l={},c=function(){this.resultSet=[],this.length=0};c.prototype.item=function(e){return this.resultSet[e]};var s=function(){this.rows=new c},u=function(e){this.id=i.createUUID(),l[this.id]=this,this.resultSet=[],this.tx=e,this.tx.queryList[this.id]=this,this.successCallback=null,this.errorCallback=null},d=function(){this.id=i.createUUID(),this.successCallback=null,this.errorCallback=null,this.queryList={}};d.prototype.queryComplete=function(e){if(delete this.queryList[e],this.successCallback){var t,n=0;for(t in this.queryList)this.queryList.hasOwnProperty(t)&&n++;if(0===n)try{this.successCallback()}catch(r){console.log("Transaction error calling user success callback: "+r)}}},d.prototype.queryFailed=function(e,t){if(this.queryList={},this.errorCallback)try{this.errorCallback(t)}catch(n){console.log("Transaction error calling user error callback: "+n)}},d.prototype.executeSql=function(e,t,n,r){"undefined"==typeof t&&(t=[]);var o=new u(this);o.sql=e,l[o.id]=o,o.successCallback=n,o.errorCallback=r,a(null,null,"Storage","executeSql",{query:e,params:t,tx_id:o.id})};var f=function(){};f.prototype.transaction=function(e,t,n){var r=new d;r.successCallback=n,r.errorCallback=t;try{e(r)}catch(o){if(console.log("Transaction error: "+o),r.errorCallback)try{r.errorCallback(o)}catch(i){console.log("Transaction error calling user error callback: "+o)}}};var E=function(e,t,n,r){a(null,null,"Storage","openDatabase",{name:e,version:t,displayName:n,size:r});var o=new f;return o},p=function(){function e(e){this.length=e,localStorage&&(localStorage.length=e)}console.log("7 ---- CupcakeLocalStorage"),channel.waitForInitialization("cupcakeStorage");try{this.db=openDatabase("localStorage","1.0","localStorage",2621440);var t={};this.length=0,this.db.transaction(function(n){n.executeSql("CREATE TABLE IF NOT EXISTS storage (id NVARCHAR(40) PRIMARY KEY, body NVARCHAR(65535))"),n.executeSql("SELECT * FROM storage",[],function(n,r){for(var o=0;o<r.rows.length;o++)t[r.rows.item(o).id]=r.rows.item(o).body;e(r.rows.length),console.log("7 ---- initializationComplete cupcakeStorage"),channel.initializationComplete("cupcakeStorage")})},function(e){i.alert(e.message)}),this.setItem=function(e,n){"undefined"==typeof t[e]&&this.length++,t[e]=n,this.db.transaction(function(t){t.executeSql("CREATE TABLE IF NOT EXISTS storage (id NVARCHAR(40) PRIMARY KEY, body NVARCHAR(65535))"),t.executeSql("REPLACE INTO storage (id, body) values(?,?)",[e,n])})},this.getItem=function(e){return t[e]},this.removeItem=function(e){delete t[e],this.length--,this.db.transaction(function(t){t.executeSql("CREATE TABLE IF NOT EXISTS storage (id NVARCHAR(40) PRIMARY KEY, body NVARCHAR(65535))"),t.executeSql("DELETE FROM storage where id=?",[e])})},this.clear=function(){t={},this.length=0,this.db.transaction(function(e){e.executeSql("CREATE TABLE IF NOT EXISTS storage (id NVARCHAR(40) PRIMARY KEY, body NVARCHAR(65535))"),e.executeSql("DELETE FROM storage",[])})},this.key=function(e){var n=0;for(var r in t){if(n==e)return r;n++}return null}}catch(n){return alert(n),i.alert("Database error "+n+"."),void 0}};n.exports={openDatabase:E,CupcakeLocalStorage:p,DIYLocalStorage:p,failQuery:o,completeQuery:r}}),define("bridge/utils",function(e,t,n){function r(e){for(var t="",n=0;e>n;n++){var r=parseInt(256*Math.random(),10).toString(16);1==r.length&&(r="0"+r),t+=r}return t}var o={clone:function(e){if(!e)return e;var t,n;if(e instanceof Array){for(t=[],n=0;n<e.length;++n)t.push(o.clone(e[n]));return t}if(e instanceof Function)return e;if(!(e instanceof Object))return e;if(e instanceof Date)return e;t={};for(n in e)n in t&&t[n]==e[n]||(t[n]=o.clone(e[n]));return t},close:function(e,t,n){return"undefined"==typeof n?function(){return t.apply(e,arguments)}:function(){return t.apply(e,n)}},createUUID:function(){return r(4)+"-"+r(2)+"-"+r(2)+"-"+r(2)+"-"+r(6)},extend:function(){var e=function(){};return function(t,n){e.prototype=n.prototype,t.prototype=new e,t.__super__=n.prototype,t.prototype.constructor=t}}(),alert:function(e){alert?alert(e):console&&console.log&&console.log(e)}};n.exports=o}),window.bridge=require("bridge"),function(){var e=require("bridge/channel"),t={boot:function(){console.log("1---boot"),document.addEventListener("DOMContentLoaded",function(){console.log("2---DOMContentLoaded fire in boot"),e.onDOMContentLoaded.fire()},!1),"complete"==document.readyState&&(console.log("2---DOMContentLoaded fire in boot document.readyState == 'complete'"),e.onDOMContentLoaded.fire()),e.join(function(){var t=require("bridge/platform");console.log("3--- platform.initialize()"),t.initialize(),console.log("4--- channel.onBridgeCoreReady.fire()"),e.onBridgeCoreReady.fire(),e.join(function(){console.log(" channel.onBridgeReady.fire()"),bridge.exec=require("bridge/execapi"),e.onBridgeReady.fire()},e.deviceReadyChannelsArray)},[e.onDOMContentLoaded,e.onNativeReady])}};e.onNativeReady.subscribeOnce(t.boot),window._nativeReady&&e.onNativeReady.fire()}(window)}();