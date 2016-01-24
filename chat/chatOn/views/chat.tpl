<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="/static/css/chat_styles.css" rel="stylesheet"/>
    <script src="/static/jquery/jquery-2.2.0.js"></script>
    <title></title>
</head>
<body>

    <p>Logged in as: {{username}}</p>

    <!--shared board-->
    <div id="board_div">

    </div>

    <!--messages input-->
    <div id="msg_div">
        <form id="msg_form" action="" method="post">
            <label for="input_msg">Text to send: </label>
            <input type="text" id="input_msg" name="input_msg" placeholder="Insert a message">
        </form>
    </div>

    <script>
        //Code for Websockets
        var server_addr = "127.0.0.1";
        var server_port = "8080";
        var host = "ws://" + server_addr + ":" + server_port + "/websocket";

        if ("WebSocket" in window )
            var ws = new WebSocket ( host );
        else if ("MozWebSocket" in window )
            var ws = new MozWebSocket ( host );
        else
            $('html').href("Get a real browser which supports WebSocket...");

        ws.onopen = function() {
            ws.send('{{username}}');
            $(document).on('submit', '#msg_form', function(event){
                event.preventDefault();
                var message_to_send = $("#input_msg").val();
                if (message_to_send.trim() != ''){
                    ws.send(message_to_send);
                }
            });
        }

        ws.onmessage = function(msg) {
            $('#board_div').append('<p>'+ msg.data +'</p>')
        }
    </script>

</body>
</html>