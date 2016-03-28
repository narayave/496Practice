<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Add Contact</title>

	<script src="form-validator/jquery-2.1.1.min.js"></script>
	<script src="form-validator/jquery.form-validator.min.js"></script>

	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.1.47/jquery.form-validator.min.js"></script>
	
	<script>
  		//reset type=date inputs to text
  		$( document ).bind( "mobileinit", function(){
    		$.mobile.page.prototype.options.degradeInputs.date = true;
  		});	
</script>

</head>
<body>

<div data-role="page" id="form">

	<div data-role="header">
		<h1>Add a Contact</h1>
		<div data-role="navbar">
        	<ul>
            	<li><a href="contact.jsp" data-icon="info">Add a Contact</a></li>
            	<li><a href="addView.jsp" data-icon="grid">Address Book</a></li>
        	</ul>
    	</div><!-- /navbar -->
	</div>
	
	
	<form method="post" enctype="multipart/form-data" action="contact.jsp">
		<table>
			<tr>
				<td id="errmsg" class="error" colspan="2"></td></tr>
			<tr>
				<td>Contact Name:</td><td>
				<input name="name" id="name" /></td></tr>
			<tr>
				<td>Address:</td><td>
				<input name="add" data-validation="length" data-validation-length="max100"></td></tr>
			<tr>
				<td>City:</td><td>
				<input name="city"></td></tr>
			<tr>
				<td>State:</td><td>
				<select name="state">
					<option value=""> </option>
					<option value="AL">Alabama</option>
					<option value="AK">Alaska</option>
					<option value="AZ">Arizona</option>
					<option value="AR">Arkansas</option>
					<option value="CA">California</option>
					<option value="CO">Colorado</option>
					<option value="CT">Connecticut</option>
					<option value="DE">Delaware</option>
					<option value="DC">District Of Columbia</option>
					<option value="FL">Florida</option>
					<option value="GA">Georgia</option>
					<option value="HI">Hawaii</option>
					<option value="ID">Idaho</option>
					<option value="IL">Illinois</option>
					<option value="IN">Indiana</option>
					<option value="IA">Iowa</option>
					<option value="KS">Kansas</option>
					<option value="KY">Kentucky</option>
					<option value="LA">Louisiana</option>
					<option value="ME">Maine</option>
					<option value="MD">Maryland</option>
					<option value="MA">Massachusetts</option>
					<option value="MI">Michigan</option>
					<option value="MN">Minnesota</option>
					<option value="MS">Mississippi</option>
					<option value="MO">Missouri</option>
					<option value="MT">Montana</option>
					<option value="NE">Nebraska</option>
					<option value="NV">Nevada</option>
					<option value="NH">New Hampshire</option>
					<option value="NJ">New Jersey</option>
					<option value="NM">New Mexico</option>
					<option value="NY">New York</option>
					<option value="NC">North Carolina</option>
					<option value="ND">North Dakota</option>
					<option value="OH">Ohio</option>
					<option value="OK">Oklahoma</option>
					<option value="OR">Oregon</option>
					<option value="PA">Pennsylvania</option>
					<option value="RI">Rhode Island</option>
					<option value="SC">South Carolina</option>
					<option value="SD">South Dakota</option>
					<option value="TN">Tennessee</option>
					<option value="TX">Texas</option>
					<option value="UT">Utah</option>
					<option value="VT">Vermont</option>
					<option value="VA">Virginia</option>
					<option value="WA">Washington</option>
					<option value="WV">West Virginia</option>
					<option value="WI">Wisconsin</option>
					<option value="WY">Wyoming</option>
				</select></td></tr>
			<tr>
				<td>Email:</td><td>
				<input name="email" id="email" data-validation="email" /></td></tr>
			<tr>
				<td>Phone Number:</td><td>
				<input name="phonenum" id="phone" /></td></tr>
			<tr>
				<td>Photo:</td><td>
				<input name="photo" type="file" data-validation="mime size" data-validation-allowing="jpg" data-validation-max-size="1mb"></td></tr>
			<tr>
				<td></td>
				<td><button type="submit" id="submit-6" class="ui-shadow ui-btn ui-corner-all ui-mini">
						Submit
					</button></td></tr>
		</table>
	</form>
	
	<script>
  		$.validate({
    		//validateOnBlur : true, // disable validation when input looses focus
    		//errorMessagePosition : 'top' // Instead of 'element' which is default
    		//scrollToTopOnError : false // Set this property to true if you have a long form
  		});
  	</script>

</div>

<%@ page import="java.util.*" %>
<%@ page import="javax.jdo.*" %>
<%@ page import="edu.oregonstate.backend.*" %>
<%@ page import="edu.oregonstate.backend.Contact" %>

<%
	PersistenceManager pmf = PMF.getPMF().getPersistenceManager();

	try {
		Map<String, Object> data = Util.read(request);
		
		String name = (String)data.get("name");
		String address = (String)data.get("add");
		String city = (String)data.get("ciy");
		String state = (String)data.get("state");
		String email = (String)data.get("email");
		String phone = (String)data.get("phonenum");
		byte[] photo = (byte[])data.get("photo[]");
		String photoName = (String)data.get("photo");
		
		Long userId = (Long)session.getAttribute("user");

		
		if (name == null) name = "";
		if (address == null) address = "";
		if (city == null) city = "";
		if (state == null) state="";
		if (email == null) email = "";
		if (phone == null) phone = ""; 
		if (photo == null) photo = new byte[0];
		if (photoName == null) photoName = "";
		
		String errorMessage = null;
		
		//boolean isPost = "POST".equals(request.getMethod());
		//String simpleEmailRegex = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
		//		+ "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
	
		if (userId == null) {
			//How did the user get in without logging in?
		} else if (name.length() > 0 &&
				  (address.length() < 0 || 
				  email.length() < 0 || 
				  phone.length() < 0 || 
				  photo.length > 1024 * 1024)){
			//User only entered name
			errorMessage = "You left out some field.";
		} else if(name.length() < 0 &&
				  (address.length() > 0 || 
				  email.length() > 0 || 
				  phone.length() > 0 || 
				  photo.length > 1024 * 1024)) {
			errorMessage = "You haven't entered the contact's name.";
		} else if (photo.length > 0 && !photoName.toLowerCase().endsWith(".jpg")) {
			errorMessage = "Make sure to upload a .jpg";
		} else if(name.length() > 0 && address.length() > 0 && 
				  email.length() > 0 && phone.length() > 0 && 
				  photo.length > 0) {
			
			Contact contact = new Contact();
			contact.setContactName(name);
			contact.setAddress(address);
			contact.setCity(city);
			contact.setState(state);
			contact.setEmail(email);
			contact.setPhoneNum(phone);
			contact.setPhoto(photo);
			
			contact.setUser(userId);
			
			pmf.makePersistent(contact);
			
			name = "";
			address = "";
			city = "";
			state = "";
			email = "";
			phone = "";
			photo = new byte[0];
		}
		
		
		//Still need to clean this up
		out.write("<script>");
		if (userId == null) {	
			out.write("location = 'login.jsp';");
		} else {
			if (errorMessage != null) 
				out.write("$('#errmsg').text('"+Util.clean(errorMessage)+"');");
			if (address.length() > 0)
				out.write("$('#address').val('"+Util.clean(address)+"');");
			if (email.length() > 0) 
				out.write("$('#email').val('"+Util.clean(email)+"');");
			if (name.length() > 0)
				out.write("$('#name').text('"+Util.clean(name)+"');");
		}					
		out.write("</script>");
	
	} finally {
		pmf.close();
	}
%>

</body>
</html>


