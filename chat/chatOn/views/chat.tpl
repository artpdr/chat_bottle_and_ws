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
    <h2>Chat:</h2>
    <div id="board_div">

    </div>

    <!--users logged-->
    <h2>Users:</h2>
    <div id="users_logged_div">

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
            var prefix_message = 'msg:';
            var prefix_user_in = 'usr_in:';
            var prefix_user_out = 'usr_out';

            if(msg.data.indexOf(prefix_message) == 0){
                $('#board_div').append('<p>'+ msg.data.substr(4) +'</p>');
            }
            else if(msg.data.indexOf(prefix_user_in) == 0){
                var usr_names = msg.data.substr(7);
                var usr_names_array = usr_names.split(' ');
                var usr_format_html = '';
                var len_usr_names_array = usr_names_array.length;
                for (var i = 0; i < len_usr_names_array; i++) {
                    usr_format_html += '<div class = "user ' + usr_names_array[i] + '">' + usr_names_array[i] + '</div>'
                }
                $('#users_logged_div').html(usr_format_html);
            }
            else if(msg.data.indexOf(prefix_user_out) == 0){
                var usr_class_html = '.' + msg.data.substr(7);
                $(usr_class_html).remove();
            }
        }
    </script>

</body>
</html>