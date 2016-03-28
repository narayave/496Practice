<!DOCTYPE html>
<html lang="en">
<head>
	<meta name="keywords" content="jqxValidator, jQuery Validation, jQWidgets, Default Functionality" />
	<title>Login</title>
    <link rel="stylesheet" type="text/css" href="desktopstyle.css">

	<script src="jquery-1.8.2.min.js"></script>
	<script src="jquery.validate.js"></script>
	<script>
		$(function() {
			$("#logon").validate();
		});
	</script>

</head>
<body class='default'>
    <div id="login">
        <div><h2>Login</h2></div>
        <div>
            <form method="post" id="logon" action="login.jsp">
                <table>
                	<tr><td id="errmsg" class="error" colspan="2"></td></tr>
                    <tr><td>E-mail:</td>
                        <td><input name="email" type="text" id="emailInput" placeholder="someone@mail.com" class="text-input" /></td>
                    </tr>
                    <tr>
                        <td>Password:</td>
                        <td><input name="pass" type="password" id="passwordInput" class="text-input" /></td>
                    </tr>
                    <tr>
                        <td>(Enter only for new accounts)<BR>Confirm password:</td>
                        <td><input name="confirmpass" type="password" id="passwordConfirmInput" class="text-input" /></td>
                    </tr>
                    <tr>
                        <td> <input type="submit" value="Send" id="sendButton" colspan="3" style="text-align: center;"/> </td>
                    </tr>
                </table>
            </form>
        </div>
    </div>

<%@ page import="javax.jdo.*" %>
<%@ page import="java.util.regex.*" %>
<%@ page import="edu.oregonstate.backend.*" %>
<%@ page import="edu.oregonstate.backend.User" %>
<%@ page import="edu.oregonstate.backend.PMF" %>

<%
PersistenceManager pm = PMF.getPMF().getPersistenceManager();

try {

	session.setAttribute("user", null);

	String errorMessage = null;

	String email = request.getParameter("email");
	String pass = request.getParameter("pass");
	String confirm = request.getParameter("confirmpass");

	if (email == null) email = "";
	if (pass == null) pass = "";
	if (confirm == null) confirm = "";

	boolean isPost = "POST".equals(request.getMethod());
	String simpleEmailRegex = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
			+ "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";

	if (isPost && email.length() > 0 && !email.matches(simpleEmailRegex)) {
		errorMessage = "Invalid email address";
	} else if (email.length() > 0 && pass.length() > 0 && confirm.length() > 0) {  //Create new account
		if (!confirm.equals(pass)){
			errorMessage = "Sorry, password has a typo.";
		} else {
			boolean exists = User.usernameExists(email, pm);
			if (exists) {
				errorMessage = "Email is taken, use different email.";
			} else {
				User user = User.createAccount(email, pass);
				pm.makePersistent(user);
				session.setAttribute("user", user.getID());
			}
		}
	} else if (isPost && email.length() > 0 && pass.length() > 0) {
			//logging in
		User user = User.loadAccount(email, pass, pm);
		if (user == null) {
			errorMessage = "Sorry, email or password is wrong.";
		} else {
			session.setAttribute("user", user.getID());
		}
	} else {
			//Nothing has been updated
	}

	out.write("<script>");
	if (session.getAttribute("user") != null) {
		//out.write("location = 'contact.jsp?user='"+session.getAttribute("user")+"';");
		out.write("location = 'contact.jsp'");
	} else {
		if (errorMessage != null)
			out.write("$('#errmsg').text('"+Util.clean(errorMessage)+"');");
		if (email.length() > 0)
			out.write("$('#email').val('"+Util.clean(email)+"');");
	}
	out.write("</script>");

} finally {
	pm.close();
}

%>


</body>
</html>