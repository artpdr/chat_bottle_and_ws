<!DOCTYPE HTML>
<html>
<head>
    <title>ChatOn - A simple Chat made with bottle</title>
    <script src="/static/jquery/jquery-2.2.0.js"></script>
</head>
<body>

    <div>
        <p>Chat On for You!</p>
    </div>

    <div>
        <form id="send_user_name_form" action="/chat" method="POST">
            <label for="username">username: </label>
            <input type="text" name="username" id="username" placeholder="Insert a username for this session..." required>
        </form>

        <div id="error">
            % error = get('error', '')
            % if error:
                *{{error}}
            % end
        </div>
    </div>

    <script>
        $('#send_user_name_form').submit(function(event){
            event.preventDefault();
            var usr_val = $('#username').val();
            if (usr_val.search(' ') != -1){
                $('#error').html('*The username can\'t contain spaces!');
            }
            else if (usr_val.length == 0){
                $('#error').html('*The username can\'t be empty!');
            }
            else{
                $(this).off('submit');
                $(this).submit();
            }
        })
    </script>

</body>
</html>