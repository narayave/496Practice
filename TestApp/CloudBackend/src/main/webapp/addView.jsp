<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Address Book</title>

	<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>

	<script>
  		//reset type=date inputs to text
  		$( document ).bind( "mobileinit", function(){
    	$.mobile.page.prototype.options.degradeInputs.date = true;
  		});	
	</script>

	<script src="jquery-1.8.2.min.js"></script>
	<script>
	var MOBILE = navigator.userAgent.match(
                    /Android|BlackBerry|iPhone|iPad|iPod|IEMobile/i) ? true : false;
    if (MOBILE) { 
		document.write("<link rel=stylesheet href='http://code.jquery.com/mobile/1.2.0/jquery.mobile-1.2.0.min.css'>");
		document.write("<link rel=stylesheet href='mobilestyle.css'>");
		document.write('<s'+'cript src="jquery.mobile-1.8.2.min.js"></scr'+'ipt>');
	} else
		document.write("<link rel=stylesheet href='desktopstyle.css'>");
	</script>

</head>
<body>

<div data-role="page">

	<div data-role="header">
		<h1>Add a Contact</h1>
		<div data-role="navbar">
        	<ul>
            	<li><a href="contact.jsp" data-icon="info">Add a Contact</a></li>
            	<li><a href="addView.jsp" data-icon="grid">Address Book</a></li>
        	</ul>
    	</div><!-- /navbar -->
	</div>
	
		
	<div data-role="content" class="photolist">	
		<ul data-role="listview" data-inset="true" id="allitems"></ul>
	</div>
</div>

<div data-role="page" id="detailPage">
	<!-- This is for mobile --> 
	<div data-role="header">
		<h1 id="detailName">Name</h1>
	</div>
	<div data-role="header">
		<h2 id="detailAdd">Address</h2>
	</div>	
	<div data-role="header">
		<h2 id="detailCity">City</h2>
	</div>	
	<div data-role="header">
		<h2 id="detailState">State</h2>
	</div>
	<div data-role="header">
		<h2 id="detailEmail">Email</h2>
	</div>
	<div data-role="header">
		<h2 id="detailPhone">Phone Number</h2>
	</div>
	
	<div data-role="content" id="detailContent" class="photoViewer">	
		<img src="" id="detailPhoto">
	</div>
</div>

<script>
function addContactMobile(contactId, name, address, city, state, email, phone) {
	var anchor = $("<a/>").text(contact).attr('href', '#detailPage').click(function() { 	
		$("#detailName").text(name);
		$("#detailAdd").text(address);
		$("#detailCity").text(city);
		$("#detailState").text(state);
		$("#detailEmail").text(email);
		$("#detailPhone").text(number);
		$("#detailPhoto").attr('src', '');
		$("#detailPhoto").attr('src', 'contactView.jsp?contact='+contactId);
	
	});
	var li = $("<li/>").append(anchor);
	$("#allitems").append(li);
}

function addContactDesktop(contactId, name, address, city, state, email, phone) {
	var loc = $("#allitems");
	loc.append($("<div id='header' />").text(name));
	loc.append($("<div id='header' />").text(address));
	loc.append($("<div id='header' />").text(city));
	loc.append($("<div id='header' />").text(state));
	loc.append($("<div id='header' />").text(email));
	loc.append($("<div id='header' />").text(phone));
	
	loc.append($("<div />").append($("<img />").attr('src', 'viewimage.jsp?contact='+contactId)));
}

var addItem = MOBILE ? addItemMobile : addItemDesktop;

$.ajax({
	type:"GET",
	dataType:"json",
	url:"conViewAPI.jsp",
	success:function(contacts) {
		for (var i = 0; i < contacts.length; i++) {
			var contact = contacts[i];
			addItem(contact.id, contact.name, contact.address, 
					contact.city, contact.state, contact.email, 
					contact.phone);
		}
		$("#allitems").listview('refresh');
	},
	error:function(a,b,c) {
		alert("ERROR: "+a);
	}
});

</script>


</body>
</html>