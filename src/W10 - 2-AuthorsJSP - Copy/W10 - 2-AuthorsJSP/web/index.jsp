<!DOCTYPE html>
<!--
Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Html.html to edit this template
-->
<html>
    <head>
        <title>TODO supply a title</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <div><a href="AuthorsServlet">List Authors</a></div>

        <FORM ACTION="AuthorsServlet" METHOD="POST">
            First Name:
            <INPUT TYPE="TEXT" NAME="firstName" ><BR>
            Last Name:
            <INPUT TYPE="TEXT" NAME="lastName" ><P>
                <INPUT TYPE="SUBMIT"> <!-- Press this button to submit form -->
        </FORM>
    </body>
</html>
