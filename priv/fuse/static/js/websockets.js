(function(exports) {

  'use strict';

  var my = {},
    websocket,
    messages = 0;

	var init = exports.init = function() {
    document.getElementById('message_string').onkeypress=function(e){
        if(e.keyCode==13){
            sendMessage();
        }
    }
    document.getElementById('conn').addEventListener('click',connectSocket,false);
  }  
  function connect() {
    websocket = new WebSocket('ws://'+ window.location.host + '/ws');
    websocket.onopen = function(evt) { onOpen(evt) }; 
    websocket.onclose = function(evt) { onClose(evt) }; 
    websocket.onmessage = function(evt) { onMessage(evt) }; 
  };  

  function onMessage(evt) { 
    var message = JSON.parse(evt.data);
    if ( message.time !== undefined) {
      document.getElementById('server_time').innerHTML = message.time;
    }
    if(message.reply !== undefined) {
      document.getElementById('server_reply').innerHTML = message.reply;
    }
    if(message.nodes !== undefined) {
      document.getElementById('nodes_list').innerHTML = message.self+message.nodes;
    }
  };  

  function sendMessage(){
    var value = document.getElementById('message_string').value;
    var message = {'message': value};
    websocket.send(JSON.stringify(message));
  };

  function connectSocket(){
    var st = document.getElementById('server_time').innerHTML;
    if (st!='') {
      disconnect();
    } else {
      connect();
    }
  };

  function disconnect() {
    websocket.close();
    document.getElementById('conn_msg').innerHTML = "Conectar";
    document.getElementById('nodes_list').innerHTML = "";
    document.getElementById('server_time').innerHTML = "";
  }; 

  function onOpen(evt) { 
    document.getElementById('conn_msg').innerHTML = "Hora";
    updateStatus('Parar'); 
  };  

  function onClose(evt) { 
    updateStatus('Conectar');
  };  

  function updateStatus(txt) { 
    //document.getElementById('conn').innerHTML = txt;
  };

})(typeof exports === 'undefined'? this['websockets']={}: exports);
