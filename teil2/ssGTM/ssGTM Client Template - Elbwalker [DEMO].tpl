___INFO___

{
  "type": "CLIENT",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Elbwalker [DEMO]",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "Client zum Empfang von Elbwalker Events",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "cookieName",
    "displayName": "Cookie-Name",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "defaultValue": "IDCOOKIE",
    "alwaysInSummary": true
  }
]


___SANDBOXED_JS_FOR_SERVER___

const claimRequest = require('claimRequest');
const returnResponse = require('returnResponse');
const runContainer = require('runContainer');
const decodeUriComponent = require('decodeUriComponent');
const setPixelResponse = require('setPixelResponse');
const setResponseHeader = require('setResponseHeader');
const getRequestHeader = require('getRequestHeader');
const getRequestBody = require('getRequestBody');
const getRequestQueryParameter = require('getRequestQueryParameter');
const getRequestPath = require('getRequestPath');
const getCookie = require('getCookieValues');
const JSON = require('JSON');
const getRemoteAddress = require('getRemoteAddress');
const fromBase64 = require('fromBase64');
const logToConsole = require('logToConsole');

//Hilfsfunktionen
const createField = (event, fieldName, val) => {
  if (val) event[fieldName] = val;
};    

const requestPath = getRequestPath();

//Nur Hits der Version 3 verarbeiten
if (requestPath === '/elbwalker') {
  claimRequest();
  const ip = getRemoteAddress();
  const ua = getRequestHeader('user-agent');
  
  const ref = getRequestHeader('Referer');
  const lng = getRequestHeader('Accept-Language') || "";
  
  var objs =  getRequestBody();

  //Als Fallback aus dem GET Parameter auslesen, wenn z. B. als img-Tag aufgerufen 
  if (!objs) objs = getRequestQueryParameter('o');

  //Es kann eine Session-ID als Parameter angegeben werden, um die Sitzung aus einem SESSID-Cookie 
  //oder der PHP Session zu ueberschreiben
  const sid =  getRequestQueryParameter('s')||"666";
  var cid = getCookie(data.cookieName)[0] || getRequestQueryParameter('cid') || sid;
  var evtData;
  if (objs && objs != "") {
    if (objs.substring(0,1) == "{") evtData = JSON.parse(objs);
    else {
      //sind die Daten ggf. Base64 codiert? Dann decodieren und neu auslesen
      if (!evtData) evtData = JSON.parse(fromBase64(objs));
    }
  }  

  //ClientId aus der Nutzlast schlägt andere Varianten. Wenn dann noch leer, Konstante verwenden
  if (evtData && evtData.user) cid = evtData.user.device || evtData.user.hash || cid;
  var evName = evtData ? evtData.event||"elb_event" : "elb_nodata";
  evtData = evtData || {};
  var loc = (evtData.globals||{}).page_location || ref;
  
  var event = { anonymize_ip: true,
                event_name: evName,
                client_id : cid,
                ip_override : ip,
                user_agent : ua,
                page_location : loc
              };
  
  if (evtData.data)  {
    createField(event, "page_domain", evtData.data.domain);
    createField(event, "page_path", evtData.data.id);
    createField(event, "page_title", evtData.data.title);
  }

  if (evtData.user && evtData.user.id)  
    createField(event, "user_id", evtData.user.id);
 
  createField(event, "page_referrer", (evtData.globals||{}).page_referrer);
  createField(event, "client_timestamp", evtData.timestamp);
  createField(event, "event_category", evtData.entity);
  createField(event, "event_action", evtData.action);
  createField(event, "x-elb-event", evtData);

  //UA-proprietäre Eigenschaften setzen
  event['x-ga-js_client_id'] = cid;
  event['x-ga-mp2-seg'] = "1";
  event['x-ga-page_id'] = evtData.group;
  event['x-ga-request_count'] = evtData.count;
  event.ga_session_number = "1";
  event.ga_session_id = sid;
 
  //weitere (GA4) spezifische Angaben können hier hinzugefügt werden, wenn diese gesendet werden 
  //oder in einer erweiterten Fassung deses Templates als Felder gemapped werden o. Ä. - hier nur 
  //Standardwerte. Ebenso: nested E-Commerce Items etc. würden auch noch zu bearbeiten sein. 
  //für ein komplettes Parsing der eingehenden Objekte, wenn dafür keine Variablentemplates
  //erstellt werden sollen, die die Arbeit dann anhand des x-ga-elb-event erledigen. 
 
  runContainer(event, () => {  
    setPixelResponse();
    const origin = getRequestHeader('Origin');
    if (origin) {
      setResponseHeader('Access-Control-Allow-Origin', origin);
      setResponseHeader('Access-Control-Allow-Credentials', 'true');
    }
    returnResponse();    
  });
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "queryParametersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "remoteAddressAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "bodyAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "headersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "pathAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "queryParameterAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "return_response",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "run_container",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_response",
        "versionId": "1"
      },
      "param": [
        {
          "key": "writeResponseAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "writeHeaderAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 07.11.2022, 02:26:15