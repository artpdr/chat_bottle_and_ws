<!DOCTYPE HTML>
<html>
<head>
    <title>ChatOn - A simple Chat made with bottle</title>
</head>
<body>

    <div>
        <p>Chat On for You!</p>
    </div>

    <div>
        <form action="/chat" method="POST">
            <label for="username">username: </label>
            <input type="text" name="username" id="username" placeholder="Insert a username for this session...">
        </form>

        <div id="error">
            % error = get('error', '')
            % if error:
                *{{error}}
            % end
        </div>
    </div>

</body>
</html>